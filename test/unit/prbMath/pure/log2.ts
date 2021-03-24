import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { MAX_INT256, UNIT, ZERO_ADDRESS } from "../../../../helpers/constants";
import { bn, fp, powOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  describe("when x is negative", function () {
    it("reverts", async function () {
      await expect(this.prbMath.doLog2(fp(-1))).to.reverted;
    });
  });

  describe("when x is zero", function () {
    it("reverts", async function () {
      await expect(this.prbMath.doLog2(ZERO_ADDRESS)).to.reverted;
    });
  });

  describe("when x is a whole number", function () {
    it("works when x = 2**0", async function () {
      const x: BigNumber = fp(1);
      const logarithm: BigNumber = await this.prbMath.doLog2(x);
      expect(logarithm).to.equal(ZERO_ADDRESS);
    });

    it("works when x = 2**1", async function () {
      const x: BigNumber = fp(2);
      const logarithm: BigNumber = await this.prbMath.doLog2(x);
      expect(logarithm).to.equal(fp(1));
    });

    it("works when x = 2**2", async function () {
      const x: BigNumber = fp(4);
      const logarithm: BigNumber = await this.prbMath.doLog2(x);
      expect(logarithm).to.equal(fp(2));
    });

    it("works when x = 2**195", async function () {
      const x: BigNumber = powOfTwo(195).mul(UNIT);
      const logarithm: BigNumber = await this.prbMath.doLog2(x);
      expect(logarithm).to.equal(fp(195));
    });
  });

  describe("when x is a fractional number", function () {
    describe("when x is lower than 1", function () {
      it("works when x = 0.5", async function () {
        const x: BigNumber = fp(0.5);
        const logarithm: BigNumber = await this.prbMath.doLog2(x);
        expect(logarithm).to.equal(fp(-1));
      });
    });

    describe("when x is higher than 1", function () {
      it("works when x = 1.125", async function () {
        const x: BigNumber = bn(1.125e18);
        const logarithm: BigNumber = await this.prbMath.doLog2(x);
        expect(logarithm).to.equal(bn("169925001442312346"));
      });

      it("works when x = max int256", async function () {
        const x: BigNumber = MAX_INT256;
        const logarithm: BigNumber = await this.prbMath.doLog2(x);
        // Wolfram gives 38 instead of 28 at the end, but that's because they have better precision.
        expect(logarithm).to.equal(bn("195205294292027477728"));
      });
    });
  });
}
