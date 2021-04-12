import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { E } from "../../../../helpers/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("retrieves the e number", async function () {
    const result: BigNumber = await this.contracts.prbMathSD59x18.getE();
    expect(E).to.equal(result);
  });
}
