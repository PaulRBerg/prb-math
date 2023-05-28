# PRBMath [![GitHub Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gha]: https://github.com/PaulRBerg/prb-math/actions
[gha-badge]: https://github.com/PaulRBerg/prb-math/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

**Solidity library for advanced fixed-point math** that operates with signed 59.18-decimal fixed-point and unsigned 60.18-decimal fixed-point numbers.
The name of the number format is due to the integer part having up to 59/60 decimals and the fractional part having up to 18 decimals. The numbers are
bound by the minimum and the maximum values permitted by the Solidity types int256 and uint256.

- Operates with signed and unsigned denary fixed-point numbers, with 18 trailing decimals
- Offers advanced math functions like logarithms, exponentials, powers and square roots
- Provides type safety via user-defined value types
- Gas efficient, but still user-friendly
- Ergonomic developer experience thanks to using free functions instead of libraries
- Bakes in overflow-safe multiplication and division via `mulDiv`
- Reverts with custom errors instead of reason strings
- Well-documented with NatSpec comments
- Built and tested with Foundry

I created this because I wanted a fixed-point math library that is at the same time intuitive, efficient and safe. I looked at
[ABDKMath64x64](https://github.com/abdk-consulting/abdk-libraries-solidity), which is fast, but it uses binary numbers which are counter-intuitive and
non-familiar to humans. Then, I looked at [Fixidity](https://github.com/CementDAO/Fixidity), which operates with denary numbers and has wide
precision, but is slow and susceptible to phantom overflow. Finally, I looked at [Solmate](https://github.com/transmissions11/solmate), which checks
all the boxes mentioned thus far, but it doesn't offer type safety.

## Install

### Foundry

First, run the install step:

```sh
forge install PaulRBerg/prb-math@release-v4
```

Then, add this to your `remappings.txt` file:

```text
@prb/math/=lib/prb-math/src/
```

### Node.js

```sh
pnpm add @prb/math
```

## Usage

There are two user-defined value types:

1. SD59x18 (signed)
2. UD60x18 (unsigned)

If you don't know what a user-defined value type is, check out this [blog post](https://blog.soliditylang.org/2021/09/27/user-defined-value-types/).

If you don't need negative numbers, there's no point in using the signed flavor `SD59x18`. The unsigned flavor `UD60x18` is more gas efficient.

Note that PRBMath is not a library in the Solidity [sense](https://docs.soliditylang.org/en/v0.8.17/contracts.html#libraries). It's just a collection
of free functions.

### Importing

It is recommended that you import PRBMath using specific symbols. Importing full files can result in Solidity complaining about duplicate definitions
and static analyzers like Slither erroring, especially as repos grow and have more dependencies with overlapping names.

```solidity
pragma solidity >=0.8.19;

import { SD59x18 } from "@prb/math/SD59x18.sol";
import { UD60x18 } from "@prb/math/UD60x18.sol";
```

Any function that is not available in the types directly has to be imported explicitly. Here's an example for the `sd` and the `ud` functions:

```solidity
pragma solidity >=0.8.19;

import { SD59x18, sd } from "@prb/math/SD59x18.sol";
import { UD60x18, ud } from "@prb/math/UD60x18.sol";
```

Note that PRBMath can only be used in Solidity v0.8.19 and above.

### SD59x18

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { SD59x18, sd } from "@prb/math/SD59x18.sol";

contract SignedConsumer {
  /// @notice Calculates 5% of the given signed number.
  /// @dev Try this with x = 400e18.
  function signedPercentage(SD59x18 x) external pure returns (SD59x18 result) {
    SD59x18 fivePercent = sd(0.05e18);
    result = x.mul(fivePercent);
  }

  /// @notice Calculates the binary logarithm of the given signed number.
  /// @dev Try this with x = 128e18.
  function signedLog2(SD59x18 x) external pure returns (SD59x18 result) {
    result = x.log2();
  }
}
```

### UD60x18

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { UD60x18, ud } from "@prb/math/UD60x18.sol";

contract UnsignedConsumer {
  /// @notice Calculates 5% of the given signed number.
  /// @dev Try this with x = 400e18.
  function unsignedPercentage(UD60x18 x) external pure returns (UD60x18 result) {
    UD60x18 fivePercent = ud(0.05e18);
    result = x.mul(fivePercent);
  }

  /// @notice Calculates the binary logarithm of the given signed number.
  /// @dev Try this with x = 128e18.
  function unsignedLog2(UD60x18 x) external pure returns (UD60x18 result) {
    result = x.log2();
  }
}
```

## Features

Because there's significant overlap between the features available in SD59x18 and UD60x18, there is only one table per section. If in doubt, refer to
the source code, which is well-documented with NatSpec comments.

### Mathematical Functions

| Name    | Operator | Description                                      |
| ------- | -------- | ------------------------------------------------ |
| `abs`   | N/A      | Absolute value                                   |
| `avg`   | N/A      | Arithmetic average                               |
| `ceil`  | N/A      | Smallest whole number greater than or equal to x |
| `div`   | `/`      | Fixed-point division                             |
| `exp`   | N/A      | Natural exponential e^x                          |
| `exp2`  | N/A      | Binary exponential 2^x                           |
| `floor` | N/A      | Greatest whole number less than or equal to x    |
| `frac`  | N/A      | Fractional part                                  |
| `gm`    | N/A      | Geometric mean                                   |
| `inv`   | N/A      | Inverse 1÷x                                      |
| `ln`    | N/A      | Natural logarithm ln(x)                          |
| `log10` | N/A      | Common logarithm log10(x)                        |
| `log2`  | N/A      | Binary logarithm log2(x)                         |
| `mul`   | `*`      | Fixed-point multiplication                       |
| `pow`   | N/A      | Power function x^y                               |
| `powu`  | N/A      | Power function x^y with y simple integer         |
| `sqrt`  | N/A      | Square root                                      |

### Adjacent Value Types

PRBMath provides adjacent value types that serve as abstractions over other vanilla types such as `int64`. The types currently available are:

| Value Type | Underlying Type |
| ---------- | --------------- |
| `SD1x18`   | int64           |
| `UD2x18`   | uint64          |

These are useful if you want to save gas by using a lower bit width integer, e.g. in a struct.

Note that these types don't have any mathematical functionality. To do math with them, you will have to unwrap them into a simple integer and then to
the core types `SD59x18` and `UD60x18`.

### Casting Functions

All PRBMath types have casting functions to and from all other types, including a few basic types like `uint128` and `uint40`.

| Name          | Description               |
| ------------- | ------------------------- |
| `intoSD1x18`  | Casts a number to SD1x18  |
| `intoSD59x18` | Casts a number to SD59x18 |
| `intoUD2x18`  | Casts a number to UD2x18  |
| `intoUD60x18` | Casts a number to UD60x18 |
| `intoUint256` | Casts a number to uint256 |
| `intoUint128` | Casts a number to uint128 |
| `intoUint40`  | Casts a number to uint40  |
| `sd1x18`      | Alias for `SD1x18.wrap`   |
| `sd59x18`     | Alias for `SD59x18.wrap`  |
| `ud2x18`      | Alias for `UD2x18.wrap`   |
| `ud60x18`     | Alias for `UD60x18.wrap`  |

### Conversion Functions

The difference between "conversion" and "casting" is that conversion functions multiply or divide the inputs, whereas casting functions simply cast
them.

| Name               | Description                                                           |
| ------------------ | --------------------------------------------------------------------- |
| `convert(SD59x18)` | Converts an SD59x18 number to a simple integer by dividing it by 1e18 |
| `convert(UD60x18)` | Converts a UD60x18 number to a simple integer by dividing it by 1e18  |
| `convert(int256)`  | Converts a simple integer to SD59x18 by multiplying it by 1e18        |
| `convert(uint256)` | Converts a simple integer to UD60x18 type by multiplying it by 1e18   |

### Helper Functions

In addition to offering mathematical, casting, and conversion functions, PRBMath provides numerous helper functions for user-defined value types:

| Name           | Operator | Description               |
| -------------- | -------- | ------------------------- |
| `add`          | `+`      | Checked addition          |
| `and`          | `&`      | Logical AND               |
| `eq`           | `==`     | Equality                  |
| `gt`           | `>`      | Greater than operator     |
| `gte`          | `>=`     | Greater than or equal to  |
| `isZero`       | N/A      | Check if a number is zero |
| `lshift`       | N/A      | Bitwise left shift        |
| `lt`           | `<`      | Less than                 |
| `lte`          | `<=`     | Less than or equal to     |
| `mod`          | `%`      | Modulo                    |
| `neq`          | `!=`     | Not equal operator        |
| `not`          | `~`      | Negation operator         |
| `or`           | `\|`     | Logical OR                |
| `rshift`       | N/A      | Bitwise right shift       |
| `sub`          | `-`      | Checked subtraction       |
| `unary`        | `-`      | Checked unary             |
| `uncheckedAdd` | N/A      | Unchecked addition        |
| `uncheckedSub` | N/A      | Unchecked subtraction     |
| `xor`          | `^`      | Exclusive or (XOR)        |

These helpers are designed to streamline basic operations such as addition and equality checks, eliminating the need to constantly unwrap and re-wrap
variables. However, it is important to be aware that utilizing these functions may result in increased gas costs compared to unwrapping and directly
using the vanilla types.

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { UD60x18, ud } from "@prb/math/UD60x18.sol";

function addRshiftEq() pure returns (bool result) {
  UD60x18 x = ud(1e18);
  UD60x18 y = ud(3e18);
  y = y.add(x); // also: y = y + x
  y = y.rshift(2);
  result = x.eq(y); // also: y == x
}

```

### Assertions

PRBMath comes with typed assertions that you can use for writing tests with [PRBTest](https://github.com/PaulRBerg/prb-test), which is based on
Foundry. This is useful if, for example, you would like to assert that two UD60x18 numbers are equal.

```solidity
pragma solidity >=0.8.19;

import { UD60x18, ud } from "@prb/math/UD60x18.sol";
import { Assertions as PRBMathAssertions } from "@prb/math/test/Assertions.sol";
import { PRBTest } from "@prb/math/test/PRBTest.sol";

contract MyTest is PRBTest, PRBMathAssertions {
  function testAdd() external {
    UD60x18 x = ud(1e18);
    UD60x18 y = ud(2e18);
    UD60x18 z = ud(3e18);
    assertEq(x.add(y), z);
  }
}
```

## Gas Efficiency

PRBMath is faster than ABDKMath for `abs`, `exp`, `exp2`, `gm`, `inv`, `ln`, `log2`, but it is slower than ABDKMath for `avg`, `div`, `mul`, `powu`
and `sqrt`.

The main reason why PRBMath lags behind ABDKMath's `mul` and `div` functions is that it operates with 256-bit word sizes, and so it has to account for
possible intermediary overflow. ABDKMath, on the other hand, operates with 128-bit word sizes.

**Note**: I did not find a good way to automatically generate gas reports for PRBMath. See the
[#134](https://github.com/PaulRBerg/prb-math/discussions/134) discussion for more details about this issue.

### PRBMath

Gas estimations based on the [v2.0.1](https://github.com/PaulRBerg/prb-math/releases/tag/v2.0.1) and the
[v3.0.0](https://github.com/PaulRBerg/prb-math/releases/tag/v3.0.0) releases.

| SD59x18 | Min | Max   | Avg  |     | UD60x18 | Min  | Max   | Avg  |
| ------- | --- | ----- | ---- | --- | ------- | ---- | ----- | ---- |
| abs     | 68  | 72    | 70   |     | n/a     | n/a  | n/a   | n/a  |
| avg     | 95  | 105   | 100  |     | avg     | 57   | 57    | 57   |
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

Gas estimations based on the v3.0 release of ABDKMath. See my [abdk-gas-estimations](https://github.com/PaulRBerg/abdk-gas-estimations) repo.

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

Feel free to dive in! [Open](https://github.com/PaulRBerg/prb-math/issues/new) an issue,
[start](https://github.com/PaulRBerg/prb-math/discussions/new) a discussion or submit a PR.

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.Js](https://nodejs.org/en/download/)
- [Pnpm](https://pnpm.io)

In addition, familiarity with [Solidity](https://soliditylang.org/) is requisite.

### Set Up

Clone this repository including submodules:

```sh
$ git clone --recurse-submodules -j8 git@github.com:PaulRBerg/prb-math.git
```

Then, inside the project's directory, run this to install the Node.js dependencies:

```sh
$ pnpm install
```

Now you can start making changes.

### Syntax Highlighting

You will need the following VSCode extensions:

- [hardhat-solidity](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity)
- [vscode-tree-language](https://marketplace.visualstudio.com/items?itemName=CTC.vscode-tree-extension)

## Security

While I set a high bar for code quality and test coverage, you should not assume that this project is completely safe to use. PRBMath has not yet been
audited by a third-party security researcher.

### Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties and will not be liable for any
loss, direct or indirect through continued use of this codebase.

### Contact

If you discover any bugs or security issues, please report them via [Telegram](https://t.me/PaulRBerg).

## Acknowledgments

- Mikhail Vladimirov for the insights he shared in the [Math in Solidity](https://medium.com/coinmonks/math-in-solidity-part-1-numbers-384c8377f26d)
  article series.
- Remco Bloemen for his work on [overflow-safe multiplication and division](https://xn--2-umb.com/21/muldiv/), and for responding to the questions I
  asked him while developing the library.
- Everyone who has contributed a PR to this repository.

## License

This project is licensed under MIT.
