# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.4.3] - 2022-02-02

### Fixed

- Peer dependency version for `mathjs`.

## [2.4.2] - 2022-02-02

### Changed

- Upgrade to `mathjs` v10.1.1.

## [2.4.1] - 2021-10-27

### Changed

- Upgrade to `@ethersproject/bignumber` v5.5.0.

### Fixed

- Set peer dependencies.

## [2.4.0] - 2021-10-20

### Added

- `@ethersproject/bignumber`, `decimal.js`, `evm-bn`, and `mathjs` as normal deps.
- Ship JavaScript source maps with the npm package.

### Changed

- Americanize spellings in NatSpec comments.
- Move everything from the `prb-math.js` package to `prb-math`.
- Polish NatSpec comments in `avg` function.
- Use underscores in number literals.

### Fixed

- Bug in `powu` function in the `PRBMathSD59x18` contract, which caused the result to be positive even if the base was negative.
- Minor bug in `avg` function in the `PRBMathSD59x18` contract, which rounded down the result instead of up when the intermediary sum was negative.

## [2.3.0] - 2021-09-18

### Added

- The CHANGELOG file in the npm package bundle.

### Changed

- License from "WTFPL" to "Unlicense".
- Polish README.

### Fixed

- Typos in comments.

### Removed

- Stale "resolutions" field in `package.json`.

## [2.2.0] - 2021-06-27

### Changed

- Add contract name prefix to custom errors.

### Removed

- `@param` tags for custom errors NatSpec.

## [2.1.0] - 2021-06-27

### Added

- Solidity v0.8.4 custom errors.

### Changed

- Define the upper limit as `MAX_UD60x18 / SCALE` in the `sqrt` function.
- Define `xValue` var to avoid reading `x.value` multiple times.
- Move `SCALE > prod1` check at the top of the `mulDivFixedPoint` function.
- Refer to `add` function operands as summands.
- Refer to `sub` function operands as minuend and subtrahend.
- Rename `rUnsigned` var to `rAbs`.
- Set minimum compiler version to 0.8.4.
- Use `MIN_SD59x18` instead of `type(int256).min` where appropriate.

### Removed

- `hardhat/console.sol` import.
- Stale caveat in `sqrt` function NatSpec.

## [2.0.1] - 2021-06-16

### Changed

- Mention the new typed flavors in the README.

### Fixed

- Code snippet for the UD60x18Typed consumer in the README.
- English typos in NatSpec comments.
- Minor bug in `log10` in `PRBMathUD60x18Typed.sol` which made the result inaccurate when the input was a multiple of 10.

## [2.0.0] - 2021-06-14

### Added

- Addition and subtraction functions in the typed libraries.
- Gas estimates for `fromInt`, `fromUint`, `pow`, `toInt` and `toUInt`.
- Structs `PRBMath.SD59x18` and `PRBMath.UD60x18`, simple wrappers to indicate that the variables are fixed-point numbers.
- Typed versions of the library: `PRBMathSD59x18Typed.sol` and `PRBMathUD60x18Typed.sol`.

### Changed

- Increase the accuracy of `exp2` by using the 192.64-bit format instead of 128.128-bit.
- Rename `PRBMathCommon.sol` to `PRBMath.sol`.
- Set named parameter instead of returning result in `pow` functions.
- Update gas estimates for `exp` and `exp2`.

### Fixed

- Bug in `log10` which made the result incorrect when the input was not a multiple of 10.
- Typos in NatSpec comments.

## [1.1.0] - 2021-05-07 [YANKED]

### Added

- New convertor functions `fromInt` and `toInt` in `PRBMathSD59x18.sol`.
- New convertor functions `fromUint` and `toUint` in `PRBMathUD60x18.sol`.
- New function `mulDivSigned` in `PRBMathCommon.sol`.
- New function `pow` in `PRBMathSD59x18.sol` and `PRBMathUD60x18.sol`

### Changed

- Rename the previous `pow` function to `powu`.
- Speed up `exp2` by simplifying the integer part calculations.
- Use the fixed-point format in NatSpec comments.

### Fixed

- Minor typos in NatSpec comments.

## [1.0.5] - 2021-04-24

### Added

- Link to StackExchange answer in `exp2` NatSpec comments.

### Changed

- Speed up the `exp2` function in PRBMathCommon.sol by simplifying the integer part calculation.
- Use `SCALE` instead of the 1e18 literal in `PRBMathCommon.sol`.

## [1.0.4] - 2021-04-20

### Changed

- Optimize the `pow` function in PRBMathUD60x18.sol by calling `mulDivFixedPoint` directly.

## [1.0.3] - 2021-04-20

### Fixed

- Typos in NatSpec comments.
- Typo in example in README.

### Removed

- Stale `SCALE_LPOTD` and `SCALE_INVERSE` constants in PRBMathSD59x18.sol.

## [1.0.2] - 2021-04-19

### Removed

- Stale `SCALE_LPOTD` and `SCALE_INVERSE` constants in PRBMathUD60x18.sol.

## [1.0.1] - 2021-04-19

### Changed

- Examples in the README.

## [1.0.0] - 2021-04-19

### Added

- First release of the library.

[2.4.3]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.4.2...prb-math@2.4.3
[2.4.2]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.4.1...prb-math@2.4.2
[2.4.1]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.4.0...prb-math@2.4.1
[2.4.0]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.3.0...prb-math@2.4.0
[2.3.0]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.2.0...prb-math@2.3.0
[2.2.0]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.1.0...prb-math@2.2.0
[2.1.0]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.0.1...prb-math@2.1.0
[2.0.1]: https://github.com/hifi-finance/prb-math/compare/prb-math@2.0.0...prb-math@2.0.1
[2.0.0]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.1.0...prb-math@2.0.0
[1.1.0]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.0.5...prb-math@1.1.0
[1.0.5]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.0.4...prb-math@1.0.5
[1.0.4]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.0.3...prb-math@1.0.4
[1.0.3]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.0.2...prb-math@1.0.3
[1.0.2]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.0.1...prb-math@1.0.2
[1.0.1]: https://github.com/hifi-finance/prb-math/compare/prb-math@1.0.0...prb-math@1.0.1
[1.0.0]: https://github.com/hifi-finance/prb-math/releases/tag/prb-math@1.0.0
