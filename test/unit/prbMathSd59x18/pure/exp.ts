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
import { fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("retrieves 1", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(x);
      expect(fp("1")).to.equal(result);
    });
  });

  context("when x is negative", function () {
    context("when x is less than -41.446531673892822322", function () {
      const testSets = [fp("-41.446531673892822323"), MIN_WHOLE_SD59x18, MIN_SD59x18];

      forEach(testSets).it("takes %e and returns zero", async function (x: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(x);
        expect(ZERO).to.equal(result);
      });
    });

    context("when x is greater than or equal to -41.446531673892822322", function () {
      const testSets = [
        [fp("-41.446531673892822322"), fp("0.000000000000000001")],
        [fp("-33.333333"), fp("0.000000000000003338")],
        [fp("-20.82"), fp("0.0000000009077973")],
        [fp("-16"), fp("0.000000112535174719")],
        [fp("-11.89215"), fp("0.000006843919254514")],
        [fp("-4"), fp("0.01831563888873418")],
        [PI.mul(-1), fp("0.043213918263772249")],
        [fp("-3"), fp("0.049787068367863943")],
        [E.mul(-1), fp("0.065988035845312537")],
        [fp("-2"), fp("0.135335283236612692")],
        [fp("-1"), fp("0.367879441171442322")],
        [fp("-0.000000000000001"), fp("0.999999999999999001")],
        [fp("-0.000000000000000001"), fp("1")], // because this is very close to zero
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(x);
        expect(expected).to.equal(result);
      });
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 88.722839111672999628", function () {
      const testSets = [fp("88.722839111672999628"), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doExp(x)).to.be.reverted;
      });
    });

    context("when x is less than 88.722839111672999628", function () {
      const testSets = [
        [fp("0.000000000000000001"), fp("1")], // because this is very close to zero
        [fp("0.000000000000001"), fp("1.000000000000001")],
        [fp("1"), E.sub(1)], // precision errors
        [fp("2"), fp("7.389056098930650223")],
        [E, fp("15.154262241479264173")],
        [fp("3"), fp("20.085536923187667725")],
        [PI, fp("23.140692632779268978")],
        [fp("4"), fp("54.598150033144239022")],
        [fp("11.89215"), fp("146115.107851442195836576")],
        [fp("16"), fp("8886110.520507872601096941")],
        [fp("20.82"), fp("1101567497.354306723400287049")],
        [fp("33.333333"), fp("299559147061116.199283918898757208")],
        [fp("64"), fp("6235149080811616783274026429.479962296900339424")],
        [fp("71.002"), fp("6851360256686184003815949248357.992301166057586669")],
        [fp("88.722839111672999627"), fp("340282366920938463220434743172917753977")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
