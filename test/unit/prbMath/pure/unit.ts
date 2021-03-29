import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { UNIT } from "../../../../helpers/constants";

export default function shouldBehaveLikeUnitGetter(): void {
  it("should retrieve UNIT", async function () {
    const result: BigNumber = await this.prbMath.getUnit();
    expect(result).to.equal(UNIT);
  });
}
