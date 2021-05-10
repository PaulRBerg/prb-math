# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2021-05-07

### Added

- New convertor functions `fromInt` and `toInt` in `PRBMathSD59x18.sol`.
- New convertor functions `fromUint` and `toUint` in `PRBMathUD60x18.sol`.
- New function `mulDivSigned` in `PRBMathCommon.sol`.
- New function `pow` in `PRBMathSD59x18.sol` and `PRBMathUD60x18.sol`

### Changed

- Rename the previous `pow` function to `powu`.
- Use the fixed-point format in NatSpec comments.

### Fixed

- Minor typos in NatSpec comments.

## [1.0.5] - 2021-04-24

### Added

- Link to StackExchange answer in `exp2` NatSpec comments.

### Changed

- Speed up the `exp2` function in PRBMathCommon.sol by simplifying the integer part calculation.
- Use the SCALE constant instead of the 1e18 literal in PRBMathCommon.sol.

## [1.0.4] - 2021-04-20

### Changed

- Optimise the `pow` function in PRBMathUD60x18.sol by calling `mulDivFixedPoint` directly.

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

[1.1.0]: https://github.com/hifi-finance/prb-math/compare/v1.0.5...v1.1.0
[1.0.5]: https://github.com/hifi-finance/prb-math/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/hifi-finance/prb-math/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/hifi-finance/prb-math/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/hifi-finance/prb-math/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/hifi-finance/prb-math/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/hifi-finance/prb-math/releases/tag/v1.0.0
