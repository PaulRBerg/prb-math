import { shouldBehaveLikeAvg } from "./HardhatPRBMath/avg.test";
import { shouldBehaveLikeCeil } from "./HardhatPRBMath/ceil.test";
import { shouldBehaveLikeDiv } from "./HardhatPRBMath/div.test";
import { shouldBehaveLikeExp } from "./HardhatPRBMath/exp.test";
import { shouldBehaveLikeExp2 } from "./HardhatPRBMath/exp2.test";
import { shouldBehaveLikeFloor } from "./HardhatPRBMath/floor.test";
import { shouldBehaveLikeFrac } from "./HardhatPRBMath/frac.test";
import { shouldBehaveLikeInv } from "./HardhatPRBMath/inv.test";
import { shouldBehaveLikeLn } from "./HardhatPRBMath/ln.test";
import { shouldBehaveLikeLog10 } from "./HardhatPRBMath/log10.test";
import { shouldBehaveLikeLog2 } from "./HardhatPRBMath/log2.test";
import { shouldBehaveLikeMul } from "./HardhatPRBMath/mul.test";
import { shouldBehaveLikePow } from "./HardhatPRBMath/pow.test";
import { shouldBehaveLikeSqrt } from "./HardhatPRBMath/sqrt.test";
import { shouldBehaveLikeGm } from "./HardhatPRBMath/gm.test";
import { useHardhatEnvironment } from "./shared/env";

describe("Hardhat PRBMath", function () {
  useHardhatEnvironment();

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
