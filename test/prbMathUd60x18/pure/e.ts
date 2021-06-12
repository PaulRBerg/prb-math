import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";

import { E } from "../../../helpers/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("returns the e number", async function () {
    const expected: BigNumber = fp(E);
    expect(expected).to.equal(await this.contracts.prbMathUd60x18.getE());
    expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.getE());
  });
}
