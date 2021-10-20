import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { sqrt } from "../../../src/functions";
import { EPSILON } from "../../shared/constants";

export function shouldBehaveLikeSqrt(): void {
  context("when x is zero", function () {
    it("returns 0", function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(sqrt(x));
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      it("throws an error", function () {
        const x: BigNumber = toBn("-1");
        expect(() => sqrt(x)).to.throw("Cannot calculate the square root of a negative number");
      });
    });

    context("when x is positive", function () {
      const testSets = ["1", "2", "2.71", "3", "3.14", "4", "16"];

      forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
        const expected: number = Number(toBn(String(Math.sqrt(Number(x)))));
        const result: number = Number(sqrt(toBn(x)));
        expect(expected).to.be.closeTo(result, EPSILON);
      });
    });
  });
}
