import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18 } from "../../../helpers/constants";
import { pow } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";
import { PRBMathErrors } from "../../shared/errors";

export default function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    context("when the exponent is zero", function () {
      it("returns 1", async function () {
        const x: BigNumber = Zero;
        const y: BigNumber = Zero;
        const expected: BigNumber = fp("1");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [[fp("1")], [fp(E)], [fp(PI)]];

      forEach(testSets).it("takes %e and returns 0", async function (y: BigNumber) {
        const x: BigNumber = Zero;
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [[fp("1")], [fp(E)], [fp(PI)], [fp(MAX_UD60x18)]];

      forEach(testSets).it("takes %e and returns 1", async function (x: BigNumber) {
        const y: BigNumber = Zero;
        const expected: BigNumber = fp("1");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows ud60x18", function () {
        const testSets = [
          [fp("48740834812604276470.692694885616578542"), bn("3")], // smallest number whose cube doesn't fit within MAX_UD60x18
          [fp(SQRT_MAX_UD60x18).add(1), bn("2")],
          [fp(MAX_WHOLE_UD60x18), bn("2")],
          [fp(MAX_UD60x18), bn("2")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doPowu(x, y)).to.be.revertedWith(
            PRBMathErrors.MulDivFixedPointOverflow,
          );
          await expect(this.contracts.prbMathUd60x18Typed.doPowu(x, y)).to.be.revertedWith(
            PRBMathErrors.MulDivFixedPointOverflow,
          );
        });
      });

      context("when the result does not overflow ud60x18", function () {
        const testSets = [
          ["0.001", "3"],
          ["0.1", "2"],
          ["1", "1"],
          ["2", "5"],
          ["2", "100"],
          [E, "2"],
          ["100", "4"],
          [PI, "3"],
          ["5.491", "19"],
          ["478.77", "20"],
          ["6452.166", "7"],
          ["1e18", "2"],
          ["48740834812604276470.692694885616578541", "3"], // Biggest number whose cube fits within MAX_UD60x18
          [SQRT_MAX_UD60x18, "2"],
          [MAX_WHOLE_UD60x18, "1"],
          [MAX_UD60x18, "1"],
        ];

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const expected: BigNumber = fp(pow(x, y));
          expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doPowu(fp(x), bn(y)));
          expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doPowu(fp(x), bn(y)));
        });
      });
    });
  });
}
