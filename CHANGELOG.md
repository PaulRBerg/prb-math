# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[3.2.0]: https://github.com/paulrberg/prb-math/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/paulrberg/prb-math/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/paulrberg/prb-math/compare/v2.5.0...v3.0.0
[2.5.0]: https://github.com/paulrberg/prb-math/compare/v2.4.3...v2.5.0
[2.4.3]: https://github.com/paulrberg/prb-math/compare/v2.4.2...v2.4.3
[2.4.2]: https://github.com/paulrberg/prb-math/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/paulrberg/prb-math/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/paulrberg/prb-math/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/paulrberg/prb-math/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/paulrberg/prb-math/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/paulrberg/prb-math/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/paulrberg/prb-math/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/paulrberg/prb-math/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/paulrberg/prb-math/compare/v1.0.5...v1.1.0
[1.0.5]: https://github.com/paulrberg/prb-math/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/paulrberg/prb-math/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/paulrberg/prb-math/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/paulrberg/prb-math/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/paulrberg/prb-math/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/paulrberg/prb-math/releases/tag/v1.0.0

## [3.2.0] - 2022-12-13

### Added

- Add assertions for array comparisons (@paulrberg)

### Removed

- Delete assertions that have an "err" argument (@paulrberg)

### Fixed

- Match types for `SD1x18` and `UD2x18` assertions (@paulrberg)

## [3.1.0] - 2022-12-13

### Added

- Add value types `SD1x18` and `UD2x18` (@paulrberg)

## [3.0.0] - 2022-11-29

[1b82ea]: https://github.com/paulrberg/prb-math/commit/1b82ea
[a69b4b]: https://github.com/paulrberg/prb-math/commit/a69b4b

### Changed

- **Breaking:** Refactor the libraries into free functions and user defined value types ([`a69b4b`][a69b4b]) (@paulrberg)
- **Breaking:** Set minimum compiler pragma to `>=0.8.13` ([`a69b4b`][a69b4b]) (@paulrberg)
- **Breaking:** Rename `SCALE` to `UNIT` ([`4d3658`](https://github.com/paulrberg/prb-math/commit/4d3658)) (@paulrberg)
- Always truncate instead of rounding down in multiplication functions ([21fb32](https://github.com/paulrberg/prb-math/commit/21fb32)) (@paulrberg)
- Change license to MIT (@paulrberg)
- Check if `y` is zero in `gm` ([`5b585c`](https://github.com/paulrberg/prb-math/commit/5b585c)) (@paulrberg)
- Optimize `avg` by using the SWAR technique ([#89](https://github.com/paulrberg/prb-math/pull/89)) (@paulrberg)
- Optimize `div` and `mulDivSigned` by wrapping unary operations in unchecked blocks ([`a69b4b`][a69b4b]) (@paulrberg)
- Optimize `exp2` by batching bit checks ([#77](https://github.com/paulrberg/prb-math/pull/77)) (@k06a)
- Optimize `msb` by using assembly ([#135](https://github.com/paulrberg/prb-math/pull/135)) (@t4sk, @paulrberg)
- Optimize result assignment in `powu` ([673802](https://github.com/paulrberg/prb-math/commit/673802)) (@paulrberg)
- Rename `fromInt` to `toSD59x18` and `toInt` to `fromSD59x18` ([`a69b4b`][a69b4b]) (@paulrberg)
- Rename `fromUint` to `toUD60x18` and `toUint` to `fromUD60x18` ([`a69b4b`][a69b4b]) (@paulrberg)
- Rename `mostSignificantBit` to `msb` ([`a69b4b`][a69b4b]) (@paulrberg)
- Rename `mulDivFixedPoint` to `mulDiv18` ([`4c5430`](https://github.com/paulrberg/prb-math/commit/4c5430)) (@paulrberg)
- Rename `PRBMath.sol` to `Core.sol` ([`1b82ea`][1b82ea]) (@paulrberg)
- Rename shared `sqrt` in `prbSqrt` ([`1b82ea`][1b82ea]) (@paulrberg)
- Rename shared `exp2` in `prbExp2` ([`1b82ea`][1b82ea]) (@paulrberg)
- Revert with inputs instead of computed value custom errors (@paulrberg)
- Return base if exponent is one in `pow` ([`977d43`](https://github.com/paulrberg/prb-math/commit/977d43)) (@paulrberg)
- Format mathematical expressions using LaTeX (@paulrberg)
- Improve wording and formatting in comments, NatSpec documentation, and README (@paulrberg)

### Added

- Add constants for E and PI ([`422d87`](https://github.com/paulrberg/prb-math/commit/422d87)) (@paulrberg)
- Add simple PRBTest-based typed assertions for testing in Foundry ([`ddb084`](https://github.com/paulrberg/prb-math/commit/ddb084)) (@paulrberg)
- Add user defined value types `SD59x18` and `UD60x18` (@paulrberg)
- Implement conversion and helper functions for the user defined value types (@paulrberg)

### Removed

- **Breaking:** Delete the `e` and `pi` functions ([422d87](https://github.com/paulrberg/prb-math/commit/422d87)) (@paulrberg)
- **Breaking:** Remove JavaScript SDK and all paraphernalia ([`1b82ea`][1b82ea]) (@paulrberg)

### Fixed

- Fix incorrect hard-coded value in `sqrt` ([#91](https://github.com/paulrberg/prb-math/pull/91)) (@Amxx, @nonergodic)
- Fix upper boundary specified in `exp` NatSpec comments ([#119](https://github.com/paulrberg/prb-math/discussions/119)) (@paulrberg)

## [2.5.0] - 2022-03-08

### Changed

- Change the package name from `prb-math` to `@prb/math` (@paulrberg)
- Update links to repository (@paulrberg)
- Upgrade to `mathjs` v10.4.0 (@paulrberg)

## [2.4.3] - 2022-02-02

### Fixed

- Peer dependency version for `mathjs` (@paulrberg)

## [2.4.2] - 2022-02-02

### Changed

- Upgrade to `mathjs` v10.1.1 (@paulrberg)

### Fixed

- Fix typo in comment in `sqrt` ([#67](https://github.com/paulrberg/prb-math/pull/67) (@transmissions11)

## [2.4.1] - 2021-10-27

### Changed

- Upgrade to `@ethersproject/bignumber` v5.5.0 (@paulrberg)

### Fixed

- Set peer dependencies (@paulrberg)

## [2.4.0] - 2021-10-20

### Added

- `@ethersproject/bignumber`, `decimal.js`, `evm-bn`, and `mathjs` as normal deps (@paulrberg)
- Ship JavaScript source maps with the npm package (@paulrberg)

### Changed

- Americanize spellings in NatSpec comments (@paulrberg)
- Move everything from the `prb-math.js` package to `prb-math` (@paulrberg)
- Polish NatSpec comments in `avg` function (@paulrberg)
- Use underscores in number literals (@paulrberg)

### Fixed

- Fix bug in the `powu` function of the `PRBMathSD59x18` contract, which caused the result to be positive even if the base was negative (@paulrberg)
- Fix minor bug in the `avg` function of the `PRBMathSD59x18` contract, which rounded down the result instead of up when the intermediary sum was
  negative (@paulrberg)

## [2.3.0] - 2021-09-18

### Added

- The CHANGELOG file in the npm package bundle (@paulrberg)

### Changed

- License from "WTFPL" to "Unlicense" (@paulrberg)
- Polish README (@paulrberg)

### Fixed

- Typos in comments (@paulrberg)

### Removed

- Remove stale "resolutions" field in `package.json` (@paulrberg)

## [2.2.0] - 2021-06-27

### Changed

- Add contract name prefix to custom errors (@paulrberg)

### Removed

- `@param` tags for custom errors NatSpec (@paulrberg)

## [2.1.0] - 2021-06-27

### Changed

- Define the upper limit as `MAX_UD60x18 / SCALE` in the `sqrt` function (@paulrberg)
- Define `xValue` var to avoid reading `x.value` multiple times (@paulrberg)
- Move `SCALE > prod1` check at the top of the `mulDivFixedPoint` function (@paulrberg)
- Refer to `add` function operands as summands (@paulrberg)
- Refer to `sub` function operands as minuend and subtrahend (@paulrberg)
- Rename `rUnsigned` var to `rAbs` (@paulrberg)
- Set minimum compiler pragma to `>=0.8.4` (@paulrberg)
- Use `MIN_SD59x18` instead of `type(int256).min` where appropriate (@paulrberg)

### Added

- Add Solidity v0.8.4 custom errors (@paulrberg)

### Removed

- Remove stale `hardhat/console.sol` import (@paulrberg)
- Remove stale caveat in `sqrt` function NatSpec (@paulrberg)

## [2.0.1] - 2021-06-16

### Changed

- Mention the new typed flavors in the README (@paulrberg)

### Fixed

- Code snippet for the UD60x18Typed consumer in the README (@paulrberg)
- English typos in NatSpec comments ([#40](https://github.com/paulrberg/prb-math/pull/40)) (@ggviana)
- Minor bug in `log10` in `PRBMathUD60x18Typed.sol` which made the result inaccurate when the input was a multiple of 10 (@paulrberg)

## [2.0.0] - 2021-06-14

### Changed

- Increase the accuracy of `exp2` by using the 192.64-bit format instead of 128.128-bit (@paulrberg)
- Rename `PRBMathCommon.sol` to `PRBMath.sol` (@paulrberg)
- Set named parameter instead of returning result in `pow` functions (@paulrberg)
- Update gas estimates for `exp` and `exp2` (@paulrberg)

### Added

- Add `add` and `sub` functions in the typed libraries (@paulrberg)
- Add types flavors of the library: `PRBMathSD59x18Typed.sol` and `PRBMathUD60x18Typed.sol` (@paulrberg)
- Document gas estimates for `fromInt`, `fromUint`, `pow`, `toInt` and `toUInt` (@paulrberg)
- Structs `PRBMath.SD59x18` and `PRBMath.UD60x18`, simple wrappers to indicate that the variables are fixed-point numbers (@paulrberg)

### Fixed

- Bug in `log10` which made the result incorrect when the input was not a multiple of 10 (@paulrberg)
- Typos in NatSpec comments (@paulrberg)

## [1.1.0] - 2021-05-07

_This release was yanked because it was accidentally published with the wrong version number._

### Changed

- Rename the previous `pow` function to `powu` (@paulrberg)
- Speed up `exp2` by simplifying the integer part calculations (@paulrberg)
- Use the fixed-point format in NatSpec comments (@paulrberg)

### Added

- Add new convertor functions `fromInt` and `toInt` in `PRBMathSD59x18.sol` (@paulrberg)
- Add new convertor functions `fromUint` and `toUint` in `PRBMathUD60x18.sol` (@paulrberg)
- Add new function `mulDivSigned` in `PRBMathCommon.sol` (@paulrberg)
- Add new function `pow` in `PRBMathSD59x18.sol` and `PRBMathUD60x18.sol` (@paulrberg)

### Fixed

- Fix minor typos in NatSpec comments (@paulrberg)

## [1.0.5] - 2021-04-24

### Changed

- Speed up the `exp2` function in PRBMathCommon.sol by simplifying the integer part calculation (@paulrberg))
- Use `SCALE` instead of the 1e18 literal in `PRBMathCommon.sol` (@paulrberg)

### Added

- Add link to StackExchange answer in `exp2` NatSpec comments (@paulrberg)

## [1.0.4] - 2021-04-20

### Changed

- Optimize the `pow` function in PRBMathUD60x18.sol by calling `mulDivFixedPoint` directly (@paulrberg)

## [1.0.3] - 2021-04-20

### Fixed

- Fix typos in NatSpec comments (@paulrberg)
- Fix typo in example in README (@paulrberg)

### Removed

- Remove `SCALE_LPOTD` and `SCALE_INVERSE` constants in PRBMathSD59x18.sol (@paulrberg)

## [1.0.2] - 2021-04-19

### Removed

- Remove stale `SCALE_LPOTD` and `SCALE_INVERSE` constants in PRBMathUD60x18.sol (@paulrberg)

## [1.0.1] - 2021-04-19

### Changed

- Change in the README (@paulrberg)

## [1.0.0] - 2021-04-19

### Added

- First release of the library (@paulrberg)
