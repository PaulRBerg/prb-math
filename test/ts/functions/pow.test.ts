import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { pow } from "../../../src/functions";
import { EPSILON } from "../../shared/constants";

export function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    const x: BigNumber = Zero;

    context("when the exponent is zero", function () {
      const y: BigNumber = Zero;

      it("returns 1", function () {
        const expected: BigNumber = toBn("1");
        expect(expected).to.equal(pow(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [toBn("1"), toBn("2.71"), toBn("3.14")];

      forEach(testSets).it("takes 0 and %e and returns 0", function (y: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(pow(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the base is negative", function () {
      const testSets = [toBn("-3.14"), toBn("-2.71"), toBn("-1")];
      const y: BigNumber = toBn("1");

      forEach(testSets).it("takes %e and 1 and throws an error", function (x: BigNumber) {
        expect(() => pow(x, y)).to.throw("PRBMath cannot raise a negative base to a power");
      });
    });

    context("when the base is positive", function () {
      context("when the exponent is zero", function () {
        const testSets = [toBn("1"), toBn("2.71"), toBn("3.14")];
        const y: BigNumber = Zero;

        forEach(testSets).it("takes %e and 0 and returns 1", function (x: BigNumber) {
          const expected: BigNumber = toBn("1");
          expect(expected).to.equal(pow(x, y));
        });
      });

      context("when the exponent is not zero", function () {
        const testSets = [
          ["0.1", "-0.8"],
          ["0.24", "-11"],
          ["0.5", "-0.7373"],
          ["0.799291", "-69"],
          ["1", "-1"],
          ["1", "-3.14"],
          ["2", "-1.5"],
          ["2.71", "-2.71"],
          ["2.71", "-1.66976"],
          ["3.14", "-3.14"],
          ["11", "-28.5"],
        ].concat([
          ["0.1", "0.8"],
          ["0.24", "11"],
          ["0.5", "0.7373"],
          ["0.799291", "69"],
          ["1", "1"],
          ["1", "3.14"],
          ["2", "1.5"],
          ["2.71", "2.71"],
          ["2.71", "1.66976"],
          ["3.14", "3.14"],
          ["11", "28.5"],
        ]);

        forEach(testSets).it("takes %f and %f and returns the correct value", function (x: string, y: string) {
          const expected: number = Number(toBn(String(Math.pow(Number(x), Number(y)))));
          const result: number = Number(pow(toBn(x), toBn(y)));
          expect(expected).to.be.closeTo(result, EPSILON);
        });
      });
    });
  });
}
