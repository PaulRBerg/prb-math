# PRBMath [![GitHub Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![Styled with Prettier][prettier-badge]][prettier] [![License: MIT][license-badge]][license]

[gha]: https://github.com/paulrberg/prb-math/actions
[gha-badge]: https://github.com/paulrberg/prb-math/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[prettier]: https://prettier.io
[prettier-badge]: https://img.shields.io/badge/Code_Style-Prettier-ff69b4.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

**Solidity library for advanced fixed-point math** that operates with signed 59.18-decimal fixed-point and unsigned
60.18-decimal fixed-point numbers. The name of the number format is due to the integer part having up to 59/60 decimals
and the fractional part having up to 18 decimals. The numbers are bound by the minimum and the maximum values permitted
by the Solidity types int256 and uint256.

- Operates with signed and unsigned denary fixed-point numbers, with 18 trailing decimals
- Offers advanced math functions like logarithms, exponentials, powers and square roots
- Provides type safety via user defined value types
- Gas efficient, but still user-friendly
- Ergonomic developer experience thanks to using free functions instead of libraries
- Bakes in overflow-safe multiplication and division
- Reverts with custom errors instead of reason strings
- Well-documented via NatSpec comments
- Built and tested with Foundry

I created this because I wanted a fixed-point math library that is at the same time practical, intuitive and efficient.
I looked at [ABDKMath64x64][abdk-math], which is fast, but I really didn't like that it operates with binary numbers and
it limits the precision to int128. Binary numbers are counter-intuitive and non-familiar to humans. I then looked at
[Fixidity](https://github.com/CementDAO/Fixidity), which operates with denary numbers and has wide precision, but is
slow and susceptible to phantom overflow.

## Install

### Foundry

First, run the install step:

```sh
forge install --no-commit paulrberg/prb-math
```

Then, add this to your `remappings.txt` file:

```text
@prb/math/=lib/prb-math/src/
```

### Node.js

```sh
yarn add @prb/math
# or
npm install @prb/math
```

## Usage

PRBMath comes in two flavors:

1. SD59x18 (signed)
2. UD60x18 (unsigned)

If you don't need negative numbers, there is no need to use the signed flavor. The unsigned flavor is more gas
efficient.

### SD59x18.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { SD59x18, UNIT } from "@prb/math/SD59x18.sol";

contract SignedConsumer {
  /// @notice Calculates 5% of the given signed number.
  /// @dev Try this with x = 400e18.
  function signedPercentage(SD59x18 x) external pure returns (SD59x18 result) {
    SD9x18 fivePercent = 0.05e18;
    result = x.mul(fivePercent).div(UNIT); // UNIT = 1e18
  }

  /// @notice Calculates the binary logarithm of the given signed number.
  /// @dev Try this with x = 128e18.
  function signedLog2(SD59x18 x) external pure returns (SD59x18 result) {
    result = x.log2();
  }
}

```

### UD60x18.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { UD60x18, UNIT } from "@prb/math/UD60x18.sol";

contract UnsignedConsumer {
  /// @notice Calculates 5% of the given signed number.
  /// @dev Try this with x = 400e18.
  function signedPercentage(UD60x18 x) external pure returns (UD60x18 result) {
    UD60x18 fivePercent = 0.05e18;
    result = x.mul(fivePercent).div(UNIT); // UNIT = 1e18
  }

  /// @notice Calculates the binary logarithm of the given signed number.
  /// @dev Try this with x = 128e18.
  function signedLog2(UD60x18 x) external pure returns (UD60x18 result) {
    result = x.log2();
  }
}

```

## Compiler

PRBMath can only be used in [Solidity v0.8.13][solidity-v0.8.13] and above, because it makes use of the [user-defined
value types][udvt] introduced in Solidity v0.8.8, and the [`using ... for T global`][solidity-v0.8.13] directive
introduced in Solidity v0.8.13.

While this means that PRBMath cannot be used in older versions of Solidity, these two features combined give users type
safety and an ergonomic developer experience. Notice the lack of the `using for` directive in the examples above.

## Gas Efficiency

PRBMath is faster than ABDKMath for `abs`, `exp`, `exp2`, `gm`, `inv`, `ln`, `log2`, but it is slower than ABDKMath for
`avg`, `div`, `mul`, `powu` and `sqrt`.

The main reason why PRBMath lags behind ABDKMath's `mul` and `div` functions is that it operates with 256-bit word
sizes, and so it has to account for possible intermediary overflow. ABDKMath, on the other hand, operates with 128-bit
word sizes.

### PRBMath

Based on the [v2.0.1](https://github.com/paulrberg/prb-math/releases/tag/v2.0.1) release.

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

Based on v3.0 of the library. See my [abdk-gas-estimations](https://github.com/paulrberg/abdk-gas-estimations).

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

## Contributing

Feel free to dive in! [Open](https://github.com/paulrberb/prb-math/issues/new) an issue,
[start](https://github.com/paulrberb/prb-math/discussions/new) a discussion or submit a PR.

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.Js](https://nodejs.org/en/download/)
- [Yarn](https://yarnpkg.com/)

In addition, familiarity with [Solidity](https://soliditylang.org/) is requisite.

### Set Up

Clone this repository including submodules:

```sh
$ git clone --recurse-submodules -j8 git@github.com:paulrberg/prb-math.git
```

Then, inside the project's directory, run this to install the Node.js dependencies:

```sh
$ yarn install
```

Now you can start making changes.

## Security

While I set a high bar for code quality and test coverage, you should not assume that this project is completely safe to
use. PRBMath has not been audited by a security researcher.

### Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties and
will not be liable for any loss, direct or indirect through continued use of this codebase.

### Contact

If you discover any bugs or security issues, please report them via [Telegram](https://t.me/paulrberg).

## Acknowledgements

- Mikhail Vladimirov for the insights he shared in his
  [Math in Solidity](https://medium.com/coinmonks/math-in-solidity-part-1-numbers-384c8377f26d) series.
- Remco Bloemen for his work on [overflow-safe multiplication and division](https://xn--2-umb.com/21/muldiv/) and for
  responding to the questions I asked him while developing the library.
- Everyone who contributed a PR to this repository.

## License

[MIT](./LICENSE.md)

<!-- Links -->

[abdk-math]: https://github.com/abdk-consulting/abdk-libraries-solidity
[solidity-v0.8.13]: https://blog.soliditylang.org/2022/03/16/solidity-0.8.13-release-announcement/
[udvt]: https://blog.soliditylang.org/2021/09/27/user-defined-value-types/
