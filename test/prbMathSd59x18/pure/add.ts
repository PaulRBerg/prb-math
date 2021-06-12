import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MIN_SD59x18, PI } from "../../../helpers/constants";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeAdd(): void {
  context("when the sum overflows", function () {
    const testSets = [
      [bn("1"), MAX_SD59x18],
      [fp(MAX_SD59x18).div(2), fp(MAX_SD59x18).div(2).add(2)],
      [fp(MAX_SD59x18).div(2).add(2), fp(MAX_SD59x18).div(2)],
      [fp(MAX_SD59x18), bn("1")],
    ];

    forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
      await expect(this.contracts.prbMathSd59x18Typed.doAdd(x, y)).to.be.reverted;
    });
  });

  context("when the sum does not overflow", function () {
    context("when the operands don't have the same sign", function () {
      const testSets = [
        [fp(MIN_SD59x18).add(1), bn("1")],
        [fp("-4892e32"), fp("2042e25")],
        [fp("-1.04e15"), fp("5.3542e14")],
        [fp("-50255.423"), fp("28177.04405")],
        [fp("-8959"), fp("5809")],
        [fp("-803.899"), fp("1.02")],
        [fp("-42"), fp("38.12")],
        [fp("-" + PI), fp("2.0004")],
        [fp("-" + E), fp("1.89")],
        [fp("-1"), fp("1")],
      ].concat([
        [fp("1"), fp("-1")],
        [fp(E), fp("-1.89")],
        [fp(PI), fp("-2.0004")],
        [fp("42"), fp("-38.12")],
        [fp("803.899"), fp("-1.02")],
        [fp("8959"), fp("-5809")],
        [fp("50255.423"), fp("-28177.04405")],
        [fp("1.04e15"), fp("-5.3542e14")],
        [fp("4892e32"), fp("-2042e25")],
        [fp(MAX_SD59x18).sub(1), bn("-1")],
      ]);

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18Typed.doAdd(x, y);
        const expected: BigNumber = x.add(y);
        expect(expected).to.equal(result);
      });
    });

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
        [fp(MIN_SD59x18).add(1), bn("-1")],
      ].concat([
        [bn("0"), bn("0")],
        [fp("1"), fp("1")],
        [fp(E), fp("1.89")],
        [fp(PI), fp("2.0004")],
        [fp("42"), fp("38.12")],
        [fp("803.899"), fp("1.02")],
        [fp("8959"), fp("5809")],
        [fp("50255.423"), fp("28177.04405")],
        [fp("1.04e15"), fp("5.3542e14")],
        [fp("4892e32"), fp("2042e25")],
        [fp(MAX_SD59x18).sub(1), bn("1")],
      ]);

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSd59x18Typed.doAdd(x, y);
          const expected: BigNumber = x.add(y);
          expect(expected).to.equal(result);
        },
      );
    });
  });
}
