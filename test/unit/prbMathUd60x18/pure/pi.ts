import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { PI } from "../../../../helpers/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("retrieves pi", async function () {
    const result: BigNumber = await this.contracts.prbMathUD60x18.getPi();
    expect(PI).to.equal(result);
  });
}
