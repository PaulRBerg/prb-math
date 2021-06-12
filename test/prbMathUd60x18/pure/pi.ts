import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";

import { PI } from "../../../helpers/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("returns pi", async function () {
    const expected: BigNumber = fp(PI);
    expect(expected).to.equal(await this.contracts.prbMathUd60x18.getPi());
    expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.getPi());
  });
}
