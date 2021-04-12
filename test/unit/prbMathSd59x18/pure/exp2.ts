import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp, fpPowOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikeExp2(): void {
  context("when x is zero", function () {
    it("returns zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathSD59x18.doExp2(x);
      expect(result).to.equal(fp(1));
    });
  });

  context("when x is negative", function () {
    context("when x is lower than -59794705707972522262", function () {
      const testSets = [bn("-59794705707972522262"), MIN_WHOLE_SD59x18, MIN_SD59x18];

      forEach(testSets).it("takes %e and returns zero", async function (x: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doExp2(x);
        expect(ZERO).to.equal(result);
      });
    });

    context("when x is greater than -59794705707972522262", function () {
      const testSets = [
        [bn("-59794705707972522261"), bn(1)],
        [fp(-33.333333), bn("92398923")],
        [fp(-20.82), bn("540201132438")],
        [fp(-16), bn("15258789062500")],
        [fp(-11.89215), bn("263091088065207")],
        [fp(-4), fp(0.0625)],
        [PI.mul(-1), bn("113314732296760873")],
        [fp(-3), fp(0.125)],
        [E.mul(-1), bn("151955223257912965")],
        [fp(-2), fp(0.25)],
        [fp(-1), fp(0.5)],
        [fp(-0.000000000000001), bn("999999999999999307")],
        [fp(-0.000000000000000001), fp(1)], // because this is very close to zero
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doExp2(x);
        expect(expected).to.equal(result);
      });
    });
  });

  context("when x is positive", function () {
    context("when x is 128e18 or greater", function () {
      const testSets = [fp(128), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSD59x18.doExp2(x)).to.be.reverted;
      });
    });

    context("when x is lower than 128e18", function () {
      const testSets = [
        [fp(0.000000000000000001), fp(1)], // because this is very close to zero
        [fp(0.000000000000001), bn("1000000000000000693")],
        [fp(1), fp(2)],
        [fp(2), fp(4)],
        [E, bn("6580885991017920969")],
        [fp(3), fp(8)],
        [PI, bn("8824977827076287620")],
        [fp(4), fp(16)],
        [fp(11.89215), bn("3800964933301542754554")],
        [fp(16), fpPowOfTwo(16)],
        [fp(20.82), bn("1851162354076939434676257")],
        [fp(33.333333), bn("10822636909120553491465695190")],
        [fp(64), fpPowOfTwo(64)],
        [fp(71.002), bn("2364458806372010440788092434583131235911")],
        [fp(88.7494), bn("520273250104929479199852775847460806142407818")],
        [fp(95), fpPowOfTwo(95)],
        [fp(127), fpPowOfTwo(127)],
        [fp(128).sub(1), bn("340282366920938463220434743172917753977000000000000000000")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doExp2(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
