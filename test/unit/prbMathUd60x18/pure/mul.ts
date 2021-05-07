import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  HALF_SCALE,
  MAX_UD60x18,
  MAX_WHOLE_UD60x18,
  PI,
  SCALE,
  SQRT_MAX_UD60x18,
  ZERO,
} from "../../../../helpers/constants";
import { fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeMul(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [ZERO, fp("0.5")],
      [fp("0.5"), ZERO],
      [MAX_UD60x18, ZERO],
    ];

    forEach(testSets).it("takes %e and %e and returns zero", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doMul(x, y);
      expect(ZERO).to.equal(result);
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the double scaled product overflows", function () {
      const testSets = [
        [SQRT_MAX_UD60x18.add(1), SQRT_MAX_UD60x18.add(1)],
        [MAX_WHOLE_UD60x18, MAX_WHOLE_UD60x18],
        [MAX_UD60x18, MAX_UD60x18],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doMul(x, y)).to.be.reverted;
      });
    });

    context("when the double scaled product does not overflow", function () {
      const testSets = [
        [sfp("1e-18"), sfp("1e-18"), ZERO],
        [sfp("6e-18"), fp("0.1"), sfp("1e-18")],
        [sfp("1e-9"), sfp("1e-9"), sfp("1e-18")],
        [sfp("1e-5"), sfp("1e-5"), sfp("1e-10")],
        [fp("0.001"), fp("0.01"), sfp("1e-5")],
        [fp("0.01"), fp("0.05"), fp("0.0005")],
        [fp("1"), fp("1"), fp("1")],
        [fp("2.098"), fp("1.119"), fp("2.347662")],
        [PI, E, fp("8.539734222673567063")],
        [fp("18.3"), fp("12.04"), fp("220.332")],
        [fp("314.271"), fp("188.19"), fp("59142.65949")],
        [fp("9817"), fp("2348"), fp("23050316")],
        [fp("12983.989"), fp("782.99"), fp("10166333.54711")],
        [sfp("1e18"), sfp("1e6"), sfp("1e24")],
        // Precision errors makes the result not equal to MAX_UD60x18
        [SQRT_MAX_UD60x18, SQRT_MAX_UD60x18, MAX_UD60x18.sub(fp("680564733841.876926926749214863"))],
        [MAX_WHOLE_UD60x18, sfp("1e-18"), MAX_WHOLE_UD60x18.div(SCALE)],
        [MAX_WHOLE_UD60x18, fp("0.01"), MAX_WHOLE_UD60x18.div(100)],
        [MAX_WHOLE_UD60x18, fp("0.5"), MAX_WHOLE_UD60x18.div(2)],
        [MAX_UD60x18.sub(HALF_SCALE), sfp("1e-18"), MAX_UD60x18.div(SCALE)],
        [MAX_UD60x18, fp("0.01"), MAX_UD60x18.div(100)],
        [MAX_UD60x18, fp("0.5"), MAX_UD60x18.div(2).add(1)],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathUd60x18.doMul(x, y);
          expect(expected).to.equal(result);
        },
      );
    });
  });
}
