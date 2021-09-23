import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../helpers/constants";
import { exp2 } from "../../../helpers/math";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeExp2(): void {
  context("when x is zero", function () {
    it("returns 1", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = fp("1");
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doExp2(x));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doExp2(x));
    });
  });

  context("when x is negative", function () {
    context("when x is less than -59.794705707972522261", function () {
      const testSets = [fp("-59.794705707972522262"), fp(MIN_WHOLE_SD59x18), fp(MIN_SD59x18)];

      forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doExp2(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doExp2(x));
      });
    });

    context("when x is greater than or equal to -59.794705707972522261", function () {
      const testSets = [
        ["-59.794705707972522261"],
        ["-33.333333"],
        ["-20.82"],
        ["-16"],
        ["-11.89215"],
        ["-4"],
        ["-" + PI],
        ["-3"],
        ["-" + E],
        ["-2"],
        ["-1"],
        ["-1e-15"],
        ["-1e-18"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(exp2(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doExp2(fp(x)));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doExp2(fp(x)));
      });
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 192", function () {
      const testSets = [fp("192"), fp(MAX_WHOLE_SD59x18), fp(MAX_SD59x18)];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doExp2(x)).to.be.revertedWith(PRBMathSD59x18Errors.Exp2InputTooBig);
        await expect(this.contracts.prbMathSd59x18Typed.doExp2(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.Exp2InputTooBig,
        );
      });
    });

    context("when x is less than 192", function () {
      const testSets = [
        ["1e-18"],
        ["1e-15"],
        ["0.3212"],
        ["1"],
        ["2"],
        [E],
        ["3"],
        [PI],
        ["4"],
        ["11.89215"],
        ["16"],
        ["20.82"],
        ["33.333333"],
        ["64"],
        ["71.002"],
        ["88.7494"],
        ["95"],
        ["127"],
        ["152.9065"],
        ["191.999999999999999999"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(exp2(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doExp2(fp(x)));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doExp2(fp(x)));
      });
    });
  });
}
