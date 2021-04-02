import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_58x18, MAX_WHOLE_58x18, MIN_58x18, MIN_WHOLE_58x18, PI, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeAbs(): void {
  context("when x is zero", function () {
    it("returns zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMath.doAbs(x);
      expect(result).to.equal(ZERO);
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      context("when x = min 58.18", function () {
        it("reverts", async function () {
          const x: BigNumber = MIN_58x18;
          await expect(this.contracts.prbMath.doAbs(x)).to.be.reverted;
        });
      });

      context("when x > min 58.18", function () {
        const testSets = [
          [MIN_58x18.add(1), MAX_58x18],
          [MIN_WHOLE_58x18, MAX_WHOLE_58x18],
          [bn(-1e36), bn(1e36)],
          [fp(-4.2), fp(4.2)],
          [fp(-2), fp(2)],
          [PI.mul(-1), PI],
          [fp(-1.125), fp(1.125)],
          [fp(-1), fp(1)],
          [fp(-0.5), fp(0.5)],
          [fp(-0.1), fp(0.1)],
        ];

        forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
          const result: BigNumber = await this.contracts.prbMath.doAbs(x);
          expect(result).to.equal(expected);
        });
      });
    });

    context("when x is positive", function () {
      context("when x > min 58.18", function () {
        const testSets = [
          [fp(0.1), fp(0.1)],
          [fp(0.5), fp(0.5)],
          [fp(1), fp(1)],
          [fp(1.125), fp(1.125)],
          [fp(2), fp(2)],
          [PI, PI],
          [fp(4.2), fp(4.2)],
          [bn(1e36), bn(1e36)],
          [MAX_WHOLE_58x18, MAX_WHOLE_58x18],
          [MAX_58x18, MAX_58x18],
        ];

        forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
          const result: BigNumber = await this.contracts.prbMath.doAbs(x);
          expect(result).to.equal(expected);
        });
      });
    });
  });
}
