import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { ceil } from "../../../src/functions";

export function shouldBehaveLikeCeil(): void {
  context("when x is zero", function () {
    it("returns 0", function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(ceil(x));
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      const testSets = [
        [toBn("-4.2"), toBn("-4")],
        [toBn("-3.14"), toBn("-3")],
        [toBn("-2"), toBn("-2")],
        [toBn("-1.125"), toBn("-1")],
        [toBn("-1"), toBn("-1")],
        [toBn("-0.5"), Zero],
        [toBn("-0.1"), Zero],
      ];

      forEach(testSets).it("takes %e and returns %e", function (x: BigNumber, expected: BigNumber) {
        expect(expected).to.equal(ceil(x));
      });
    });

    context("when x is positive", function () {
      const testSets = [
        [toBn("0.1"), toBn("1")],
        [toBn("0.5"), toBn("1")],
        [toBn("1"), toBn("1")],
        [toBn("1.125"), toBn("2")],
        [toBn("2"), toBn("2")],
        [toBn("3.14"), toBn("4")],
        [toBn("4.2"), toBn("5")],
      ];

      forEach(testSets).it("takes %e and returns the correct value", function (x: BigNumber, expected: BigNumber) {
        expect(expected).to.equal(ceil(x));
      });
    });
  });
}
