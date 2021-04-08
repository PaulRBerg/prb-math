import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LOG2_MAX_59x18, MAX_59x18, MAX_WHOLE_59x18, PI, ZERO } from "../../../../helpers/constants";
import { bn, fp, fpPowOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMath.doLog2(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp(-0.1);
      await expect(this.contracts.prbMath.doLog2(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context("when x is a power of two", function () {
      const testSets = [
        [fp(0.0625), fp(-4)],
        [fp(0.125), fp(-3)],
        [fp(0.25), fp(-2)],
        [fp(0.5), fp(-1)],
        [fp(1), ZERO],
        [fp(2), fp(1)],
        [fp(4), fp(2)],
        [fp(8), fp(3)],
        [fp(16), fp(4)],
        [fpPowOfTwo(195), fp(195)],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doLog2(x);
        expect(expected).to.equal(result);
      });
    });

    context("when x is not a power of two", function () {
      const testSets = [
        [fp(0.0091), bn("-6779917739350753112")],
        [fp(0.083), bn("-3590744853315162277")],
        [fp(0.1), bn("-3321928094887362334")],
        [fp(0.2), bn("-2321928094887362334")],
        [fp(0.3), bn("-1736965594166206154")],
        [fp(0.4), bn("-1321928094887362334")],
        [fp(0.6), bn("-736965594166206154")],
        [fp(0.7), bn("-514573172829758229")],
        [fp(0.8), bn("-321928094887362334")],
        [fp(0.9), bn("-152003093445049973")],
        [fp(1.125), bn("169925001442312346")],
        [E, bn("1442695040888963394")],
        [PI, bn("1651496129472318782")],
        [bn(1e36), bn("59794705707972522245")],
        [MAX_WHOLE_59x18, LOG2_MAX_59x18],
        [MAX_59x18, LOG2_MAX_59x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doLog2(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
