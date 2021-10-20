import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18 } from "../../../../src/constants";
import { avg } from "../../../../src/functions";

export function shouldBehaveLikeAvg(): void {
  context("when both operands are zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = Zero;
      const y: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doAvg(x, y));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doAvg(x, y));
    });
  });

  context("when one operand is zero and the other is not zero", function () {
    const testSets = [
      [Zero, toBn("3")],
      [toBn("3"), Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = avg(x, y);
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doAvg(x, y));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doAvg(x, y));
    });
  });

  context("when both operands are positive", function () {
    context("when both operands are even", function () {
      const testSets = [
        [toBn("2e-18"), toBn("4e-18")],
        [toBn("2"), toBn("2")],
        [toBn("4"), toBn("8")],
        [toBn("100"), toBn("200")],
        [toBn("1e18"), toBn("1e19")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = avg(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doAvg(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doAvg(x, y));
        },
      );
    });

    context("when both operands are odd", function () {
      const testSets = [
        [toBn("1e-18"), toBn("3e-18")],
        [toBn("1").add(1), toBn("1").add(1)],
        [toBn("3").add(1), toBn("7").add(1)],
        [toBn("99").add(1), toBn("199").add(1)],
        [toBn("1e18").add(1), toBn("1e19").add(1)],
        [MAX_UD60x18, MAX_UD60x18],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = avg(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doAvg(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doAvg(x, y));
        },
      );
    });

    context("when one operand is even and the other is odd", function () {
      const testSets = [
        [toBn("1e-18"), toBn("2e-18")],
        [toBn("1").add(1), toBn("2")],
        [toBn("3").add(1), toBn("8")],
        [toBn("99").add(1), toBn("200")],
        [toBn("1e18").add(1), toBn("10000000000000000001")],
        [MAX_UD60x18, MAX_WHOLE_UD60x18],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = avg(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doAvg(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doAvg(x, y));
        },
      );
    });
  });
}
