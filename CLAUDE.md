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
  SD59x18.sol         # Signed 59.18 fixed-point type
  UD60x18.sol         # Unsigned 60.18 fixed-point type
  SD1x18.sol          # Signed 1.18 (compact)
  UD2x18.sol          # Unsigned 2.18 (compact)
  SD21x18.sol         # Signed 21.18 (medium)
  UD21x18.sol         # Unsigned 21.18 (medium)
  sd59x18/            # SD59x18 operations (math, conversions, helpers)
  ud60x18/            # UD60x18 operations (math, conversions, helpers)
  casting/            # Type casting between formats
test/
  unit/               # Unit tests
  fuzz/               # Fuzz tests
  utils/              # Test utilities
```

## Commands

- `bun run build` - Build with Forge
- `bun run test` - Run tests (`forge test`)
- `bun run full-check` - Prettier + Solhint + Forge format check
- `bun run full-write` - Auto-fix all formatting issues

## Development

After generating or updating code:

1. Run `bun run full-check` to verify
2. If errors, run `bun run full-write` to auto-fix
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

| Type     | Signed | Integer Digits | Decimals |
| -------- | ------ | -------------- | -------- |
| SD59x18  | Yes    | 59             | 18       |
| UD60x18  | No     | 60             | 18       |
| SD1x18   | Yes    | 1              | 18       |
| UD2x18   | No     | 2              | 18       |
| SD21x18  | Yes    | 21             | 18       |
| UD21x18  | No     | 21             | 18       |

## Testing

```bash
forge test                           # Run all tests
forge test --match-test testFoo      # Run specific test
forge test --match-contract Exp2     # Run tests in contract
FOUNDRY_PROFILE=ci forge test        # CI profile with more fuzz runs
```
