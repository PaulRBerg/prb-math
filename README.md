# PRBMath [![Coverage Status](https://coveralls.io/repos/github/hifi-finance/prb-math/badge.svg?branch=main)](https://coveralls.io/github/hifi-finance/prb-math?branch=main) [![Styled with Prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://prettier.io) [![Commitizen Friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/) [![License: WTFPL](https://img.shields.io/badge/License-WTFPL-yellow.svg)](https://spdx.org/licenses/WTFPL.html)

**Smart contract library for advanced fixed-point math**, which operates with signed 59.18-decimal fixed-point and unsigned
60.18-decimal fixed-point numbers. The name of the number formats stems from the fact that there can be up to 59/60 digits
in the integer part and up to 18 decimals in the fractional part. The numbers are bound by the minimum and the maximum
values permitted by the Solidity types int256 and uint256.

- Designed for Solidity >=0.8.0
- Operates with signed and unsigned denary fixed-point numbers, with 18 trailing decimals
- Offers advanced math functions like logarithms, exponentials, powers and square roots
- Gas efficient, but still user-friendly
- Bakes in overflow-safe multiplication and division
- Well-documented via NatSpec comments
- Thoroughly tested with Hardhat and Waffle

I created this because I wanted a fixed-point math library that is at the same time practical, intuitive and efficient.
I looked at
[ABDKMath64x64](https://github.com/abdk-consulting/abdk-libraries-solidity/blob/d8817cb600381319992d7caa038bf4faceb1097f/ABDKMath64x64.md),
which is fast, but I didn't like that it operates with binary numbers and it limits the precision to int128. I then looked at
[Fixidity](https://github.com/CementDAO/Fixidity), which operates with denary numbers and has wide precision, but is slow
and susceptible to phantom overflow.

## Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties
and will not be liable for any loss, direct or indirect through continued use of this codebase.

## Installation

With yarn:

```sh
$ yarn add prb-math
```

Or npm:

```sh
npm install prb-math
```

## Usage

Once installed, you can use the libraries like this:

### PRBMathSD59x18.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "prb-math/contracts/PRBMathSD59x18.sol";

contract SignedConsumer {
  using PRBMathSD59x18 for int256;

  function signedLog2(int256 x) external pure returns (int256 result) {
    result = x.log2();
  }

  function signedExp(int256 x) external pure returns (int256 result) {
    result = x.exp();
  }

  /// @notice Calculates x*y÷1e18 while handling possible intermediary overflow.
  /// @dev Try this with x = type(int256).max and y = 5e17.
  function signedMul(int256 x, int256 y) external pure returns (int256 result) {
    result = x.mul(y);
  }

  /// @dev Assuming that 1e18 = 100% and 1e16 = 1%.
  function signedYield(int256 principal, int256 apr) external pure returns (int256 result) {
    result = principal.mul(apr);
  }
}

```

### PRBMathUD60x18.sol

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "prb-math/contracts/PRBMathUD60x18.sol";

contract UnsignedConsumer {
  using PRBMathUD60x18 for uint256;

  /// @dev Note that "x" must be greater than or equal to 1e18, lest the result would be negative, and negative
  /// numbers are not supported by the unsigned 60.18-decimal fixed-point representation.
  function unsignedLog2(uint256 x) external pure returns (uint256 result) {
    result = x.log2();
  }

  function unsignedExp(uint256 x) external pure returns (uint256 result) {
    result = x.exp();
  }

  /// @notice Calculates x*y÷1e18 while handling possible intermediary overflow.
  /// @dev Try this with x = type(uint256).max and y = 5e17.
  function unsignedMul(uint256 x, uint256 y) external pure returns (uint256 result) {
    result = x.mul(y);
  }

  /// @dev Assuming that 1e18 = 100% and 1e16 = 1%.
  function unsignedYield(uint256 principal, uint256 apr) external pure returns (uint256 result) {
    result = principal.mul(apr);
  }
}

```

## Gas Efficiency

PRBMath is faster than ABDKMath for `abs`, `exp`, `exp2`, `gm`, `inv`, `ln`,
`log2`. Conversely, PRBMath is slower than ABDKMath for `avg`, `div`, `mul`, `powu` and `sqrt`. There are
two technical reasons why PRBMath lags behind ABDKMath's `mul` and `div` functions:

1. PRBMath operates with 256-bit word sizes, so it has to account for possible intermediary overflow. ABDKMath operates with
   128-bit word sizes.
2. PRBMath rounds up instead of truncating in certain cases (see listing 6 and text above it in this
   [article](https://accu.org/index.php/journals/1717)), which makes it slightly more precise than ABDKMath but comes at a gas cost.

### PRBMath

Based on v1.0.0 of the library.

| SD59x18 | Min | Max   | Avg  |     | UD60x18 | Min  | Max   | Avg  |
| ------- | --- | ----- | ---- | --- | ------- | ---- | ----- | ---- |
| abs     | 68  | 72    | 70   |     | n/a     | n/a  | n/a   | n/a  |
| avg     | 57  | 57    | 57   |     | avg     | 57   | 57    | 57   |
| ceil    | 82  | 117   | 101  |     | ceil    | 78   | 78    | 78   |
| div     | 431 | 483   | 451  |     | div     | 205  | 205   | 205  |
| exp     | 35  | 3272  | 2507 |     | exp     | 2065 | 3220  | 2529 |
| exp2    | 63  | 2678  | 2113 |     | exp2    | 1784 | 2652  | 2112 |
| floor   | 82  | 117   | 101  |     | floor   | 43   | 43    | 43   |
| frac    | 23  | 23    | 23   |     | frac    | 23   | 23    | 23   |
| gm      | 26  | 892   | 690  |     | gm      | 26   | 893   | 691  |
| inv     | 40  | 40    | 40   |     | inv     | 40   | 40    | 40   |
| ln      | 463 | 7306  | 4724 |     | ln      | 419  | 6902  | 3814 |
| log10   | 104 | 9074  | 4337 |     | log10   | 503  | 8695  | 4571 |
| log2    | 377 | 7241  | 4243 |     | log2    | 330  | 6825  | 3426 |
| mul     | 455 | 463   | 459  |     | mul     | 219  | 275   | 247  |
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

## Contributing

Familiarity with Hardhat, Ethers and Waffle and TypeScript is requisite.

### Pre Requisites

Before running any command, make sure to install dependencies:

```sh
$ yarn install
```

### Compile

Compile the smart contracts with Hardhat:

```sh
$ yarn compile
```

### TypeChain

Compile the smart contracts and generate TypeChain artifacts:

```sh
$ yarn typechain
```

### Lint Solidity

Lint the Solidity code:

```sh
$ yarn lint:sol
```

### Lint TypeScript

Lint the TypeScript code:

```sh
$ yarn lint:ts
```

### Test

Run the Mocha tests:

```sh
$ yarn test
```

### Coverage

Generate the code coverage report:

```sh
$ yarn coverage
```

### Clean

Delete the smart contract artifacts, the coverage reports and the Hardhat cache:

```sh
$ yarn clean
```

## Security

While I set a high bar for code quality and test coverage, you shouldn't assume that this library is completely safe to use. The contracts
have not been audited by a security researcher. If you discover any security issues, please report them via [Keybase](https://keybase.io/paulrberg).

## Acknowledgements

I am grateful to:

- Mikhail Vladimirov for the insights he shared in his [Math in
  Solidity](https://medium.com/coinmonks/math-in-solidity-part-1-numbers-384c8377f26d) series.
- Remco Bloemen for his work on [overflow-safe multiplication and division](https://xn--2-umb.com/21/muldiv/) and
  for responding to the questions I asked him while developing the library.

## License

The library is released under the [WTFPL License](./LICENSE.md).
