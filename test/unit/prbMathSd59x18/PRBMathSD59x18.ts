import hre from "hardhat";
import { Artifact } from "hardhat/types";

import { PRBMathSD59x18Mock } from "../../../typechain/PRBMathSD59x18Mock";
import { shouldBehaveLikePrbMathSd59x18 } from "./PRBMathSD59x18.behavior";
import { baseContext } from "../../contexts";

const { deployContract } = hre.waffle;

baseContext("Unit tests", function () {
  describe("PRBMathSD59x18", function () {
    beforeEach(async function () {
      const prbMathSD59x18MockArtifact: Artifact = await hre.artifacts.readArtifact("PRBMathSD59x18Mock");
      this.contracts.prbMathSD59x18 = <PRBMathSD59x18Mock>(
        await deployContract(this.signers.admin, prbMathSD59x18MockArtifact, [])
      );
    });

    shouldBehaveLikePrbMathSd59x18();
  });
});
