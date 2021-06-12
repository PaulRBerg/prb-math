import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";

import { SCALE } from "../../../helpers/constants";

export default function shouldBehaveLikeScaleGetter(): void {
  it("returns the scale number", async function () {
    const expected: BigNumber = fp(SCALE);
    expect(expected).to.equal(await this.contracts.prbMathSd59x18.getScale());
    expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.getScale());
  });
}
