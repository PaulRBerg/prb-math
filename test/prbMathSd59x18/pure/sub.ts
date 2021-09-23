import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MIN_SD59x18, PI } from "../../../helpers/constants";
import { bn } from "../../../helpers/numbers";
import { PanicCodes } from "../../shared/errors";

export default function shouldBehaveLikeSub(): void {
  context("when the difference underflows", function () {
    const testSets = [
      [fp(MIN_SD59x18), fp("1e-18")],
      [fp(MIN_SD59x18).div(2), fp(MAX_SD59x18).div(2).add(2)],
      [bn("-2"), fp(MAX_SD59x18)],
    ];

    forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
      await expect(this.contracts.prbMathSd59x18Typed.doSub(x, y)).to.be.revertedWith(
        PanicCodes.ArithmeticOverflowOrUnderflow,
      );
    });
  });

  context("when the difference does not underflow", function () {
    context("when the difference overflows", function () {
      const testSets = [
        [fp("1e-18"), fp(MIN_SD59x18)],
        [fp(MAX_SD59x18).div(2), fp(MIN_SD59x18).div(2).sub(1)],
        [fp(MAX_SD59x18), fp("-1e-18")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathSd59x18Typed.doSub(x, y)).to.be.revertedWith(
          PanicCodes.ArithmeticOverflowOrUnderflow,
        );
      });
    });

    context("when the difference does not overflow", function () {
      context("when the operands have the same sign", function () {
        const testSets = [
          [fp("-1"), fp("-1")],
          [fp("-" + E), fp("-1.89")],
          [fp("-" + PI), fp("-2.0004")],
          [fp("-42"), fp("-38.12")],
          [fp("-803.899"), fp("-1.02")],
          [fp("-8959"), fp("-5809")],
          [fp("-50255.423"), fp("-28177.04405")],
          [fp("-1.04e15"), fp("-5.3542e14")],
          [fp("-4892e32"), fp("-2042e25")],
          [fp(MIN_SD59x18).add(1), fp("-1e-18")],
        ].concat([
          [Zero, Zero],
          [fp("1"), fp("1")],
          [fp(E), fp("1.89")],
          [fp(PI), fp("2.0004")],
          [fp("42"), fp("38.12")],
          [fp("803.899"), fp("1.02")],
          [fp("8959"), fp("5809")],
          [fp("50255.423"), fp("28177.04405")],
          [fp("1.04e15"), fp("5.3542e14")],
          [fp("4892e32"), fp("2042e25")],
          [fp(MAX_SD59x18).sub(1), fp("1e-18")],
        ]);

        forEach(testSets).it(
          "takes %e and %e and returns the correct value",
          async function (x: BigNumber, y: BigNumber) {
            const result: BigNumber = await this.contracts.prbMathSd59x18Typed.doSub(x, y);
            const expected: BigNumber = x.sub(y);
            expect(expected).to.equal(result);
          },
        );
      });
    });
  });
}
