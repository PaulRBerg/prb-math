# PRBMath [![GitHub Actions][gha-badge]][gha] [![Coverage Status][coveralls-badge]][coveralls] [![Styled with Prettier][prettier-badge]][prettier] [![License: Unlicense][license-badge]][license]

[gha]: https://github.com/paulrberg/prb-math/actions
[gha-badge]: https://github.com/paulrberg/prb-math/actions/workflows/integration.yml/badge.svg
[coveralls]: https://coveralls.io/github/paulrberg/prb-math
[coveralls-badge]: https://coveralls.io/repos/github/paulrberg/prb-math/badge.svg?branch=main
[prettier]: https://prettier.io
[prettier-badge]: https://img.shields.io/badge/Code_Style-Prettier-ff69b4.svg
[license]: https://unlicense.org/
[license-badge]: https://img.shields.io/badge/License-Unlicense-blue.svg

**Smart contract library for advanced fixed-point math** that operates with signed 59.18-decimal fixed-point and
unsigned 60.18-decimal fixed-point numbers. The name of the number formats stems from the fact that there can be up to
59/60 digits in the integer part and up to 18 decimals in the fractional part. The numbers are bound by the minimum and
the maximum values permitted by the Solidity types int256 and uint256.

- Operates with signed and unsigned denary fixed-point numbers, with 18 trailing decimals
- Offers advanced math functions like logarithms, exponentials, powers and square roots
- Gas efficient, but still user-friendly
- Bakes in overflow-safe multiplication and division
- Reverts with custom errors instead of reason strings
- Well-documented via NatSpec comments
- Thoroughly tested with Hardhat and Waffle

I created this because I wanted a fixed-point math library that is at the same time practical, intuitive and efficient.
I looked at
[ABDKMath64x64](https://github.com/abdk-consulting/abdk-libraries-solidity/blob/d8817cb600381319992d7caa038bf4faceb1097f/ABDKMath64x64.md),
which is fast, but I didn't like that it operates with binary numbers and it limits the precision to int128. I then
looked at [Fixidity](https://github.com/CementDAO/Fixidity), which operates with denary numbers and has wide precision,
but is slow and susceptible to phantom overflow.

## Install

With yarn:

```bash
$ yarn add @prb/math
```

Or npm:

```bash
$ npm install @prb/math
```

## Usage

PRBMath makes heavy use of the
[user-defined value types](https://blog.soliditylang.org/2021/09/27/user-defined-value-types/) added in Solidity v0.8.8
and the [using ... for T global](https://blog.soliditylang.org/2022/03/16/solidity-0.8.13-release-announcement/)
directive introduced in Solidity v0.8.13. Thus, the library cannot be used in Solidity v0.8.12 and below.

### SD59x18.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { SD59x18 } from "@prb/math/contracts/SD59x18.sol";

contract SignedConsumer {
  function signedLog2(SD59x18 x) external pure returns (SD59x18 result) {
    result = x.log2();
  }

  /// @notice Calculates x*y÷1e18 while handling possible intermediary overflow.
  /// @dev Try this with x = type(int256).max and y = 5e17.
  function signedMul(SD59x18 x, SD59x18 y) external pure returns (SD59x18 result) {
    result = x.mul(y);
  }

  /// @dev Assuming that 1e18 = 100% and 1e16 = 1%.
  function signedYield(SD59x18 principal, SD59x18 apr) external pure returns (SD59x18 result) {
    result = principal.mul(apr);
  }
}

```

### UD60x18.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { UD60x18 } from "@prb/math/contracts/UD60x18.sol";

contract UnsignedConsumer {
  /// @dev Note that "x" must be greater than or equal to 1e18, because UD60x18 does not support negative numbers.
  function unsignedLog2(UD60x18 x) external pure returns (UD60x18 result) {
    result = x.log2();
  }

  /// @notice Calculates x*y÷1e18 while handling possible intermediary overflow.
  /// @dev Try this with x = type(uint256).max and y = 5e17.
  function unsignedMul(UD60x18 x, UD60x18 y) external pure returns (UD60x18 result) {
    result = x.mul(y);
  }

  /// @dev Assuming that 1e18 = 100% and 1e16 = 1%.
  function unsignedYield(UD60x18 principal, UD60x18 apr) external pure returns (UD60x18 result) {
    result = principal.mul(apr);
  }
}

```

### JavaScript SDK

PRBMath is accompanied by a JavaScript SDK. Whatever functions there are in the Solidity library, you should find them
replicated in the SDK. The only exception are the converter functions `fromSD59x18`, `fromUD60x18`, `toSD59x18` and
`toUD60x18`. For conversion, you can use [evm-bn](https://github.com/paulrberg/evm-bn).

Here is an example for how to calculate the binary logarithm:

```typescript
import type { BigNumber } from "@ethersproject/bignumber";
import { log2 } from "@prb/math";
import { fromBn, toBn } from "evm-bn";

(async function () {
  const x: BigNumber = toBn("16");
  const result: BigNumber = log2(x);
  console.log({ result: fromBn(result) });
})();
```

Pro tip: see how the SDK is used in the [tests](./test/contracts) for PRBMath.

## Gas Efficiency

PRBMath is faster than ABDKMath for `abs`, `exp`, `exp2`, `gm`, `inv`, `ln`, `log2`. Conversely, it is slower than
ABDKMath for `avg`, `div`, `mul`, `powu` and `sqrt`. There are two technical reasons why PRBMath lags behind ABDKMath's
`mul` and `div` functions:

1. PRBMath operates with 256-bit word sizes, so it has to account for possible intermediary overflow. ABDKMath operates
   with 128-bit word sizes.
2. PRBMath rounds up instead of truncating in certain cases (see listing 6 and text above it in this
   [article](https://accu.org/index.php/journals/1717)). THis makes it slightly more precise than ABDKMath but comes at
   a gas cost.

### PRBMath

Based on the v2.0.1 of the library.

| SD59x18 | Min | Max   | Avg  |     | UD60x18 | Min  | Max   | Avg  |
| ------- | --- | ----- | ---- | --- | ------- | ---- | ----- | ---- |
| abs     | 68  | 72    | 70   |     | n/a     | n/a  | n/a   | n/a  |
| avg     | 57  | 57    | 57   |     | avg     | 57   | 57    | 57   |
| ceil    | 82  | 117   | 101  |     | ceil    | 78   | 78    | 78   |
| div     | 431 | 483   | 451  |     | div     | 205  | 205   | 205  |
| exp     | 38  | 2797  | 2263 |     | exp     | 1874 | 2742  | 2244 |
| exp2    | 63  | 2678  | 2104 |     | exp2    | 1784 | 2652  | 2156 |
| floor   | 82  | 117   | 101  |     | floor   | 43   | 43    | 43   |
| frac    | 23  | 23    | 23   |     | frac    | 23   | 23    | 23   |
| gm      | 26  | 892   | 690  |     | gm      | 26   | 893   | 691  |
| inv     | 40  | 40    | 40   |     | inv     | 40   | 40    | 40   |
| ln      | 463 | 7306  | 4724 |     | ln      | 419  | 6902  | 3814 |
| log10   | 104 | 9074  | 4337 |     | log10   | 503  | 8695  | 4571 |
| log2    | 377 | 7241  | 4243 |     | log2    | 330  | 6825  | 3426 |
| mul     | 455 | 463   | 459  |     | mul     | 219  | 275   | 247  |
| pow     | 64  | 11338 | 8518 |     | pow     | 64   | 10637 | 6635 |
| powu    | 293 | 24745 | 5681 |     | powu    | 83   | 24535 | 5471 |
| sqrt    | 140 | 839   | 716  |     | sqrt    | 114  | 846   | 710  |

### ABDKMath64x64

Based on v3.0 of the library. See [abdk-gas-estimations](https://github.com/paulrberg/abdk-gas-estimations).

| Method | Min  | Max  | Avg  |
| ------ | ---- | ---- | ---- |
| abs    | 88   | 92   | 90   |
| avg    | 41   | 41   | 41   |
| div    | 168  | 168  | 168  |
| exp    | 77   | 3780 | 2687 |
| exp2   | 77   | 3600 | 2746 |
| gavg   | 166  | 875  | 719  |
| inv    | 157  | 157  | 157  |
| ln     | 7074 | 7164 | 7126 |
| log2   | 6972 | 7062 | 7024 |
| mul    | 111  | 111  | 111  |
| pow    | 303  | 4740 | 1792 |
| sqrt   | 129  | 809  | 699  |

## Security

While I set a high bar for code quality and test coverage, you should not assume that this project is completely safe to
use. The contracts have not been audited by a security researcher.

### Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties and
will not be liable for any loss, direct or indirect through continued use of this codebase.

### Contact

If you discover any security issues, please report them via [Keybase](https://keybase.io/paulrberg).

## Acknowledgements

- Mikhail Vladimirov for the insights he shared in his
  [Math in Solidity](https://medium.com/coinmonks/math-in-solidity-part-1-numbers-384c8377f26d) series.
- Remco Bloemen for his work on [overflow-safe multiplication and division](https://xn--2-umb.com/21/muldiv/) and for
  responding to the questions I asked him while developing the library.

## License

[Unlicense](./LICENSE.md)
