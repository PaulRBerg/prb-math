import type { BigNumber } from "@ethersproject/bignumber";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { Fixture } from "ethereum-waffle";

import type { PRBMathSD59x18Mock } from "../../src/types/test/PRBMathSD59x18Mock";
import type { PRBMathUD60x18Mock } from "../../src/types/test/PRBMathUD60x18Mock";

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
  prbMathUd60x18: PRBMathUD60x18Mock;
}
export interface Signers {
  admin: SignerWithAddress;
  alice: SignerWithAddress;
}
