import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  describe("when x is a whole number", function () {
    it("works when x = 4", async function () {
      const logarithm: BigNumber = await this.prbMath.doLog2(fp(4));
      expect(logarithm).to.equal(fp(2));
    });
  });

  describe("when x is a fractional number", function () {
    it("works when x = 1.125", async function () {
      const logarithm: BigNumber = await this.prbMath.doLog2(bn(1.125e18));
      expect(logarithm).to.equal(bn("169925001442312346"));
    });
  });
}
