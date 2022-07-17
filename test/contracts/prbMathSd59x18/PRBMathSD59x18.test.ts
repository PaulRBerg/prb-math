import { unitFixturePRBMathSd59x18 } from "../../shared/fixtures";
import { shouldBehaveLikeAbs } from "./pure/abs.test";
import { shouldBehaveLikeAvg } from "./pure/avg.test";
import { shouldBehaveLikeCeil } from "./pure/ceil.test";
import { shouldBehaveLikeDiv } from "./pure/div.test";
import { shouldBehaveLikeExp2 } from "./pure/exp2.test";
import { shouldBehaveLikeExp } from "./pure/exp.test";
import { shouldBehaveLikeFloor } from "./pure/floor.test";
import { shouldBehaveLikeFrac } from "./pure/frac.test";
import { shouldBehaveLikeFromSD59x18 } from "./pure/fromSD59x18.test";
import { shouldBehaveLikeGm } from "./pure/gm.test";
import { shouldBehaveLikeInv } from "./pure/inv.test";
import { shouldBehaveLikeLn } from "./pure/ln.test";
import { shouldBehaveLikeLog2 } from "./pure/log2.test";
import { shouldBehaveLikeLog10 } from "./pure/log10.test";
import { shouldBehaveLikeMul } from "./pure/mul.test";
import { shouldBehaveLikePow } from "./pure/pow.test";
import { shouldBehaveLikePowu } from "./pure/powu.test";
import { shouldBehaveLikeSqrt } from "./pure/sqrt.test";
import { shouldBehaveLikeToSD59x18 } from "./pure/toSD59x18.test";

export function unitTestPrbMathSd59x18(): void {
  describe("PRBMathSD59x18", function () {
    beforeEach(async function () {
      const { prbMathSd59x18 } = await this.loadFixture(unitFixturePRBMathSd59x18);
      this.contracts.prbMathSd59x18 = prbMathSd59x18;
    });

    describe("abs", function () {
      shouldBehaveLikeAbs();
    });

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

    describe("powu", function () {
      shouldBehaveLikePowu();
    });

    describe("sqrt", function () {
      shouldBehaveLikeSqrt();
    });

    describe("fromSD59x18", function () {
      shouldBehaveLikeFromSD59x18();
    });

    describe("toSD59x18", function () {
      shouldBehaveLikeToSD59x18();
    });
  });
}
