import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { exp2 } from "../../../src/functions";
import { EPSILON } from "../../shared/constants";

export function shouldBehaveLikeExp2(): void {
  context("when x is zero", function () {
    it("returns 1", function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = toBn("1");
      expect(expected).to.equal(exp2(x));
    });
  });

  context("when x is negative", function () {
    const testSets = ["-20.82", "-16", "-11.89215", "-4", "-3.14", "-3", "-2.71", "-2", "-1"];

    forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
      const expected: number = Number(toBn(String(Math.pow(2, Number(x)))));
      const result: number = Number(exp2(toBn(x)));
      expect(expected).to.be.closeTo(result, EPSILON);
    });
  });

  context("when x is positive", function () {
    const testSets = ["1", "2", "2.71", "3", "3.14", "4", "11.89215", "16", "20.82"];

    forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
      const expected: number = Number(toBn(String(Math.pow(2, Number(x)))));
      const result: number = Number(exp2(toBn(x)));
      expect(expected).to.be.closeTo(result, EPSILON);
    });
  });
}
