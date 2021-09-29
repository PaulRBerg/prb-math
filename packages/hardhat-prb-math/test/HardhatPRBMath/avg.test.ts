import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "earljs";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

export function shouldBehaveLikeAvg(): void {
  context("when both operands are zero", function () {
    it("returns 0", function () {
      const x: BigNumber = Zero;
      const y: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).toEqual(this.hre.prb.math.avg(x, y));
    });
  });

  context("when one operand is zero and the other is not zero", function () {
    const testSets = [
      [toBn("-3"), toBn("0"), toBn("-1.5")],
      [toBn("0"), toBn("-3"), toBn("-1.5")],
      [toBn("0"), toBn("3"), toBn("1.5")],
      [toBn("3"), toBn("0"), toBn("1.5")],
    ];

    forEach(testSets).it("takes %e and %e and returns %e", function (x: BigNumber, y: BigNumber, expected: BigNumber) {
      expect(expected).toEqual(this.hre.prb.math.avg(x, y));
    });
  });

  context("when one operand is negative and the other is positive", function () {
    const testSets = [
      [toBn("-4"), toBn("4"), toBn("0")],
      [toBn("-2"), toBn("8"), toBn("3")],
      [toBn("4"), toBn("-4"), toBn("0")],
      [toBn("8"), toBn("-2"), toBn("3")],
    ];

    forEach(testSets).it("takes %e and %e and returns %e", function (x: BigNumber, y: BigNumber, expected: BigNumber) {
      expect(expected).toEqual(this.hre.prb.math.avg(x, y));
    });
  });

  context("when both operands are negative", function () {
    const testSets = [
      [toBn("-100"), toBn("-200"), toBn("-150")],
      [toBn("-4"), toBn("-8"), toBn("-6")],
      [toBn("-1"), toBn("-2"), toBn("-1.5")],
      [toBn("-1"), toBn("-1"), toBn("-1")],
    ];

    forEach(testSets).it("takes %e and %e and returns %e", function (x: BigNumber, y: BigNumber, expected: BigNumber) {
      expect(expected).toEqual(this.hre.prb.math.avg(x, y));
    });
  });

  context("when both operands are positive", function () {
    context("when both operands are odd", function () {
      const testSets = [
        [toBn("1e-18"), toBn("1e-18"), toBn("1e-18")],
        [toBn("3e-18"), toBn("7e-18"), toBn("5e-18")],
        [toBn("99e-18"), toBn("199e-18"), toBn("149e-18")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          expect(expected).toEqual(this.hre.prb.math.avg(x, y));
        },
      );
    });

    context("when both operands are even", function () {
      const testSets = [
        [toBn("2"), toBn("2"), toBn("2")],
        [toBn("4"), toBn("8"), toBn("6")],
        [toBn("100"), toBn("200"), toBn("150")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          expect(expected).toEqual(this.hre.prb.math.avg(x, y));
        },
      );
    });

    context("when one operand is even and the other is odd", function () {
      const testSets = [
        [toBn("1e-18"), toBn("2e-18"), toBn("1e-18")],
        [toBn("3e-18"), toBn("8e-18"), toBn("5e-18")],
        [toBn("99e-18"), toBn("200e-18"), toBn("149e-18")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          expect(expected).toEqual(this.hre.prb.math.avg(x, y));
        },
      );
    });
  });
}
