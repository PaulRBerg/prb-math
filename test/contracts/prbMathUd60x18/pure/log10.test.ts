import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE } from "../../../../src/constants";
import { PRBMathUD60x18Errors } from "../../../../src/errors";
import { log10 } from "../../../../src/functions";

export function shouldBehaveLikeLog10(): void {
  context("when x is less than 1", function () {
    const testSets = [Zero, toBn("1e-18"), toBn("1e-17"), toBn("1e4"), toBn("0.1"), toBn("0.5"), SCALE.sub(1)];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathUd60x18.doLog10(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.LOG_INPUT_TOO_SMALL,
      );
      await expect(this.contracts.prbMathUd60x18Typed.doLog10(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.LOG_INPUT_TOO_SMALL,
      );
    });
  });

  context("when x is greater than or equal to 1", function () {
    context("when x is a power of ten", function () {
      const testSets = [toBn("1"), toBn("10"), toBn("100"), toBn("1e18"), toBn("1e49"), toBn("1e57"), toBn("1e58")];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = log10(x);
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doLog10(x));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doLog10(x));
      });
    });

    context("when x is not a power of ten", function () {
      const testSets = [
        toBn("1.000000000000010000"),
        E,
        PI,
        toBn("4"),
        toBn("16"),
        toBn("32"),
        toBn("42.12"),
        toBn("1010.892143"),
        toBn("440934.1881"),
        toBn("1000000000000000000.000000000001"),
        MAX_WHOLE_UD60x18,
        MAX_UD60x18,
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = log10(x);
        expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doLog10(x));
        expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doLog10(x));
      });
    });
  });
}
