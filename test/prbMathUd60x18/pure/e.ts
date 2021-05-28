import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";

import { E } from "../../../helpers/constants";

export default function shouldBehaveLikeEGetter(): void {
  it("returns the e number", async function () {
    const result: BigNumber = await this.contracts.prbMathUd60x18.getE();
    expect(fp(E)).to.equal(result);
  });
}
