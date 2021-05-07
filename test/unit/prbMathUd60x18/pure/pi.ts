import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { PI } from "../../../../helpers/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("returns pi", async function () {
    const result: BigNumber = await this.contracts.prbMathUd60x18.getPi();
    expect(PI).to.equal(result);
  });
}
