import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18_DIV_BY_SCALE } from "../../../helpers/constants";
import { gm } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeGm(): void {
  context("when the product of x and y is zero", function () {
    const testSets = [
      [bn("0"), fp(PI)],
      [fp(PI), bn("0")],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doGm(x, y);
      expect(bn("0")).to.equal(result);
    });
  });

  context("when the product of x and y is not zero", function () {
    context("when the product of x and y overflows", function () {
      const testSets = [
        [fp(SQRT_MAX_UD60x18_DIV_BY_SCALE).add(1), fp(SQRT_MAX_UD60x18_DIV_BY_SCALE).add(1)],
        [fp(MAX_WHOLE_UD60x18), fp("3e-18")],
        [fp(MAX_UD60x18), fp("2e-18")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doGm(x, y)).to.be.reverted;
      });
    });

    context("when the product of x and y does not overflow", function () {
      const testSets = [
        ["1", "1"],
        ["1", "4"],
        ["2", "8"],
        [E, "89.01"],
        [PI, "8.2"],
        ["322.47", "674.77"],
        ["2404.8", "7899.210662"],
        [SQRT_MAX_UD60x18_DIV_BY_SCALE, SQRT_MAX_UD60x18_DIV_BY_SCALE],
        [MAX_WHOLE_UD60x18, "1e-18"],
        [MAX_UD60x18, "1e-18"],
      ];

      forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
        const result = await this.contracts.prbMathUd60x18.doGm(fp(x), fp(y));
        const expected: BigNumber = fp(gm(x, y));
        expect(expected).to.equal(result);
      });
    });
  });
}
