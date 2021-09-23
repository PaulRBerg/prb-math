import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../helpers/constants";
import { log2 } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeLog2(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathSd59x18.doLog2(x)).to.be.revertedWith(PRBMathSD59x18Errors.LogInputTooSmall);
      await expect(this.contracts.prbMathSd59x18Typed.doLog2(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LogInputTooSmall,
      );
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSd59x18.doLog2(x)).to.be.revertedWith(PRBMathSD59x18Errors.LogInputTooSmall);
      await expect(this.contracts.prbMathSd59x18Typed.doLog2(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LogInputTooSmall,
      );
    });
  });

  context("when x is positive", function () {
    context("when x is a power of two", function () {
      const testSets = [["0.0625"], ["0.125"], ["0.25"], ["0.5"], ["1"], ["2"], ["4"], ["8"], ["16"], ["195"]];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(log2(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doLog2(fp(x)));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doLog2(fp(x)));
      });
    });

    context("when x is not a power of two", function () {
      const testSets = [
        ["0.0091"],
        ["0.083"],
        ["0.1"],
        ["0.2"],
        ["0.3"],
        ["0.4"],
        ["0.6"],
        ["0.7"],
        ["0.8"],
        ["0.9"],
        ["1.125"],
        [E],
        [PI],
        ["1e18"],
        [MAX_WHOLE_SD59x18],
        [MAX_SD59x18],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(log2(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doLog2(fp(x)));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doLog2(fp(x)));
      });
    });
  });
}
