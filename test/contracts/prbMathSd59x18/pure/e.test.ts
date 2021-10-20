import type { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { E } from "../../../../src/constants";

export function shouldBehaveLikeEGetter(): void {
  it("returns the e number", async function () {
    const expected: BigNumber = E;
    expect(expected).to.equal(await this.contracts.prbMathSd59x18.getE());
    expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.getE());
  });
}
