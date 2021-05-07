import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { SCALE } from "../../../../helpers/constants";

export default function shouldBehaveLikeScaleGetter(): void {
  it("returns the scale number", async function () {
    const result: BigNumber = await this.contracts.prbMathUd60x18.getScale();
    expect(SCALE).to.equal(result);
  });
}
