set allow-duplicate-variables
set allow-duplicate-recipes
set shell := ["bash", "-euo", "pipefail", "-c"]
set unstable

# ---------------------------------------------------------------------------- #
#                                 DEPENDENCIES                                 #
# ---------------------------------------------------------------------------- #

# Bun: https://bun.sh
bun := require("bun")

# Foundry: https://book.getfoundry.sh
forge := require("forge")

# ---------------------------------------------------------------------------- #
#                                   CONSTANTS                                  #
# ---------------------------------------------------------------------------- #

GLOBS_PRETTIER := "\"**/*.{json,md,yml}\""
GLOBS_SOLHINT := "\"{src,test}/**/*.sol\""

# ---------------------------------------------------------------------------- #
#                                   COMMANDS                                   #
# ---------------------------------------------------------------------------- #

# Show available commands
default:
    @just --list

# Build the project
[group("commands")]
@build:
    forge build
alias b := build

# Clean build artifacts
[group("commands")]
@clean:
    bunx del-cli cache out
alias c := clean

# Run tests
[group("commands")]
@test *args:
    forge test {{ args }}
alias t := test

# ---------------------------------------------------------------------------- #
#                                    CHECKS                                    #
# ---------------------------------------------------------------------------- #

# Run all code checks
[group("checks")]
@full-check:
    just _run-with-status prettier-check
    just _run-with-status solhint-check
    just _run-with-status forge-check
    echo ""
    echo -e '{{ GREEN }}All code checks passed!{{ NORMAL }}'
alias fc := full-check

# Run all code fixes
[group("checks")]
@full-write:
    just _run-with-status prettier-write
    just _run-with-status solhint-write
    just _run-with-status forge-write
    echo ""
    echo -e '{{ GREEN }}All code fixes applied!{{ NORMAL }}'
alias fw := full-write

# Check Forge formatting
[group("checks")]
@forge-check:
    forge fmt --check
alias fgc := forge-check

# Format with Forge
[group("checks")]
@forge-write:
    forge fmt
alias fgw := forge-write

# Check Prettier formatting
[group("checks")]
@prettier-check +globs=GLOBS_PRETTIER:
    bun prettier --check --cache {{ globs }}
alias pc := prettier-check

# Format with Prettier
[group("checks")]
@prettier-write +globs=GLOBS_PRETTIER:
    bun prettier --write --cache {{ globs }}
alias pw := prettier-write

# Check Solhint linting
[group("checks")]
@solhint-check +globs=GLOBS_SOLHINT:
    bun solhint {{ globs }}
alias shc := solhint-check

# Fix Solhint issues
[group("checks")]
@solhint-write +globs=GLOBS_SOLHINT:
    bun solhint --fix {{ globs }}
alias shw := solhint-write

# ---------------------------------------------------------------------------- #
#                                   UTILITIES                                  #
# ---------------------------------------------------------------------------- #

# Private recipe to run a check with formatted output
@_run-with-status recipe:
    echo ""
    echo -e '{{ CYAN }}→ Running {{ recipe }}...{{ NORMAL }}'
    just {{ recipe }}
    echo -e '{{ GREEN }}✓ {{ recipe }} completed{{ NORMAL }}'
alias rws := _run-with-status
