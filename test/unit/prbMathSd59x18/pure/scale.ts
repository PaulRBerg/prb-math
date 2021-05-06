import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { SCALE } from "../../../../helpers/constants";

export default function shouldBehaveLikeScaleGetter(): void {
  it("retrieves the scale number", async function () {
    const result: BigNumber = await this.contracts.prbMathSd59x18.getScale();
    expect(SCALE).to.equal(result);
  });
}
