import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_59x18, MAX_WHOLE_59x18, MIN_59x18, MIN_WHOLE_59x18, PI, UNIT, ZERO } from "../../../../helpers/constants";
import { bn, fp, solidityMod } from "../../../../helpers/numbers";

export default function shouldBehaveLikeFrac(): void {
  context("when x is zero", function () {
    it("works", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.prbMath.doFrac(x);
      expect(result).to.equal(ZERO);
    });
  });

  context("when x is negative", function () {
    const testSets = [
      [MIN_59x18, solidityMod(MIN_59x18, UNIT)],
      [MIN_WHOLE_59x18, ZERO],
      [bn(-1e18).mul(UNIT), ZERO],
      [fp(-4.2), fp(-0.2)],
      [PI.mul(-1), solidityMod(PI.mul(-1), UNIT)],
      [fp(-2), ZERO],
      [fp(-1.125), fp(-0.125)],
      [fp(-1), ZERO],
      [fp(-0.5), fp(-0.5)],
      [fp(-0.1), fp(-0.1)],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.prbMath.doFrac(x);
      expect(result).to.equal(expected);
    });
  });

  context("when x is positive", function () {
    const testSets = [
      [fp(0.1), fp(0.1)],
      [fp(0.5), fp(0.5)],
      [UNIT, ZERO],
      [fp(1.125), fp(0.125)],
      [fp(2), ZERO],
      [PI, solidityMod(PI, UNIT)],
      [fp(4.2), fp(0.2)],
      [bn(1e18).mul(UNIT), ZERO],
      [MAX_WHOLE_59x18, ZERO],
      [MAX_59x18, solidityMod(MAX_59x18, UNIT)],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.prbMath.doFrac(x);
      expect(result).to.equal(expected);
    });
  });
}
