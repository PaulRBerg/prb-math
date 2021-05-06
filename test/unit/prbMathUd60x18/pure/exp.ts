import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, ZERO } from "../../../../helpers/constants";
import { fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("retrieves 1", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathUd60x18.doExp(x);
      expect(fp("1")).to.equal(result);
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 88.722839111672999628", function () {
      const testSets = [fp("88.722839111672999628"), MAX_WHOLE_UD60x18, MAX_UD60x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doExp(x)).to.be.reverted;
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
        const result: BigNumber = await this.contracts.prbMathUd60x18.doExp(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
