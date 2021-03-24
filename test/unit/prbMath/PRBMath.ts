import hre from "hardhat";
import { Artifact } from "hardhat/types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import { PRBMathMock } from "../../../typechain/PRBMathMock";
import { Signers } from "../../../types";
import { shouldBehaveLikePrbMath } from "./PRBMath.behavior";

const { deployContract } = hre.waffle;

describe("Unit tests", function () {
  before(async function () {
    this.signers = {} as Signers;

    const signers: SignerWithAddress[] = await hre.ethers.getSigners();
    this.signers.admin = signers[0];
  });

  describe("PRBMath", function () {
    beforeEach(async function () {
      const prbMathMockArtifact: Artifact = await hre.artifacts.readArtifact("PRBMathMock");
      this.prbMath = <PRBMathMock>await deployContract(this.signers.admin, prbMathMockArtifact, []);
    });

    shouldBehaveLikePrbMath();
  });
});
