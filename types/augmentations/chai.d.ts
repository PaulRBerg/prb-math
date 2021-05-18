/* eslint-disable @typescript-eslint/no-unused-vars */
import { BigNumber } from "@ethersproject/bignumber";

declare global {
  export namespace Chai {
    interface Assertion {
      near(actual: BigNumber): void;
    }
  }
}
