import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE, ZERO } from "../../../../helpers/constants";
import { fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = SCALE;
      const y: BigNumber = ZERO;
      await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.reverted;
    });
  });

  context("when the denominator is not zero", function () {
    context("when the numerator is zero", function () {
      const testSets = [sfp("1e-18"), fp("1"), PI, sfp("1e18")];

      forEach(testSets).it("takes %e and returns zero", async function (y: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathUd60x18.doDiv(ZERO, y);
        expect(ZERO).to.equal(result);
      });
    });

    context("when the numerator is not zero", function () {
      context("when the scaled numerator overflows", function () {
        const testSets = [
          [MAX_UD60x18.div(SCALE).add(1), sfp("1e-18")],
          [MAX_UD60x18.div(SCALE).add(1), sfp("1e-18")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.reverted;
        });
      });

      context("when the scaled numerator does not overflow", function () {
        const testSets = [
          [sfp("1e-18"), MAX_UD60x18, ZERO],
          [sfp("1e-18"), fp("1").add(1), ZERO],
          [sfp("1e-18"), fp("1"), sfp("1e-18")],
          [sfp("1e-5"), sfp("1e-5"), fp("1")],
          [sfp("1e-5"), fp("0.00002"), fp("0.5")],
          [fp("0.05"), fp("0.02"), fp("2.5")],
          [fp("0.1"), fp("0.01"), fp("10")],
          [fp("2"), fp("2"), fp("1")],
          [fp("2"), fp("5"), fp("0.4")],
          [fp("4"), fp("2"), fp("2")],
          [fp("22"), fp("7"), fp("3.142857142857142857")],
          [fp("100.135"), fp("100.134"), fp("1.000009986617931971")],
          [fp("772.05"), fp("199.98"), fp("3.860636063606360636")],
          [fp("2503"), fp("918882.11"), fp("0.002723962054283546")],
          [sfp("1e18"), fp("1"), sfp("1e18")],
          [MAX_UD60x18.div(SCALE), sfp("1e-18"), MAX_WHOLE_UD60x18],
        ];

        forEach(testSets).it(
          "takes %e and %e and returns %e",
          async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
            const result: BigNumber = await this.contracts.prbMathUd60x18.doDiv(x, y);
            expect(expected).to.equal(result);
          },
        );
      });
    });
  });
}
