import { shouldBehaveLikeAvg } from "./functions/avg.test";
import { shouldBehaveLikeCeil } from "./functions/ceil.test";
import { shouldBehaveLikeDiv } from "./functions/div.test";
import { shouldBehaveLikeExp } from "./functions/exp.test";
import { shouldBehaveLikeExp2 } from "./functions/exp2.test";
import { shouldBehaveLikeFloor } from "./functions/floor.test";
import { shouldBehaveLikeFrac } from "./functions/frac.test";
import { shouldBehaveLikeGm } from "./functions/gm.test";
import { shouldBehaveLikeInv } from "./functions/inv.test";
import { shouldBehaveLikeLn } from "./functions/ln.test";
import { shouldBehaveLikeLog10 } from "./functions/log10.test";
import { shouldBehaveLikeLog2 } from "./functions/log2.test";
import { shouldBehaveLikeMul } from "./functions/mul.test";
import { shouldBehaveLikePow } from "./functions/pow.test";
import { shouldBehaveLikeSqrt } from "./functions/sqrt.test";

describe("PRBMath TypeScript", function () {
  describe("avg", function () {
    shouldBehaveLikeAvg();
  });

  describe("ceil", function () {
    shouldBehaveLikeCeil();
  });

  describe("div", function () {
    shouldBehaveLikeDiv();
  });

  describe("exp", function () {
    shouldBehaveLikeExp();
  });

  describe("exp2", function () {
    shouldBehaveLikeExp2();
  });

  describe("floor", function () {
    shouldBehaveLikeFloor();
  });

  describe("frac", function () {
    shouldBehaveLikeFrac();
  });

  describe("gm", function () {
    shouldBehaveLikeGm();
  });

  describe("inv", function () {
    shouldBehaveLikeInv();
  });

  describe("ln", function () {
    shouldBehaveLikeLn();
  });

  describe("log10", function () {
    shouldBehaveLikeLog10();
  });

  describe("log2", function () {
    shouldBehaveLikeLog2();
  });

  describe("mul", function () {
    shouldBehaveLikeMul();
  });

  describe("pow", function () {
    shouldBehaveLikePow();
  });

  describe("sqrt", function () {
    shouldBehaveLikeSqrt();
  });
});
