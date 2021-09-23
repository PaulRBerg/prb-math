import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { sqrt } from "../../../helpers/math";
import { PRBMathUD60x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeSqrt(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doSqrt(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doSqrt(x));
    });
  });

  context("when x is positive", function () {
    context(
      "when x is greater than or equal to 115792089237316195423570985008687907853269.984665640564039458",
      function () {
        const testSets = [
          fp("115792089237316195423570985008687907853269.984665640564039458"),
          fp(MAX_WHOLE_UD60x18),
          fp(MAX_UD60x18),
        ];

        forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doSqrt(x)).to.be.revertedWith(PRBMathUD60x18Errors.SqrtOverflow);
          await expect(this.contracts.prbMathUd60x18Typed.doSqrt(x)).to.be.revertedWith(
            PRBMathUD60x18Errors.SqrtOverflow,
          );
        });
      },
    );

    context("when x is less than 115792089237316195423570985008687907853269.984665640564039458", function () {
      const testSets = [
        ["1e-18"],
        ["1e-15"],
        ["1"],
        ["2"],
        [E],
        ["3"],
        [PI],
        ["4"],
        ["16"],
        ["1e17"],
        ["1e18"],
        ["12489131238983290393813.123784889921092801"],
        ["1889920002192904839344128288891377.732371920009212883"],
        ["1e40"],
        ["5e40"],
        ["115792089237316195423570985008687907853269.984665640564039457"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(sqrt(x));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doSqrt(fp(x)));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doSqrt(fp(x)));
      });
    });
  });
}
