import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { SCALE } from "../../../../helpers/constants";
import { fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeScaleGetter(): void {
  it("returns the scale number", async function () {
    const result: BigNumber = await this.contracts.prbMathSd59x18.getScale();
    expect(fp(SCALE)).to.equal(result);
  });
}
