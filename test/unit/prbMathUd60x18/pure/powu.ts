import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  EPSILON,
  EPSILON_MAGNITUDE,
  MAX_UD60x18,
  MAX_WHOLE_UD60x18,
  PI,
  SQRT_MAX_UD60x18,
} from "../../../../helpers/constants";
import { max } from "../../../../helpers/ethers.math";
import { pow } from "../../../../helpers/math";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    context("when the exponent is zero", function () {
      it("returns 1", async function () {
        const x: BigNumber = bn("0");
        const y: BigNumber = bn("0");
        const result: BigNumber = await this.contracts.prbMathUd60x18.doPowu(x, y);
        expect(fp("1")).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [fp("1"), fp(E), fp(PI)];

      forEach(testSets).it("takes %e and returns 0", async function (y: BigNumber) {
        const x: BigNumber = bn("0");
        const result: BigNumber = await this.contracts.prbMathUd60x18.doPowu(x, y);
        expect(bn("0")).to.equal(result);
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [fp("1"), fp(E), fp(PI), fp(MAX_UD60x18)];
      const expected: BigNumber = fp("1");

      forEach(testSets).it("takes %e and returns 1", async function (x: BigNumber) {
        const y: BigNumber = bn("0");
        const result: BigNumber = await this.contracts.prbMathUd60x18.doPowu(x, y);
        expect(expected).to.equal(result);
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
          await expect(this.contracts.prbMathUd60x18.doPowu(x, y)).to.be.reverted;
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
          ["38685626227668133590.597631999999999999", "3"], // Biggest number whose cube fits within MAX_SD59x18
          [SQRT_MAX_UD60x18, "2"],
          [MAX_WHOLE_UD60x18, "1"],
          [MAX_UD60x18, "1"],
        ];

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const result: BigNumber = await this.contracts.prbMathUd60x18.doPowu(fp(x), bn(y));
          const expected: BigNumber = fp(pow(x, y));
          const delta: BigNumber = expected.sub(result).abs();
          expect(delta).to.be.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE)));
        });
      });
    });
  });
}
