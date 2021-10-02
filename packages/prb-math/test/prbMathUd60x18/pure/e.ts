import type { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import { E } from "hardhat-prb-math/dist/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("returns the e number", async function () {
    const expected: BigNumber = E;
    expect(expected).to.equal(await this.contracts.prbMathUd60x18.getE());
    expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.getE());
  });
}