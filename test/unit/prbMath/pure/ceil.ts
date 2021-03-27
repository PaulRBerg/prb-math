import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { MAX_59x18, MAX_WHOLE_59x18, MIN_59x18, MIN_WHOLE_59x18, PI } from "../../../../helpers/constants";
import { fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeCeil(): void {
  describe("when x is zero", function () {
    it("works", async function () {
      const x: number = 0;
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(0);
    });
  });

  describe("when x is a negative number", function () {
    it("works when x = -0.1", async function () {
      const x: BigNumber = fp(-0.1);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(0);
    });

    it("works when x = -0.5", async function () {
      const x: BigNumber = fp(-0.5);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(0);
    });

    it("works when x = -1", async function () {
      const x: BigNumber = fp(-1);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(x);
    });

    it("works when x = -1.125", async function () {
      const x: BigNumber = fp(-1.125);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(fp(-1));
    });

    it("works when x = -2", async function () {
      const x: BigNumber = fp(-2);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(x);
    });

    it("works when x = -pi", async function () {
      const x: BigNumber = PI.mul(-1);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(fp(-3));
    });

    it("works when x = -4.2", async function () {
      const x: BigNumber = fp(-4.2);
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(fp(-4));
    });

    it("works when x = min whole 59x18", async function () {
      const x: BigNumber = MIN_WHOLE_59x18;
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(MIN_WHOLE_59x18);
    });

    it("works when x = min 59x18", async function () {
      const x: BigNumber = MIN_59x18;
      const ceiledX: BigNumber = await this.prbMath.doCeil(x);
      expect(ceiledX).to.equal(MIN_WHOLE_59x18);
    });
  });

  describe("when x is a positive number", function () {
    describe("when x > max whole 59x18", function () {
      it("reverts when x = max whole 59x18 + 1", async function () {
        const x: BigNumber = MAX_WHOLE_59x18.add(1);
        await expect(this.prbMath.doCeil(x)).to.be.reverted;
      });

      it("reverts when x = max 59x18", async function () {
        const x: BigNumber = MAX_59x18;
        await expect(this.prbMath.doCeil(x)).to.be.reverted;
      });
    });

    describe("when x <= max whole 59x18", function () {
      it("works when x = 0.1", async function () {
        const x: BigNumber = fp(0.1);
        const logarithm: BigNumber = await this.prbMath.doCeil(x);
        expect(logarithm).to.equal(fp(1));
      });

      it("works when x = 0.5", async function () {
        const x: BigNumber = fp(0.5);
        const logarithm: BigNumber = await this.prbMath.doCeil(x);
        expect(logarithm).to.equal(fp(1));
      });

      it("works when x = 1", async function () {
        const x: BigNumber = fp(1);
        const logarithm: BigNumber = await this.prbMath.doCeil(x);
        expect(logarithm).to.equal(x);
      });

      it("works when x = 1.125", async function () {
        const x: BigNumber = fp(1.125);
        const logarithm: BigNumber = await this.prbMath.doCeil(x);
        expect(logarithm).to.equal(fp(2));
      });

      it("works when x = 1", async function () {
        const x: BigNumber = fp(1);
        const ceiledX: BigNumber = await this.prbMath.doCeil(x);
        expect(ceiledX).to.equal(x);
      });

      it("works when x = 2", async function () {
        const x: BigNumber = fp(2);
        const ceiledX: BigNumber = await this.prbMath.doCeil(x);
        expect(ceiledX).to.equal(x);
      });

      it("works when x = pi", async function () {
        const x: BigNumber = PI;
        const ceiledX: BigNumber = await this.prbMath.doCeil(x);
        expect(ceiledX).to.equal(fp(4));
      });

      it("works when x = 4.2", async function () {
        const x: BigNumber = fp(4.2);
        const ceiledX: BigNumber = await this.prbMath.doCeil(x);
        expect(ceiledX).to.equal(fp(5));
      });

      it("works when x = max whole 59x18", async function () {
        const x: BigNumber = MAX_WHOLE_59x18;
        const ceiledX: BigNumber = await this.prbMath.doCeil(x);
        expect(ceiledX).to.equal(x);
      });
    });
  });
}