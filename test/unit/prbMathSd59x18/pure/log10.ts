import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LOG10_MAX_SD59x18, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, ZERO } from "../../../../helpers/constants";
import { fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog10(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMathSd59x18.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSd59x18.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context("when x is a power of ten", function () {
      const testSets = [
        [sfp("1e-18"), fp("-18")],
        [sfp("1e-17"), fp("-17")],
        [sfp("1e-14"), fp("-14")],
        [sfp("1e-10"), fp("-10")],
        [sfp("1e-8"), fp("-8")],
        [sfp("1e-7"), fp("-7")],
        [fp("0.001"), fp("-3")],
        [fp("0.1"), fp("-1")],
        [fp("1"), ZERO],
        [fp("10"), fp("1")],
        [fp("100"), fp("2")],
        [sfp("1e18"), fp("18")],
        [sfp("1e49"), fp("49")],
        [sfp("1e57"), fp("57")],
        [sfp("1e58"), fp("58")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog10(x);
        expect(expected).to.equal(result);
      });
    });

    context("when x is not a power of ten", function () {
      const testSets = [
        [fp("0.000000000007892191"), fp("-111.028024128721664814")],
        [fp("0.0091"), fp("-20.409586076789064014")],
        [fp("0.083"), fp("-10.809219076239260956")],
        [fp("0.1982"), fp("-7.028963498507434743")],
        [fp("0.313"), fp("-5.044556624535515126")],
        [fp("0.4666"), fp("-3.310552655422661758")],
        [fp("1.000000000000010000"), sfp("4.3414e-14")],
        [E, fp("4.342944819032518246")],
        [PI, fp("4.971498726941338506")],
        [fp("4"), fp("6.020599913279623918")],
        [fp("16"), fp("12.041199826559247837")],
        [fp("32"), fp("15.051499783199059796")],
        [fp("42.12"), fp("16.244883625134489086")],
        [fp("1010.892143"), fp("30.047048210719801170")],
        [fp("440934.1881"), fp("56.443737734181779783")],
        [fp("1000000000000000000.000000000001"), fp("180.000000000000000376")],
        [MAX_WHOLE_SD59x18, LOG10_MAX_SD59x18],
        [MAX_SD59x18, LOG10_MAX_SD59x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog10(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
