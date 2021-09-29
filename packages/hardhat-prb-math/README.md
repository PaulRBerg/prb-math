# Hardhat PRBMath ![npm (scoped)](https://img.shields.io/npm/v/hardhat-prb-math)

Hardhat plugin to complement the PRBMath smart contract library for advanced fixed-point math.

## Description

This plugin is complementary to the [PRBMath](../prb-math) smart contract library for advanced fixed-point math. It provides
mirroring TypeScript implementations for the mathematical functions originally written in Solidity.

## Installation

First, install the plugin and its peer dependencies:

```sh
yarn add --dev hardhat-prb-math @ethersproject/bignumber evm-bn mathjs
```

Second, import the plugin in your `hardhat.config.js`:

```js
require("hardhat-prb-math");
```

Or if you are using TypeScript, in your `hardhat.config.ts`:

```ts
import "hardhat-prb-math";
```

## Tasks

This plugin adds no additional tasks.

## Environment Extensions

This plugin extends the Hardhat Runtime Environment by adding a `prb.math` field whose type is `HardhatPRBMath`.

## Configuration

This plugin does not extend the `HardhatUserConfig` object.

## Usage

There are no additional steps you need to take for this plugin to work.

Install it and access `prb.math` through the Hardhat Runtime Environment anywhere you need it (tasks, scripts, tests,
etc). For example, in your `hardhat.config.ts`:

```ts
import type { BigNumber } from "@ethersproject/bignumber";
import { fromBn, toBn } from "evm-bn";
import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

task("log2", "Calculate the binary logarithm")
  .addParam("x", "Input")
  .setAction(async function (taskArgs: TaskArguments, { prb }): Promise<void> {
    const x: BigNumber = toBn(taskArgs.x);
    const result: BigNumber = prb.math.log2(x);
    console.log({ result: fromBn(result) });
  });

export default {};
```

### Tips

- Read the documentation on the [Hardhat Runtime
  Environment](https://hardhat.org/advanced/hardhat-runtime-environment.html) to learn how to access the HRE different ways.
- Read the README in PRBMath to learn about all the functions available in the Solidity library.

## License

[Unlicense](./LICENSE.md) © Paul Razvan Berg
