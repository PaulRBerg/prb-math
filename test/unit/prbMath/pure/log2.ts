import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LOG2_MAX_59x18, MAX_59x18, MAX_WHOLE_59x18, PI, UNIT, ZERO } from "../../../../helpers/constants";
import { bn, fp, fpPowOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  describe("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.prbMath.doLog2(x)).to.be.reverted;
    });
  });

  describe("when x is a negative number", function () {
    it("reverts", async function () {
      const x: BigNumber = fp(-0.1);
      await expect(this.prbMath.doLog2(x)).to.be.reverted;
    });
  });

  describe("when x is a positive number", function () {
    const testSets = [
      [fp(0.1), bn("-3321928094887362334")],
      [fp(0.2), bn("-2321928094887362334")],
      [fp(0.3), bn("-1736965594166206154")],
      [fp(0.4), bn("-1321928094887362334")],
      [fp(0.5), fp(-1)],
      [fp(0.6), bn("-736965594166206154")],
      [fp(0.7), bn("-514573172829758229")],
      [fp(0.8), bn("-321928094887362334")],
      [fp(0.9), bn("-152003093445049973")],
      [fp(1), ZERO],
      [fp(1.125), bn("169925001442312346")],
      [fp(2), UNIT],
      [E, bn("1442695040888963394")],
      [PI, bn("1651496129472318782")],
      [fp(4), fp(2)],
      [fp(8), fp(3)],
      [fpPowOfTwo(195), fp(195)],
      [MAX_WHOLE_59x18, LOG2_MAX_59x18],
      // The same as above due to of precision limitations
      [MAX_59x18, LOG2_MAX_59x18],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.prbMath.doLog2(x);
      expect(result).to.equal(expected);
    });
  });
}
