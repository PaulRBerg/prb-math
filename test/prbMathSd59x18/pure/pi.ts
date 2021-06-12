import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";

import { PI } from "../../../helpers/constants";

export default function shouldBehaveLikePiGetter(): void {
  it("returns pi", async function () {
    const expected: BigNumber = fp(PI);
    expect(expected).to.equal(await this.contracts.prbMathSd59x18.getPi());
    expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.getPi());
  });
}
