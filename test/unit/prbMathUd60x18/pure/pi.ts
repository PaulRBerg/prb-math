import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { PI } from "../../../../helpers/constants";
import { fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeEGetter(): void {
  it("returns pi", async function () {
    const result: BigNumber = await this.contracts.prbMathUd60x18.getPi();
    expect(fp(PI)).to.equal(result);
  });
}
