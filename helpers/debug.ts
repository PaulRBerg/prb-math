import { BigNumber } from "@ethersproject/bignumber";

import { SCALE } from "./constants";
import { fp } from "./numbers";

const foo: BigNumber = fp(SCALE).mul(fp(SCALE));
console.log({ foo: foo.toString() });

const bar: BigNumber = BigNumber.from(10).pow(18).mul(BigNumber.from(10).pow(18));
console.log({ bar: bar.toString() });
