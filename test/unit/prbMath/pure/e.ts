import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { E } from "../../../../helpers/constants";

export default function shouldBehaveLikePiGetter(): void {
  it("returns E", async function () {
    const result: BigNumber = await this.prbMath.getE();
    expect(result).to.equal(E);
  });
}
