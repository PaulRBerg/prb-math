import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, MAX_59x18, MAX_WHOLE_59x18, PI, ZERO } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("returns zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMath.doExp(x);
      expect(result).to.equal(fp(1));
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp(-1);
      await expect(this.contracts.prbMath.doExp(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context("when x is 88722839111672999628 or higher", function () {
      const testSets = [bn("88722839111672999628"), MAX_WHOLE_59x18, MAX_59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMath.doExp(x)).to.be.reverted;
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
        const result: BigNumber = await this.contracts.prbMath.doExp(x);
        expect(result).to.equal(expected);
      });
    });
  });
}
