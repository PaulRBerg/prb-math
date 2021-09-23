import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../helpers/constants";
import { ln } from "../../../helpers/math";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeLn(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathSd59x18.doLn(x)).to.be.revertedWith(PRBMathSD59x18Errors.LogInputTooSmall);
      await expect(this.contracts.prbMathSd59x18Typed.doLn(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LogInputTooSmall,
      );
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSd59x18.doLn(x)).to.be.revertedWith(PRBMathSD59x18Errors.LogInputTooSmall);
      await expect(this.contracts.prbMathSd59x18Typed.doLn(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LogInputTooSmall,
      );
    });
  });

  context("when x is positive", function () {
    const testSets = [
      ["0.1"],
      ["0.2"],
      ["0.3"],
      ["0.4"],
      ["0.5"],
      ["0.6"],
      ["0.7"],
      ["0.8"],
      ["0.9"],
      ["1"],
      ["1.125"],
      ["2"],
      [E],
      [PI],
      ["4"],
      ["8"],
      ["1e18"],
      [MAX_WHOLE_SD59x18],
      [MAX_SD59x18],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
      const expected: BigNumber = fp(ln(x));
      expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doLn(fp(x)));
      expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doLn(fp(x)));
    });
  });
}
