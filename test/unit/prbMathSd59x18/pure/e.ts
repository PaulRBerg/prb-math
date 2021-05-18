import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { E } from "../../../../helpers/constants";
import { fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeEGetter(): void {
  it("returns the e number", async function () {
    const result: BigNumber = await this.contracts.prbMathSd59x18.getE();
    expect(fp(E)).to.equal(result);
  });
}
