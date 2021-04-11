import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import { PRBMathSD59x18Mock } from "../typechain/PRBMathSD59x18Mock";
import { PRBMathUD60x18Mock } from "../typechain/PRBMathUD60x18Mock";

export interface Contracts {
  prbMathSD59x18: PRBMathSD59x18Mock;
  prbMathUD60x18: PRBMathUD60x18Mock;
}
export interface Signers {
  admin: SignerWithAddress;
  alice: SignerWithAddress;
}
