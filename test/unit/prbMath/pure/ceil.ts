import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_58x18, MAX_WHOLE_58x18, MIN_58x18, MIN_WHOLE_58x18, PI, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeCeil(): void {
  context("when x is zero", function () {
    it("returns zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMath.doCeil(x);
      expect(result).to.equal(ZERO);
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      const testSets = [
        [MIN_58x18, MIN_WHOLE_58x18],
        [MIN_WHOLE_58x18, MIN_WHOLE_58x18],
        [bn(-1e36), bn(-1e36)],
        [fp(-4.2), fp(-4)],
        [PI.mul(-1), fp(-3)],
        [fp(-2), fp(-2)],
        [fp(-1), fp(-1)],
        [fp(-1.125), fp(-1)],
        [fp(-0.5), ZERO],
        [fp(-0.1), ZERO],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doCeil(x);
        expect(result).to.equal(expected);
      });
    });

    context("when x is positive", function () {
      context("when x > max whole 58.18", function () {
        const testSets = [[MAX_WHOLE_58x18.add(1)], [MAX_58x18]];

        forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
          await expect(this.contracts.prbMath.doCeil(x)).to.be.reverted;
        });
      });

      context("when x <= max whole 58.18", function () {
        const testSets = [
          [fp(0.1), fp(1)],
          [fp(0.5), fp(1)],
          [fp(1), fp(1)],
          [fp(1.125), fp(2)],
          [fp(2), fp(2)],
          [PI, fp(4)],
          [fp(4.2), fp(5)],
          [bn(1e36), bn(1e36)],
          [MAX_WHOLE_58x18, MAX_WHOLE_58x18],
        ];

        forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
          const result: BigNumber = await this.contracts.prbMath.doCeil(x);
          expect(result).to.equal(expected);
        });
      });
    });
  });
}
