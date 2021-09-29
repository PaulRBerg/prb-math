import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "earljs";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { EPSILON } from "../shared/constants";

export function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("returns 1", function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = toBn("1");
      expect(expected).toEqual(this.hre.prb.math.exp(x));
    });
  });

  context("when x is negative", function () {
    const testSets = ["-20.82", "-16", "-11.89215", "-4", "-3.14", "-3", "-2.71", "-2", "-1"];

    forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
      const expected: number = Number(toBn(String(Math.exp(Number(x)))));
      const result: number = Number(this.hre.prb.math.exp(toBn(x)));
      expect(expected).toEqual(expect.numberCloseTo(result, { delta: EPSILON }));
    });
  });

  context("when x is positive", function () {
    const testSets = ["1", "2", "2.71", "3", "3.14", "4", "11.89215", "16", "20.82"];

    forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
      const expected: number = Number(toBn(String(Math.exp(Number(x)))));
      const result: number = Number(this.hre.prb.math.exp(toBn(x)));
      expect(expected).toEqual(expect.numberCloseTo(result, { delta: EPSILON }));
    });
  });
}
