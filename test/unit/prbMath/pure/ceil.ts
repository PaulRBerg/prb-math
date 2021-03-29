import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_59x18, MAX_WHOLE_59x18, MIN_59x18, MIN_WHOLE_59x18, PI, UNIT, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeCeil(): void {
  context("when x is zero", function () {
    it("works", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.prbMath.doCeil(x);
      expect(result).to.equal(x);
    });
  });

  context("when x is a negative number", function () {
    const testSets = [
      [MIN_59x18, MIN_WHOLE_59x18],
      [MIN_WHOLE_59x18, MIN_WHOLE_59x18],
      [bn(-1e18).mul(UNIT), bn(-1e18).mul(UNIT)],
      [fp(-4.2), fp(-4)],
      [PI.mul(-1), fp(-3)],
      [fp(-2), fp(-2)],
      [fp(-1), fp(-1)],
      [fp(-1.125), fp(-1)],
      [fp(-0.5), ZERO],
      [fp(-0.1), ZERO],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.prbMath.doCeil(x);
      expect(result).to.equal(expected);
    });
  });

  context("when x is a positive number", function () {
    context("when x > max whole 59x18", function () {
      const testSets = [[MAX_WHOLE_59x18.add(1)], [MAX_59x18]];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.prbMath.doCeil(x)).to.be.reverted;
      });
    });

    context("when x <= max whole 59x18", function () {
      const testSets = [
        [fp(0.1), UNIT],
        [fp(0.5), UNIT],
        [UNIT, UNIT],
        [fp(1.125), fp(2)],
        [fp(2), fp(2)],
        [PI, fp(4)],
        [fp(4.2), fp(5)],
        [bn(1e18).mul(UNIT), bn(1e18).mul(UNIT)],
        [MAX_WHOLE_59x18, MAX_WHOLE_59x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.prbMath.doCeil(x);
        expect(result).to.equal(expected);
      });
    });
  });
}
