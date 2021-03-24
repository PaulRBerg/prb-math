// eslint-disable @typescript-eslint/no-explicit-any
import { Fixture } from "ethereum-waffle";

import { PRBMathMock } from "../typechain/PRBMathMock";
import { Signers } from "./";

declare module "mocha" {
  export interface Context {
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    prbMath: PRBMathMock;
    signers: Signers;
  }
}
