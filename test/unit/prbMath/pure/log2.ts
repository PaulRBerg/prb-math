import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { LOG2_MAX_59x18, LOG2_PI, MAX_59x18, MAX_WHOLE_59x18, PI, ZERO_ADDRESS } from "../../../../helpers/constants";
import { bn, fp, fpPowOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  describe("when x is a negative number", function () {
    it("reverts", async function () {
      await expect(this.prbMath.doLog2(fp(-1))).to.reverted;
    });
  });

  describe("when x is zero", function () {
    it("reverts", async function () {
      const x: number = 0;
      await expect(this.prbMath.doLog2(x)).to.be.reverted;
    });
  });

  describe("when x is a positive number", function () {
    describe("when x is a real number", function () {
      it("works when x = 0.1", async function () {
        const x: BigNumber = fp(0.1);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(bn("-3321928094887362334"));
      });

      it("works when x = 0.2", async function () {
        const x: BigNumber = fp(0.2);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(bn("-2321928094887362334"));
      });

      it("works when x = 0.25", async function () {
        const x: BigNumber = fp(0.25);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(fp(-2));
      });

      it("works when x = 0.4", async function () {
        const x: BigNumber = fp(0.4);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(bn("-1321928094887362334"));
      });

      it("works when x = 0.5", async function () {
        const x: BigNumber = fp(0.5);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(fp(-1));
      });

      it("works when x = 0.8", async function () {
        const x: BigNumber = fp(0.8);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(bn("-321928094887362334"));
      });

      it("works when x = 1.125", async function () {
        const x: BigNumber = fp(1.125);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(bn("169925001442312346"));
      });

      it("works when x = pi", async function () {
        const x: BigNumber = PI;
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(LOG2_PI);
      });

      it("works when x = max 59x18", async function () {
        const x: BigNumber = MAX_59x18;
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(LOG2_MAX_59x18);
      });
    });

    describe("when x is a natural number", function () {
      it("works when x = 1", async function () {
        const x: BigNumber = fp(1);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(ZERO_ADDRESS);
      });

      it("works when x = 2", async function () {
        const x: BigNumber = fp(2);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(fp(1));
      });

      it("works when x = 4", async function () {
        const x: BigNumber = fpPowOfTwo(2);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(fp(2));
      });

      it("works when x = 8", async function () {
        const x: BigNumber = fpPowOfTwo(3);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(fp(3));
      });

      it("works when x = 2**195", async function () {
        const x: BigNumber = fpPowOfTwo(195);
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(fp(195));
      });

      it("works when x = max whole 59x18", async function () {
        const x: BigNumber = MAX_WHOLE_59x18;
        const result: BigNumber = await this.prbMath.doLog2(x);
        expect(result).to.equal(LOG2_MAX_59x18);
      });
    });
  });
}
