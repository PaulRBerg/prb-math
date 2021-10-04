# PRBMath.Js ![npm (scoped)](https://img.shields.io/npm/v/prb-math.js)

JavaScript SDK for the PRBMath smart contract library for advanced fixed-point math.

## Background

This SDK is complementary to the [PRBMath](../prb-math) smart contract library for advanced fixed-point math. It
provides TypeScript implementations for the mathematical functions originally written in Solidity.

## Install

### Node.Js

With yarn:

```bash
$ yarn add prb-math.js @ethersproject/bignumber evm-bn mathjs
```

Or npm:

```bash
$ npm install prb-math.js @ethersproject/bignumber evm-bn mathjs
```

The three trailing packages are the peer dependencies of `prb-math.js`.

### Browser

```html
<script type="text/javascript" src="https://unpkg.com/prb-math.js/dist/browser/prb-math.min.js"></script>

<script type="text/javascript">
  window.PRBMath; // or PRBMath
</script>
```

## Usage

Whatever functions there are in the Solidity library, you should find them implemented in `prb-math.js`. The only exception are
the `fromUint` and `toUint` convertors, which are replicated via an external package called
[evm-bn](https://github.com/paulrberg/evm-bn).

Here's an example for how to calculate the binary logarithm:

```ts
import type { BigNumber } from "@ethersproject/bignumber";
import { fromBn, toBn } from "evm-bn";
import { log2 } from "prb-math.js";

(async function () {
  const x: BigNumber = toBn("16");
  const result: BigNumber = log2(x);
  console.log({ result: fromBn(result) });
})();
```

Pro tip: see how the SDK is used in the [tests](../prb-math/test) I wrote for PRBMath.

## License

[Unlicense](./LICENSE.md) © Paul Razvan Berg
