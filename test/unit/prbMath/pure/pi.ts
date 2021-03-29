import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { PI } from "../../../../helpers/constants";

export default function shouldBehaveLikePiGetter(): void {
  it("should retrieve PI", async function () {
    const result: BigNumber = await this.prbMath.getPi();
    expect(result).to.equal(PI);
  });
}
