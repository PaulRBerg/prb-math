import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import forEach from "mocha-each";
import { expect } from "earljs";
import { toBn } from "evm-bn";
import { EPSILON } from "../shared/constants";

export function shouldBehaveLikeSqrt(): void {
  context("when x is zero", function () {
    it("returns 0", function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).toEqual(this.hre.prb.math.sqrt(x));
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      it("throws an error", function () {
        const x: BigNumber = toBn("-1");
        expect(() => this.hre.prb.math.sqrt(x)).toThrow("Cannot calculate the square root of a negative number");
      });
    });

    context("when x is positive", function () {
      const testSets = ["1", "2", "2.71", "3", "3.14", "4", "16"];

      forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
        const expected: number = Number(toBn(String(Math.sqrt(Number(x)))));
        const result: number = Number(this.hre.prb.math.sqrt(toBn(x)));
        expect(expected).toEqual(expect.numberCloseTo(result, { delta: EPSILON }));
      });
    });
  });
}
