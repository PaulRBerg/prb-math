import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LOG10_MAX_UD60x18, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE, ZERO } from "../../../../helpers/constants";
import { fp, fps } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog10(): void {
  context("when x is less than 1", function () {
    const testSets = [
      ZERO,
      fp("0.000000000000000001"),
      fp("0.00000000000000001"),
      fps("1e4"),
      fp("0.1"),
      fp("0.5"),
      SCALE.sub(1),
    ];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMathUd60x18.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is greater than or equal to 1", function () {
    context("when x is a power of ten", function () {
      const testSets = [
        [fp("1"), ZERO],
        [fp("10"), fp("1")],
        [fp("100"), fp("2")],
        [fps("1e18"), fp("18")],
        [fps("1e49"), fp("49")],
        [fps("1e57"), fp("57")],
        [fps("1e58"), fp("58")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathUd60x18.doLog10(x);
        expect(expected).to.equal(result);
      });
    });

    context("when x is not a power of ten", function () {
      const testSets = [
        [fp("1.000000000000010000"), fp("0.000000000000043414")],
        [E, fp("4.342944819032518246")],
        [PI, fp("4.971498726941338506")],
        [fp("4"), fp("6.020599913279623918")],
        [fp("16"), fp("12.041199826559247837")],
        [fp("32"), fp("15.051499783199059796")],
        [fp("42.12"), fp("16.244883625134489086")],
        [fp("1010.892143"), fp("30.047048210719801170")],
        [fp("440934.1881"), fp("56.443737734181779783")],
        [fp("1000000000000000000.000000000001"), fp("180.000000000000000376")],
        [MAX_WHOLE_UD60x18, LOG10_MAX_UD60x18],
        [MAX_UD60x18, LOG10_MAX_UD60x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathUd60x18.doLog10(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
