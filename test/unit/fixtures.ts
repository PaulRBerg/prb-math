import { Signer } from "@ethersproject/abstract-signer";
import hre from "hardhat";
import { Artifact } from "hardhat/types";

import { PRBMathSD59x18Mock } from "../../typechain/PRBMathSD59x18Mock";
import { PRBMathUD60x18Mock } from "../../typechain/PRBMathUD60x18Mock";

const { deployContract } = hre.waffle;

type UnitFixturePrbMathSd59x18ReturnType = {
  prbMathSd59x18: PRBMathSD59x18Mock;
};

export async function unitFixturePrbMathSd59x18(signers: Signer[]): Promise<UnitFixturePrbMathSd59x18ReturnType> {
  const deployer: Signer = signers[0];
  const prbMathSd59x18MockArtifact: Artifact = await hre.artifacts.readArtifact("PRBMathSD59x18Mock");
  const prbMathSd59x18: PRBMathSD59x18Mock = <PRBMathSD59x18Mock>(
    await deployContract(deployer, prbMathSd59x18MockArtifact, [])
  );
  return { prbMathSd59x18 };
}

type UnitFixturePrbMathUd60x18ReturnType = {
  prbMathUd60x18: PRBMathUD60x18Mock;
};

export async function unitFixturePrbMathUd60x18(signers: Signer[]): Promise<UnitFixturePrbMathUd60x18ReturnType> {
  const deployer: Signer = signers[0];
  const prbMathUd60x18MockArtifact: Artifact = await hre.artifacts.readArtifact("PRBMathUD60x18Mock");
  const prbMathUd60x18: PRBMathUD60x18Mock = <PRBMathUD60x18Mock>(
    await deployContract(deployer, prbMathUd60x18MockArtifact, [])
  );
  return { prbMathUd60x18 };
}
