import type { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { SCALE } from "../../../../src/constants";

export function shouldBehaveLikeScaleGetter(): void {
  it("returns the scale number", async function () {
    const expected: BigNumber = SCALE;
    expect(expected).to.equal(await this.contracts.prbMathSd59x18.getScale());
    expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.getScale());
  });
}
