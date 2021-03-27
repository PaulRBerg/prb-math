import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { UNIT } from "../../../../helpers/constants";

export default function shouldBehaveLikeUnit(): void {
  it("should read the UNIT number", async function () {
    const contractUNIT: BigNumber = await this.prbMath.getUnit();
    expect(contractUNIT).to.equal(UNIT);
  });
}
