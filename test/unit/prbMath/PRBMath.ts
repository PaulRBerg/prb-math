import hre from "hardhat";
import { Artifact } from "hardhat/types";

import { PRBMathMock } from "../../../typechain/PRBMathMock";
import { shouldBehaveLikePrbMath } from "./PRBMath.behavior";
import { baseContext } from "../../contexts";

const { deployContract } = hre.waffle;

baseContext("Unit tests", function () {
  describe("PRBMath", function () {
    beforeEach(async function () {
      const prbMathMockArtifact: Artifact = await hre.artifacts.readArtifact("PRBMathMock");
      this.contracts.prbMath = <PRBMathMock>await deployContract(this.signers.admin, prbMathMockArtifact, []);
    });

    shouldBehaveLikePrbMath();
  });
});
