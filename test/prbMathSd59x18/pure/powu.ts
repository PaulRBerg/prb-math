import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, SQRT_MAX_SD59x18 } from "../../../helpers/constants";
import { pow } from "../../../helpers/math";
import { PRBMathErrors, PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikePowu(): void {
  context("when the base is zero", function () {
    const x: BigNumber = Zero;

    context("when the exponent is zero", function () {
      const y: BigNumber = Zero;

      it("returns 1", async function () {
        const expected: BigNumber = toBn("1");
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [[toBn("1")], [toBn(E)], [toBn(PI)]];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPowu(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [[toBn("1")], [toBn(E)], [toBn(PI)], [toBn(MAX_SD59x18)]];
      const y: BigNumber = Zero;

      forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
        const expected: BigNumber = toBn("1");
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows uint256", function () {
        const testSets = [
          [toBn(MAX_WHOLE_SD59x18), toBn("2e-18")],
          [toBn(MAX_SD59x18), toBn("2e-18")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathSd59x18.doPowu(x, y)).to.be.revertedWith(
            PRBMathErrors.MulDivFixedPointOverflow,
          );
          await expect(this.contracts.prbMathSd59x18Typed.doPowu(x, y)).to.be.revertedWith(
            PRBMathErrors.MulDivFixedPointOverflow,
          );
        });
      });

      context("when the result does not overflow uint256", function () {
        context("when the result overflows sd59x18", function () {
          const testSets = [
            [toBn("38685626227668133590.597632"), toBn("3e-18")], // smallest number whose cube doesn't fit within MAX_SD59x18
            [toBn(SQRT_MAX_SD59x18).add(1), toBn("2e-18")],
          ];

          forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
            await expect(this.contracts.prbMathSd59x18.doPowu(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.PowuOverflow,
            );
            await expect(this.contracts.prbMathSd59x18Typed.doPowu(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.PowuOverflow,
            );
          });
        });

        context("when the result does not overflow sd59x18", function () {
          const testSets = [
            ["0.001", "3"],
            ["0.1", "2"],
            ["1", "1"],
            ["2", "5"],
            ["2", "100"],
            [E, "2"],
            ["1e2", "4"],
            [PI, "3"],
            ["5.491", "19"],
            ["478.77", "20"],
            ["6452.166", "7"],
            ["1e18", "2"],
            ["38685626227668133590.597631999999999999", "3"], // Biggest number whose cube fits within MAX_SD59x18
            [SQRT_MAX_SD59x18, "2"],
            [MAX_WHOLE_SD59x18, "1"],
            [MAX_SD59x18, "1"],
          ];

          forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
            const expected: BigNumber = toBn(pow(x, y));
            expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doPowu(toBn(x), BigNumber.from(y)));
            expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doPowu(toBn(x), BigNumber.from(y)));
          });
        });
      });
    });
  });
}
