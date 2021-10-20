import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../../src/constants";
import { PRBMathUD60x18Errors } from "../../../../src/errors";
import { sqrt } from "../../../../src/functions";

export function shouldBehaveLikeSqrt(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doSqrt(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doSqrt(x));
    });
  });

  context("when x is not zero", function () {
    context(
      "when x is greater than or equal to 115792089237316195423570985008687907853269.984665640564039458",
      function () {
        const testSets = [
          toBn("115792089237316195423570985008687907853269.984665640564039458"),
          MAX_WHOLE_UD60x18,
          MAX_UD60x18,
        ];

        forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doSqrt(x)).to.be.revertedWith(PRBMathUD60x18Errors.SQRT_OVERFLOW);
          await expect(this.contracts.prbMathUd60x18Typed.doSqrt(x)).to.be.revertedWith(
            PRBMathUD60x18Errors.SQRT_OVERFLOW,
          );
        });
      },
    );

    context("when x is less than 115792089237316195423570985008687907853269.984665640564039458", function () {
      const testSets = [
        toBn("1e-18"),
        toBn("1e-15"),
        toBn("1"),
        toBn("2"),
        E,
        toBn("3"),
        PI,
        toBn("4"),
        toBn("16"),
        toBn("1e17"),
        toBn("1e18"),
        toBn("12489131238983290393813.123784889921092801"),
        toBn("1889920002192904839344128288891377.732371920009212883"),
        toBn("1e40"),
        toBn("5e40"),
        toBn("115792089237316195423570985008687907853269.984665640564039457"),
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = sqrt(x);
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doSqrt(x));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doSqrt(x));
      });
    });
  });
}
