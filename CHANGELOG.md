# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[4.0.1]: https://github.com/PaulRBerg/prb-math/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/PaulRBerg/prb-math/compare/v3.3.2...v4.0.0
[3.3.2]: https://github.com/PaulRBerg/prb-math/compare/v3.3.1...v3.3.2
[3.3.1]: https://github.com/PaulRBerg/prb-math/compare/v3.3.0...v3.3.1
[3.3.0]: https://github.com/PaulRBerg/prb-math/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/PaulRBerg/prb-math/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/PaulRBerg/prb-math/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/PaulRBerg/prb-math/compare/v2.5.0...v3.0.0
[2.5.0]: https://github.com/PaulRBerg/prb-math/compare/v2.4.3...v2.5.0
[2.4.3]: https://github.com/PaulRBerg/prb-math/compare/v2.4.2...v2.4.3
[2.4.2]: https://github.com/PaulRBerg/prb-math/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/PaulRBerg/prb-math/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/PaulRBerg/prb-math/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/PaulRBerg/prb-math/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/PaulRBerg/prb-math/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/PaulRBerg/prb-math/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/PaulRBerg/prb-math/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/PaulRBerg/prb-math/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/PaulRBerg/prb-math/compare/v1.0.5...v1.1.0
[1.0.5]: https://github.com/PaulRBerg/prb-math/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/PaulRBerg/prb-math/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/PaulRBerg/prb-math/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/PaulRBerg/prb-math/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/PaulRBerg/prb-math/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/PaulRBerg/prb-math/releases/tag/v1.0.0

## [4.0.1] - 2023-05-28

### Changed

- Bump submodules (@PaulRBerg)
- Clarify rounding modes (@PaulRBerg)
- Move test utils from `src/test` to `test/utils` (@PaulRBerg)
- Improve documentation (@PaulRBerg)

### Added

- Provide silent `bound` utils (@PaulRBerg)

## [4.0.0] - 2023-04-13

### Changed

- **Breaking**: Rename `fromSD590x18`, `fromUD60x18`, `toSD59x18`, and `toUD60x18` to `convert` (@PaulRBerg)
- **Breaking**: Rename `Core.sol` to `Common.sol` (@PaulRBerg)
- **Breaking:** Set minimum compiler pragma to `>=0.8.19` (@PaulRBerg)
- Bump Node.js dependencies (@PaulRBerg)
- Bump submodules (@PaulRBerg)
- Clarify rounding modes ([6bb53ea](https://github.com/PaulRBerg/prb-math/tree/6bb53ea)) (@PaulRBerg)
- Clarify that `mulDiv` rounds toward zero ([cda291](https://github.com/PaulRBerg/prb-math/tree/cda291)) (@PaulRBerg)
- Fix typo in code snippet in README ([#180](https://github.com/PaulRBerg/prb-math/pull/180)) (@cygaar)
- Format contracts with Forge Formatter (@PaulRBerg)
- Improve writing and formatting in documentation (@PaulRBerg)
- Make a distinction between `lpotdod` and its flipped counterpart in `Common.mulDiv` (@PaulRBerg)
- Open pragma in test assertions and utils (@PaulRBerg)
- Reorder statements in `Common.mulDiv18` (@PaulRBerg)
- Rename `Common.prbExp2` to `Common.exp2` (@PaulRBerg)
- Rename `Common.prbSqrt` to `Common.sqrt` (@PaulRBerg)
- Rename `Assertions` to `PRBMathAssertions` (@PaulRBerg)
- Return base when exponent is unit in `pow` ([#182](https://github.com/PaulRBerg/prb-math/pull/182)) (@PaulRBerg)
- Return unit when base is unit in `pow` ([#182](https://github.com/PaulRBerg/prb-math/pull/182)) (@PaulRBerg)
- Switch to Pnpm for Node.js package management (@PaulRBerg)
- Use bound `unwrap` instead of imported `unwrap` (@PaulRBerg)
- Use long names in named imports (@PaulRBerg)

### Added

- Add `EXP_MAX_INPUT` and `EXP2_MAX_INPUT` constants, and use them in `exp` and `exp2` (@PaulRBerg)
- Add `UNIT_SQUARED` and use it instead of the hard-coded value (@PaulRBerg)
- Add user-defined operators ([#168](https://github.com/PaulRBerg/prb-math/pull/168)) (@Amxx,@PaulRBerg)
- Add unary operator ([#173](https://github.com/PaulRBerg/prb-math/pull/173)) (@Lumyo,@PaulRBerg)
- Expand domain of `pow` in `UD60x18` by allowing inputs lower than `UNIT` ([#182](https://github.com/PaulRBerg/prb-math/pull/182)) (@PaulRBerg)

### Removed

- Remove development-related Node.js dependencies (@PaulRBerg)
- Remove "memory-safe" annotation in test assertions (@PaulRBerg)
- Remove problematic src/=src/ remapping (#41) (@PaulRBerg)
- Remove superfluous threshold check in `SD59x19.exp` (@PaulRBerg)

### Fixed

- Fix bit mask in `Common.exp2` ([#179](https://github.com/PaulRBerg/prb-math/pull/179)) (@andreivladbrg)

## [3.3.2] - 2023-03-19

### Changed

- Use `ValueType.wrap` directly in casting functions (@PaulRBerg)

## [3.3.1] - 2023-03-17

### Changed

- Bump submodules (@PaulRBerg)

## [3.3.0] - 2023-02-06

### Changed

- Improve documentation (@PaulRBerg)
- Improve names of custom errors and functions (@PaulRBerg)
- Optimize assembly usage by annotating assembly blocks with the "memory-safe" dialect (@PaulRBerg)
- Modularize code by splitting it into multiple categories: casting, constants, conversions, errors, helpers, math, and value types (@PaulRBerg)
- Rename `Assertions` to `PRBMathAssertions` in a backward-compatible way (@PaulRBerg)
- Upgrade Node.js package dependencies (@PaulRBerg)

### Added

- Add casting utilities for PRBMath types and `uint128` and `uint40` (@PaulRBerg)
- Add more constants in `SD1x18` and `UD2x18` (@PaulRBerg)
- Add `PRBMathUtils` contract with test utils (@PaulRBerg)
- Add test assertions overloads with `err` param (@PaulRBerg)
- Add typed versions of `bound` test util (@PaulRBerg)
- Add `wrap` and `unwrap` in `SD1x18` and `UD2x18` (@PaulRBerg)
- Expose `unwrap` via `using for ... global` (@PaulRBerg)

## [3.2.0] - 2022-12-13

### Added

- Add assertions for array comparisons (@PaulRBerg)

### Removed

- Delete assertions that have an "err" argument (@PaulRBerg)

### Fixed

- Match types for `SD1x18` and `UD2x18` assertions (@PaulRBerg)

## [3.1.0] - 2022-12-13

### Added

- Add value types `SD1x18` and `UD2x18` (@PaulRBerg)

## [3.0.0] - 2022-11-29

[1b82ea]: https://github.com/PaulRBerg/prb-math/commit/1b82ea
[a69b4b]: https://github.com/PaulRBerg/prb-math/commit/a69b4b

### Changed

- **Breaking:** Refactor the libraries into free functions and user defined value types ([`a69b4b`][a69b4b]) (@PaulRBerg)
- **Breaking:** Set minimum compiler pragma to `>=0.8.13` ([`a69b4b`][a69b4b]) (@PaulRBerg)
- **Breaking:** Rename `SCALE` to `UNIT` ([`4d3658`](https://github.com/PaulRBerg/prb-math/commit/4d3658)) (@PaulRBerg)
- Always truncate instead of rounding up in multiplication functions ([21fb32](https://github.com/PaulRBerg/prb-math/commit/21fb32)) (@PaulRBerg)
- Change license to MIT (@PaulRBerg)
- Check if `y` is zero in `gm` ([`5b585c`](https://github.com/PaulRBerg/prb-math/commit/5b585c)) (@PaulRBerg)
- Optimize `avg` by using the SWAR technique ([#89](https://github.com/PaulRBerg/prb-math/pull/89)) (@PaulRBerg)
- Optimize `div` and `mulDivSigned` by wrapping unary operations in unchecked blocks ([`a69b4b`][a69b4b]) (@PaulRBerg)
- Optimize `exp2` by batching bit checks ([#77](https://github.com/PaulRBerg/prb-math/pull/77)) (@k06a)
- Optimize `msb` by using assembly ([#135](https://github.com/PaulRBerg/prb-math/pull/135)) (@t4sk, @PaulRBerg)
- Optimize result assignment in `powu` ([673802](https://github.com/PaulRBerg/prb-math/commit/673802)) (@PaulRBerg)
- Rename `fromInt` to `toSD59x18` and `toInt` to `fromSD59x18` ([`a69b4b`][a69b4b]) (@PaulRBerg)
- Rename `fromUint` to `toUD60x18` and `toUint` to `fromUD60x18` ([`a69b4b`][a69b4b]) (@PaulRBerg)
- Rename `mostSignificantBit` to `msb` ([`a69b4b`][a69b4b]) (@PaulRBerg)
- Rename `mulDivFixedPoint` to `mulDiv18` ([`4c5430`](https://github.com/PaulRBerg/prb-math/commit/4c5430)) (@PaulRBerg)
- Rename `PRBMath.sol` to `Core.sol` ([`1b82ea`][1b82ea]) (@PaulRBerg)
- Rename shared `sqrt` in `prbSqrt` ([`1b82ea`][1b82ea]) (@PaulRBerg)
- Rename shared `exp2` in `prbExp2` ([`1b82ea`][1b82ea]) (@PaulRBerg)
- Revert with inputs instead of computed value custom errors (@PaulRBerg)
- Return base if exponent is one in `pow` ([`977d43`](https://github.com/PaulRBerg/prb-math/commit/977d43)) (@PaulRBerg)
- Format mathematical expressions using LaTeX (@PaulRBerg)
- Improve wording and formatting in comments, NatSpec documentation, and README (@PaulRBerg)

### Added

- Add constants for E and PI ([`422d87`](https://github.com/PaulRBerg/prb-math/commit/422d87)) (@PaulRBerg)
- Add simple PRBTest-based typed assertions for testing in Foundry ([`ddb084`](https://github.com/PaulRBerg/prb-math/commit/ddb084)) (@PaulRBerg)
- Add user defined value types `SD59x18` and `UD60x18` (@PaulRBerg)
- Implement conversion and helper functions for the user defined value types (@PaulRBerg)

### Removed

- **Breaking:** Delete the `e` and `pi` functions ([422d87](https://github.com/PaulRBerg/prb-math/commit/422d87)) (@PaulRBerg)
- **Breaking:** Remove JavaScript SDK and all paraphernalia ([`1b82ea`][1b82ea]) (@PaulRBerg)

### Fixed

- Fix incorrect hard-coded value in `sqrt` ([#91](https://github.com/PaulRBerg/prb-math/pull/91)) (@Amxx, @nonergodic)
- Fix upper boundary specified in `exp` NatSpec comments ([#119](https://github.com/PaulRBerg/prb-math/discussions/119)) (@PaulRBerg)

## [2.5.0] - 2022-03-08

### Changed

- Change the package name from `prb-math` to `@prb/math` (@PaulRBerg)
- Update links to repository (@PaulRBerg)
- Upgrade to `mathjs` v10.4.0 (@PaulRBerg)

## [2.4.3] - 2022-02-02

### Fixed

- Peer dependency version for `mathjs` (@PaulRBerg)

## [2.4.2] - 2022-02-02

### Changed

- Upgrade to `mathjs` v10.1.1 (@PaulRBerg)

### Fixed

- Fix typo in comment in `sqrt` ([#67](https://github.com/PaulRBerg/prb-math/pull/67) (@transmissions11)

## [2.4.1] - 2021-10-27

### Changed

- Upgrade to `@ethersproject/bignumber` v5.5.0 (@PaulRBerg)

### Fixed

- Set peer dependencies (@PaulRBerg)

## [2.4.0] - 2021-10-20

### Added

- `@ethersproject/bignumber`, `decimal.js`, `evm-bn`, and `mathjs` as normal deps (@PaulRBerg)
- Ship JavaScript source maps with the npm package (@PaulRBerg)

### Changed

- Americanize spellings in NatSpec comments (@PaulRBerg)
- Move everything from the `prb-math.js` package to `prb-math` (@PaulRBerg)
- Polish NatSpec comments in `avg` function (@PaulRBerg)
- Use underscores in number literals (@PaulRBerg)

### Fixed

- Fix bug in the `powu` function of the `PRBMathSD59x18` contract, which caused the result to be positive even if the base was negative (@PaulRBerg)
- Fix minor bug in the `avg` function of the `PRBMathSD59x18` contract, which rounded down the result instead of up when the intermediary sum was
  negative (@PaulRBerg)

## [2.3.0] - 2021-09-18

### Added

- The CHANGELOG file in the npm package bundle (@PaulRBerg)

### Changed

- License from "WTFPL" to "Unlicense" (@PaulRBerg)
- Polish README (@PaulRBerg)

### Fixed

- Typos in comments (@PaulRBerg)

### Removed

- Remove stale "resolutions" field in `package.json` (@PaulRBerg)

## [2.2.0] - 2021-06-27

### Changed

- Add contract name prefix to custom errors (@PaulRBerg)

### Removed

- Remove `@param` tags in custom errors' NatSpec (@PaulRBerg)

## [2.1.0] - 2021-06-27

### Changed

- Define the upper limit as `MAX_UD60x18 / SCALE` in the `sqrt` function (@PaulRBerg)
- Define `xValue` var to avoid reading `x.value` multiple times (@PaulRBerg)
- Move `SCALE > prod1` check at the top of the `mulDivFixedPoint` function (@PaulRBerg)
- Refer to `add` function operands as summands (@PaulRBerg)
- Refer to `sub` function operands as minuend and subtrahend (@PaulRBerg)
- Rename `rUnsigned` var to `rAbs` (@PaulRBerg)
- Set minimum compiler pragma to `>=0.8.4` (@PaulRBerg)
- Use `MIN_SD59x18` instead of `type(int256).min` where appropriate (@PaulRBerg)

### Added

- Add Solidity v0.8.4 custom errors (@PaulRBerg)

### Removed

- Remove stale `hardhat/console.sol` import (@PaulRBerg)
- Remove stale caveat in the NatSpec for `sqrt` (@PaulRBerg)

## [2.0.1] - 2021-06-16

### Changed

- Mention the new typed flavors in the README (@PaulRBerg)

### Fixed

- Code snippet for the UD60x18Typed consumer in the README (@PaulRBerg)
- English typos in NatSpec comments ([#40](https://github.com/PaulRBerg/prb-math/pull/40)) (@ggviana)
- Minor bug in `log10` in `PRBMathUD60x18Typed.sol` which made the result inaccurate when the input was a multiple of 10 (@PaulRBerg)

## [2.0.0] - 2021-06-14

### Changed

- **Breaking**: Rename `PRBMathCommon.sol` to `PRBMath.sol` (@PaulRBerg)
- Increase the accuracy of `exp2` by using the 192.64-bit format instead of 128.128-bit (@PaulRBerg)
- Set named parameter instead of returning result in `pow` functions (@PaulRBerg)
- Update gas estimates for `exp` and `exp2` (@PaulRBerg)

### Added

- Add `add` and `sub` functions in the typed libraries (@PaulRBerg)
- Add types flavors of the library: `PRBMathSD59x18Typed.sol` and `PRBMathUD60x18Typed.sol` (@PaulRBerg)
- Document gas estimates for `fromInt`, `fromUint`, `pow`, `toInt` and `toUInt` (@PaulRBerg)
- Structs `PRBMath.SD59x18` and `PRBMath.UD60x18`, simple wrappers to indicate that the variables are fixed-point numbers (@PaulRBerg)

### Fixed

- Bug in `log10` which made the result incorrect when the input was not a multiple of 10 (@PaulRBerg)
- Typos in NatSpec comments (@PaulRBerg)

## [1.1.0] - 2021-05-07

_This release was yanked because it was accidentally published with the wrong version number._

### Changed

- Rename the previous `pow` function to `powu` (@PaulRBerg)
- Speed up `exp2` by simplifying the integer part calculations (@PaulRBerg)
- Use the fixed-point format in NatSpec comments (@PaulRBerg)

### Added

- Add new convertor functions `fromInt` and `toInt` in `PRBMathSD59x18.sol` (@PaulRBerg)
- Add new convertor functions `fromUint` and `toUint` in `PRBMathUD60x18.sol` (@PaulRBerg)
- Add new function `mulDivSigned` in `PRBMathCommon.sol` (@PaulRBerg)
- Add new function `pow` in `PRBMathSD59x18.sol` and `PRBMathUD60x18.sol` (@PaulRBerg)

### Fixed

- Fix minor typos in NatSpec comments (@PaulRBerg)

## [1.0.5] - 2021-04-24

### Changed

- Speed up the `exp2` function in PRBMathCommon.sol by simplifying the integer part calculation (@PaulRBerg))
- Use `SCALE` instead of the 1e18 literal in `PRBMathCommon.sol` (@PaulRBerg)

### Added

- Add link to StackExchange answer in `exp2` NatSpec comments (@PaulRBerg)

## [1.0.4] - 2021-04-20

### Changed

- Optimize the `pow` function in `PRBMathUD60x18` by calling `mulDivFixedPoint` directly (@PaulRBerg)

## [1.0.3] - 2021-04-20

### Fixed

- Fix typos in NatSpec comments (@PaulRBerg)
- Fix typo in example in README (@PaulRBerg)

### Removed

- Remove `SCALE_LPOTD` and `SCALE_INVERSE` constants in `PRBMathSD59x18` (@PaulRBerg)

## [1.0.2] - 2021-04-19

### Removed

- Remove stale `SCALE_LPOTD` and `SCALE_INVERSE` constants in `PRBMathUD60x18` (@PaulRBerg)

## [1.0.1] - 2021-04-19

### Changed

- Change in the README (@PaulRBerg)

## [1.0.0] - 2021-04-19

### Added

- First release of the library (@PaulRBerg)
