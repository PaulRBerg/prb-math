import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import { PRBMathMock } from "../typechain/PRBMathMock";

export interface Contracts {
  prbMath: PRBMathMock;
}
export interface Signers {
  admin: SignerWithAddress;
  alice: SignerWithAddress;
}
