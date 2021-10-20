import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { inv } from "../../../src/functions";
import { EPSILON } from "../../shared/constants";

export function shouldBehaveLikeInv(): void {
  context("when x is zero", function () {
    it("throws an error", function () {
      const x: BigNumber = Zero;
      expect(() => inv(x)).to.throw("Cannot calculate the inverse of zero");
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      const testSets = ["-2503", "-772.05", "-100.135", "-22", "-4", "-3.14", "-2", "-1", "-0.1", "-0.05"];

      forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
        const expected: number = Number(toBn(String(1 / Number(x))));
        const result: number = Number(inv(toBn(x)));
        expect(expected).to.be.closeTo(result, EPSILON);
      });
    });

    context("when x is positive", function () {
      const testSets = ["0.05", "0.1", "1", "2", "3.14", "4", "22", "100.135", "772.05", "2503"];

      forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
        const expected: number = Number(toBn(String(1 / Number(x))));
        const result: number = Number(inv(toBn(x)));
        expect(expected).to.be.closeTo(result, EPSILON);
      });
    });
  });
}
