import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, SQRT_MAX_SD59x18 } from "../../../helpers/constants";
import { pow } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";
import { PRBMathErrors, PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikePowu(): void {
  context("when the base is zero", function () {
    const x: BigNumber = Zero;

    context("when the exponent is zero", function () {
      it("returns 1", async function () {
        const y: BigNumber = Zero;
        const expected: BigNumber = fp("1");
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [[fp("1")], [fp(E)], [fp(PI)]];

      forEach(testSets).it("takes %e and returns 0", async function (y: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPowu(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [[fp("1")], [fp(E)], [fp(PI)], [fp(MAX_SD59x18)]];

      forEach(testSets).it("takes %e and returns 1", async function (x: BigNumber) {
        const y: BigNumber = Zero;
        const expected: BigNumber = fp("1");
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows uint256", function () {
        const testSets = [
          [fp(MAX_WHOLE_SD59x18), bn("2")],
          [fp(MAX_SD59x18), bn("2")],
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
            [fp("38685626227668133590.597632"), bn("3")], // smallest number whose cube doesn't fit within MAX_SD59x18
            [fp(SQRT_MAX_SD59x18).add(1), bn("2")],
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
            const expected: BigNumber = fp(pow(x, y));
            expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doPowu(fp(x), bn(y)));
            expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doPowu(fp(x), bn(y)));
          });
        });
      });
    });
  });
}
