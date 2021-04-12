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
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("returns zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathSD59x18.doExp(x);
      expect(result).to.equal(fp(1));
    });
  });

  context("when x is negative", function () {
    context("when x is lower than -41446531673892822322", function () {
      const testSets = [bn("-41446531673892822323"), MIN_WHOLE_SD59x18, MIN_SD59x18];

      forEach(testSets).it("takes %e and returns zero", async function (x: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doExp(x);
        expect(ZERO).to.equal(result);
      });
    });

    context("when x is greater than or equal to -41446531673892822322", function () {
      const testSets = [
        [bn("-41446531673892822321"), bn(1)],
        [fp(-33.333333), bn(3338)],
        [fp(-20.82), bn("907797300")],
        [fp(-16), bn("112535174719")],
        [fp(-11.89215), bn("6843919254514")],
        [fp(-4), bn("18315638888734180")],
        [PI.mul(-1), bn("43213918263772249")],
        [fp(-3), bn("49787068367863943")],
        [E.mul(-1), bn("65988035845312537")],
        [fp(-2), bn("135335283236612691")],
        [fp(-1), bn("367879441171442321")],
        [fp(-0.000000000000001), bn("999999999999999000")],
        [fp(-0.000000000000000001), fp(1)], // because this is very close to zero
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doExp(x);
        expect(expected).to.equal(result);
      });
    });
  });

  context("when x is positive", function () {
    context("when x is 88722839111672999628 or greater", function () {
      const testSets = [bn("88722839111672999628"), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSD59x18.doExp(x)).to.be.reverted;
      });
    });

    context("when x is lower than 88722839111672999628", function () {
      const testSets = [
        [fp(0.000000000000000001), fp(1)], // because this is very close to zero
        [fp(0.000000000000001), bn("1000000000000001000")],
        [fp(1), E.sub(1)], // precision errors
        [fp(2), bn("7389056098930650223")],
        [E, bn("15154262241479264173")],
        [fp(3), bn("20085536923187667725")],
        [PI, bn("23140692632779268978")],
        [fp(4), bn("54598150033144239022")],
        [fp(11.89215), bn("146115107851442195836576")],
        [fp(16), bn("8886110520507872601096941")],
        [fp(20.82), bn("1101567497354306723400287049")],
        [fp(33.333333), bn("299559147061116199283918898757208")],
        [fp(64), bn("6235149080811616783274026429479962296900339424")],
        [fp(71.002), bn("6851360256686184003815949248357992301166057586669")],
        [bn("88722839111672999627"), bn("340282366920938463220434743172917753977000000000000000000")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doExp(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
