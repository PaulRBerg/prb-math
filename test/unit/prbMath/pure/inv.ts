import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_59x18, MAX_WHOLE_59x18, MIN_59x18, MIN_WHOLE_59x18, PI, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeInv(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMath.doInv(x)).to.be.reverted;
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      const testSets = [
        [MIN_59x18, ZERO],
        [MIN_WHOLE_59x18, ZERO],
        [bn(-1e36).sub(1), ZERO],
        [bn(-1e36), fp(-0.000000000000000001)],
        [fp(-2503), fp(-0.000399520575309628)],
        [fp(-772.05), fp(-0.001295252898128359)],
        [fp(-100.135), fp(-0.00998651820042942)],
        [fp(-22), bn("-45454545454545454")],
        [fp(-4), fp(-0.25)],
        [PI.mul(-1), bn("-318309886183790671")],
        [fp(-2), fp(-0.5)],
        [fp(-1), fp(-1)],
        [fp(-0.1), fp(-10)],
        [fp(-0.05), fp(-20)],
        [fp(-0.00001), bn(-1e23)],
        [fp(-0.000000000000000001), bn(-1e36)],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doInv(x);
        expect(expected).to.equal(result);
      });
    });

    context("when x is positive", function () {
      const testSets = [
        [fp(0.000000000000000001), bn(1e36)],
        [fp(0.00001), bn(1e23)],
        [fp(0.05), fp(20)],
        [fp(0.1), fp(10)],
        [fp(1), fp(1)],
        [fp(2), fp(0.5)],
        [PI, bn("318309886183790671")],
        [fp(4), fp(0.25)],
        [fp(22), bn("45454545454545454")],
        [fp(100.135), fp(0.00998651820042942)],
        [fp(772.05), fp(0.001295252898128359)],
        [fp(2503), fp(0.000399520575309628)],
        [bn(1e36), fp(0.000000000000000001)],
        [bn(1e36).add(1), ZERO],
        [MAX_WHOLE_59x18, ZERO],
        [MAX_59x18, ZERO],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doInv(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
