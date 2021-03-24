import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  describe("when x is zero", function () {
    it("reverts", async function () {
      await expect(this.prbMath.doLog2(Zero)).to.reverted;
    });
  });

  describe("when x is a whole number", function () {
    it("works when x = 1", async function () {
      const logarithm: BigNumber = await this.prbMath.doLog2(fp(1));
      expect(logarithm).to.equal(Zero);
    });

    it("works when x = 2", async function () {
      const logarithm: BigNumber = await this.prbMath.doLog2(fp(2));
      expect(logarithm).to.equal(fp(1));
    });

    it("works when x = 4", async function () {
      const logarithm: BigNumber = await this.prbMath.doLog2(fp(4));
      expect(logarithm).to.equal(fp(2));
    });
  });

  describe("when x is a fractional number", function () {
    describe("when x is lower than 1", function () {
      it("works when x = 0.5", async function () {
        const logarithm: BigNumber = await this.prbMath.doLog2(fp(0.5));
        expect(logarithm).to.equal(fp(-1));
      });
    });

    describe("when x is higher than 1", function () {
      it("works when x = 1.125", async function () {
        const logarithm: BigNumber = await this.prbMath.doLog2(bn(1.125e18));
        expect(logarithm).to.equal(bn("169925001442312346"));
      });
    });
  });
}
