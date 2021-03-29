import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_59x18, MAX_WHOLE_59x18, MIN_59x18, MIN_WHOLE_59x18, PI, UNIT, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeAbs(): void {
  context("when x is zero", function () {
    it("returns zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.prbMath.doAbs(x);
      expect(result).to.equal(ZERO);
    });
  });

  context("when x is a negative number", function () {
    context("when x = min 59x18", function () {
      it("reverts", async function () {
        const x: BigNumber = MIN_59x18;
        await expect(this.prbMath.doAbs(x)).to.be.reverted;
      });
    });

    context("when x > min 59x18", function () {
      const testSets = [
        [MIN_59x18.add(1), MAX_59x18],
        [MIN_WHOLE_59x18, MAX_WHOLE_59x18],
        [bn(-1e18).mul(UNIT), bn(1e18).mul(UNIT)],
        [fp(-4.2), fp(4.2)],
        [fp(-2), fp(2)],
        [PI.mul(-1), PI],
        [fp(-1.125), fp(1.125)],
        [fp(-1), UNIT],
        [fp(-0.5), fp(0.5)],
        [fp(-0.1), fp(0.1)],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.prbMath.doAbs(x);
        expect(result).to.equal(expected);
      });
    });
  });

  context("when x is a positive number", function () {
    context("when x > min 59x18", function () {
      const testSets = [
        [fp(0.1), fp(0.1)],
        [fp(0.5), fp(0.5)],
        [UNIT, UNIT],
        [fp(1.125), fp(1.125)],
        [fp(2), fp(2)],
        [PI, PI],
        [fp(4.2), fp(4.2)],
        [bn(1e18).mul(UNIT), bn(1e18).mul(UNIT)],
        [MAX_WHOLE_59x18, MAX_WHOLE_59x18],
        [MAX_59x18, MAX_59x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.prbMath.doAbs(x);
        expect(result).to.equal(expected);
      });
    });
  });
}
