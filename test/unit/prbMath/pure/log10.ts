import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LOG10_MAX_59x18, MAX_59x18, MAX_WHOLE_59x18, PI, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog10(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMath.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp(-0.1);
      await expect(this.contracts.prbMath.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context("when x is a power of ten", function () {
      const testSets = [
        [bn(1), fp(-18)],
        [bn(10), fp(-17)],
        [bn(1e4), fp(-14)],
        [bn(1e8), fp(-10)],
        [bn(1e10), fp(-8)],
        [bn(1e11), fp(-7)],
        [bn(1e15), fp(-3)],
        [bn(1e17), fp(-1)],
        [fp(1), ZERO],
        [bn(1e19), fp(1)],
        [bn(1e20), fp(2)],
        [bn(1e36), fp(18)],
        [bn(1e67), fp(49)],
        [bn(1e75), fp(57)],
        [bn(1e76), fp(58)],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doLog10(x);
        expect(result).to.equal(expected);
      });
    });

    context("when x is not a power of ten", function () {
      const testSets = [
        [fp(0.000000000007892191), bn("-111028024128721664814")],
        [fp(0.0091), bn("-20409586076789064014")],
        [fp(0.083), bn("-10809219076239260956")],
        [fp(0.1982), bn("-7028963498507434743")],
        [fp(0.313), bn("-5044556624535515126")],
        [fp(0.4666), bn("-3310552655422661758")],
        [fp(1).add(bn(1e4)), fp(0.000000000000043414)],
        [E, bn("4342944819032518246")],
        [PI, bn("4971498726941338506")],
        [fp(4), bn("6020599913279623918")],
        [fp(16), bn("12041199826559247837")],
        [fp(32), bn("15051499783199059796")],
        [fp(42.12), bn("16244883625134489086")],
        [fp(1010.892143), bn("30047048210719801170")],
        [fp(440934.1881), bn("56443737734181779783")],
        [bn(1e36).add(1e6), bn("180000000000000000376")],
        [MAX_WHOLE_59x18, LOG10_MAX_59x18],
        [MAX_59x18, LOG10_MAX_59x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMath.doLog10(x);
        expect(result).to.equal(expected);
      });
    });
  });
}
