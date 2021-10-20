import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { mul } from "../../../src/functions";

export function shouldBehaveLikeMul(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [toBn("0.5"), Zero],
      [Zero, toBn("0.5")],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(mul(x, y));
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the operands have the same sign", function () {
      const testSets = [
        ["-18.3", "-12.04"],
        ["3.14", "-2.71"],
        ["-2.098", "-1.119"],
        ["-1", "-1"],
        ["-0.01", "-0.05"],
        ["-0.001", "-0.01"],
      ].concat([
        ["0.001", "0.01"],
        ["0.01", "0.05"],
        ["1", "1"],
        ["2.098", "1.119"],
        ["3.14", "2.71"],
        ["18.3", "12.04"],
      ]);

      forEach(testSets).it("takes %f and %f and returns the correct value", async function (x: string, y: string) {
        const expected: number = Number(toBn(String(Number(x) * Number(y))));
        const result: number = Number(mul(toBn(x), toBn(y)));
        expect(expected).to.be.closeTo(result, 1e3);
      });
    });

    context("when the operands have the same sign", function () {
      const testSets = [
        ["-18.3", "12.04"],
        ["3.14", "2.71"],
        ["-2.098", "1.119"],
        ["-1", "1"],
        ["-0.01", "0.05"],
        ["-0.001", "0.01"],
      ].concat([
        ["0.001", "-0.01"],
        ["0.01", "-0.05"],
        ["1", "-1"],
        ["2.098", "-1.119"],
        ["3.14", "-2.71"],
        ["18.3", "-12.04"],
      ]);

      forEach(testSets).it("takes %f and %f and returns the correct value", async function (x: string, y: string) {
        const expected: number = Number(toBn(String(Number(x) * Number(y))));
        const result: number = Number(mul(toBn(x), toBn(y)));
        expect(expected).to.be.closeTo(result, 1e3);
      });
    });
  });
}
