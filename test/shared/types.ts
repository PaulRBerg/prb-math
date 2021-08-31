import { BigNumber } from "@ethersproject/bignumber";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { Fixture } from "ethereum-waffle";

import { PRBMathSD59x18Mock } from "../../typechain/PRBMathSD59x18Mock";
import { PRBMathSD59x18TypedMock } from "../../typechain/PRBMathSD59x18TypedMock";
import { PRBMathUD60x18Mock } from "../../typechain/PRBMathUD60x18Mock";
import { PRBMathUD60x18TypedMock } from "../../typechain/PRBMathUD60x18TypedMock";

declare global {
  export namespace Chai {
    interface Assertion {
      near(actual: BigNumber): void;
    }
  }
}

declare module "mocha" {
  export interface Context {
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    contracts: Contracts;
    signers: Signers;
  }
}

export interface Contracts {
  prbMathSd59x18: PRBMathSD59x18Mock;
  prbMathSd59x18Typed: PRBMathSD59x18TypedMock;
  prbMathUd60x18: PRBMathUD60x18Mock;
  prbMathUd60x18Typed: PRBMathUD60x18TypedMock;
}
export interface Signers {
  admin: SignerWithAddress;
  alice: SignerWithAddress;
}
