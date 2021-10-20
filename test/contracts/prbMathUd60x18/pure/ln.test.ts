import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../../src/constants";
import { PRBMathUD60x18Errors } from "../../../../src/errors";
import { ln } from "../../../../src/functions";

export function shouldBehaveLikeLn(): void {
  context("when x is less than 1", function () {
    const testSets = [Zero, toBn("0.0625"), toBn("0.1"), toBn("0.5"), toBn("0.8"), toBn("1").sub(1)];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathUd60x18.doLn(x)).to.be.revertedWith(PRBMathUD60x18Errors.LOG_INPUT_TOO_SMALL);
      await expect(this.contracts.prbMathUd60x18Typed.doLn(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.LOG_INPUT_TOO_SMALL,
      );
    });
  });

  context("when x is greater than or equal to 1", function () {
    const testSets = [
      toBn("1"),
      toBn("1.125"),
      toBn("2"),
      E,
      PI,
      toBn("4"),
      toBn("8"),
      toBn("1e18"),
      MAX_WHOLE_UD60x18,
      MAX_UD60x18,
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = ln(x);
      expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doLn(x));
      expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doLn(x));
    });
  });
}
