# PRBMath [![Coverage Status](https://coveralls.io/repos/github/hifi-finance/prb-math/badge.svg?branch=main)](https://coveralls.io/github/hifi-finance/prb-math?branch=main) [![Styled with Prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://prettier.io) [![Commitizen Friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/) [![license: Unlicense](https://img.shields.io/badge/license-Unlicense-yellow.svg)](https://unlicense.org/)

Monorepo implementing PRBMath and related packages.

## Packages

PRBMath is maintained with [yarn workspaces](https://yarnpkg.com/features/workspaces). Check out the README
associated to each package for detailed usage instructions.

| Package                                | Description                                          |
| -------------------------------------- | ---------------------------------------------------- |
| [`prb-math`](/packages/prb-math)       | Smart contract library for advanced fixed-point math |
| [`prb-math.js`](/packages/prb-math.js) | JavaScript SDK for PRBMath                           |

## Contributing

Feel free to dive in! [Open](https://github.com/hifi-finance/prb-math/issues/new) an issue, [start](https://github.com/hifi-finance/prb-math/discussions/new) a discussion or submit a PR.

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Node.Js](https://nodejs.org/en/download/)
- [Yarn](https://yarnpkg.com/getting-started/install)

In addition, familiarity with [Solidity](https://soliditylang.org/), [TypeScript](https://typescriptlang.org/) and [Hardhat](https://hardhat.org) is requisite.

### Set Up

Install the dependencies:

```bash
$ yarn install
```

Then, create a `.env` file and follow the `.env.example` file to add the requisite environment variables. Now you can
start making changes.

## License

[Unlicense](./LICENSE.md) © Paul Razvan Berg
