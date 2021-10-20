import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { log10 } from "../../../src/functions";
import { EPSILON } from "../../shared/constants";

export function shouldBehaveLikeLog10(): void {
  context("when x is zero", function () {
    it("throws an error", function () {
      const x: BigNumber = Zero;
      expect(() => log10(x)).to.throw("Cannot calculate the common logarithm of zero");
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      it("throws an error", function () {
        const x: BigNumber = toBn("-1");
        expect(() => log10(x)).to.throw("Cannot calculate the common logarithm of a negative number");
      });

      context("when x is positive", function () {
        const testSets = [
          "0.1",
          "0.2",
          "0.3",
          "0.4",
          "0.5",
          "0.6",
          "0.7",
          "0.8",
          "0.9",
          "1",
          "1.125",
          "2",
          "2.71",
          "3.14",
          "4",
          "8",
        ];

        forEach(testSets).it("takes %f and returns the correct value", function (x: string) {
          const expected: number = Number(toBn(String(Math.log10(Number(x)))));
          const result: number = Number(log10(toBn(x)));
          expect(expected).to.be.closeTo(result, EPSILON);
        });
      });
    });
  });
}
