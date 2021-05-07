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
import { fp, fpPowOfTwo, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeExp2(): void {
  context("when x is zero", function () {
    it("returns 1", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathSd59x18.doExp2(x);
      expect(fp("1")).to.equal(result);
    });
  });

  context("when x is negative", function () {
    context("when x is less than -59.794705707972522261", function () {
      const testSets = [fp("-59.794705707972522262"), MIN_WHOLE_SD59x18, MIN_SD59x18];

      forEach(testSets).it("takes %e and returns zero", async function (x: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp2(x);
        expect(ZERO).to.equal(result);
      });
    });

    context("when x is greater than or equal to -59.794705707972522261", function () {
      const testSets = [
        [fp("-59.794705707972522261"), sfp("1e-18")],
        [fp("-33.333333"), fp("0.000000000092398923")],
        [fp("-20.82"), fp("0.000000540201132438")],
        [fp("-16"), fp("0.0000152587890625")],
        [fp("-11.89215"), fp("0.000263091088065207")],
        [fp("-4"), fp("0.0625")],
        [PI.mul(-1), fp("0.113314732296760873")],
        [fp("-3"), fp("0.125")],
        [E.mul(-1), fp("0.151955223257912965")],
        [fp("-2"), fp("0.25")],
        [fp("-1"), fp("0.5")],
        [sfp("-1e-15"), fp("0.999999999999999307")],
        [sfp("-1e-18"), fp("1")], // because this is very close to zero
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp2(x);
        expect(expected).to.equal(result);
      });
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 128", function () {
      const testSets = [fp("128"), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doExp2(x)).to.be.reverted;
      });
    });

    context("when x is less than 128", function () {
      const testSets = [
        [sfp("1e-18"), fp("1")], // because this is very close to zero
        [sfp("1e-15"), fp("1.000000000000000693")],
        [fp("1"), fp("2")],
        [fp("2"), fp("4")],
        [E, fp("6.580885991017920969")],
        [fp("3"), fp("8")],
        [PI, fp("8.82497782707628762")],
        [fp("4"), fp("16")],
        [fp("11.89215"), fp("3800.964933301542754554")],
        [fp("16"), fpPowOfTwo(16)],
        [fp("20.82"), fp("1851162.354076939434676257")],
        [fp("33.333333"), fp("10822636909.12055349146569519")],
        [fp("64"), fpPowOfTwo(64)],
        [fp("71.002"), fp("2364458806372010440788.092434583131235911")],
        [fp("88.7494"), fp("520273250104929479199852775.847460806142407818")],
        [fp("95"), fpPowOfTwo(95)],
        [fp("127"), fpPowOfTwo(127)],
        [fp("128").sub(1), fp("340282366920938463220434743172917753977")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp2(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
