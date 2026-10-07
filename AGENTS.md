# PRBMath

Solidity library for advanced fixed-point math with signed (SD59x18) and unsigned (UD60x18) 18-decimal types.

## Stack

- Solidity 0.8.30
- Foundry (forge build, forge test, forge fmt)
- Bun for package management
- Prettier, Solhint for formatting/linting

## Structure

```
src/
  Common.sol          # Shared utilities (mulDiv, exp2, log2, pow, sqrt)
  SD59x18.sol         # Signed 59.18 fixed-point type (entry point)
  UD60x18.sol         # Unsigned 60.18 fixed-point type (entry point)
  SD1x18.sol, UD2x18.sol, SD21x18.sol, UD21x18.sol   # Compact/medium types
  sd59x18/, ud60x18/  # Core type ops (Casting, Constants, Helpers, Math, ValueType)
  sd1x18/, ud2x18/, sd21x18/, ud21x18/               # Compact/medium type dirs
  casting/            # Casting from uint40/uint128/uint256
test/
  unit/               # Unit tests
  fuzz/               # Fuzz tests
  utils/              # Assertions and test utilities
```

## Commands

- `just build` - Build with Forge
- `just test` - Run tests (`forge test`)
- `just full-check` - Prettier + Solhint + Forge format check
- `just full-write` - Auto-fix all formatting issues

## Releases

- npm publishing runs only in `.github/workflows/release.yml` through npm trusted publishing in staged mode. Never run `npm publish`,
  `npm stage approve`, or `npm stage reject` locally.
- To ship: bump the version and changelog, commit, create the annotated tag `vX.Y.Z` (prerelease: `vX.Y.Z-beta.N`), push the commit, then run
  `git push origin <tag>`.
- CI stages the version. It stays unpublished until the maintainer approves it with 2FA on npmjs.com (Staged Packages) or
  `npm stage approve <stage-id>`. Prereleases use their identifier as the dist-tag.
- Setup, once: `npm trust github @prb/math --repo PaulRBerg/prb-math --file release.yml --allow-stage-publish -y`

## Development

After generating or updating code:

1. Run `just full-check` to verify
2. If errors, run `just full-write` to auto-fix
3. Fix remaining issues manually

Install dependencies: `bun install` or `bun install -d <pkg>` for dev deps.

## Code Style

- Use user-defined value types (SD59x18, UD60x18) for type safety
- Free functions over library pattern
- Custom errors over require strings
- NatSpec comments on public functions
- Line length: 132 chars
- 4-space tabs
- Bracket spacing enabled

## Fixed-Point Formats

| Type    | Signed | Integer Digits | Decimals |
| ------- | ------ | -------------- | -------- |
| SD59x18 | Yes    | 59             | 18       |
| UD60x18 | No     | 60             | 18       |
| SD1x18  | Yes    | 1              | 18       |
| UD2x18  | No     | 2              | 18       |
| SD21x18 | Yes    | 21             | 18       |
| UD21x18 | No     | 21             | 18       |

## Testing

```bash
forge test                           # Run all tests
forge test --match-test testFoo      # Run specific test
forge test --match-contract Exp2     # Run tests in contract
FOUNDRY_PROFILE=ci forge test        # CI profile with more fuzz runs
```
