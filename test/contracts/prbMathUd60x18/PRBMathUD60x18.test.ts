import { unitFixturePRBMathUd60x18 } from "../../shared/fixtures";
import { shouldBehaveLikeAvg } from "./pure/avg.test";
import { shouldBehaveLikeCeil } from "./pure/ceil.test";
import { shouldBehaveLikeDiv } from "./pure/div.test";
import { shouldBehaveLikeEGetter } from "./pure/e.test";
import { shouldBehaveLikeExp2 } from "./pure/exp2.test";
import { shouldBehaveLikeExp } from "./pure/exp.test";
import { shouldBehaveLikeFloor } from "./pure/floor.test";
import { shouldBehaveLikeFrac } from "./pure/frac.test";
import { shouldBehaveLikeFromUD60x18 } from "./pure/fromUD60x18.test";
import { shouldBehaveLikeGm } from "./pure/gm.test";
import { shouldBehaveLikeInv } from "./pure/inv.test";
import { shouldBehaveLikeLn } from "./pure/ln.test";
import { shouldBehaveLikeLog2 } from "./pure/log2.test";
import { shouldBehaveLikeLog10 } from "./pure/log10.test";
import { shouldBehaveLikeMul } from "./pure/mul.test";
import { shouldBehaveLikePiGetter } from "./pure/pi.test";
import { shouldBehaveLikePow } from "./pure/pow.test";
import { shouldBehaveLikePowu } from "./pure/powu.test";
import { shouldBehaveLikeSqrt } from "./pure/sqrt.test";
import { shouldBehaveLikeToUD60x18 } from "./pure/toUD60x18.test";

export function unitTestPrbMathUd60x18(): void {
  describe("PRBMathUD60x18", function () {
    beforeEach(async function () {
      const { prbMathUd60x18 } = await this.loadFixture(unitFixturePRBMathUd60x18);
      this.contracts.prbMathUd60x18 = prbMathUd60x18;
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

    describe("fromUD60x18", function () {
      shouldBehaveLikeFromUD60x18();
    });

    describe("e", function () {
      shouldBehaveLikeEGetter();
    });

    describe("pi", function () {
      shouldBehaveLikePiGetter();
    });

    describe("toUD60x18", function () {
      shouldBehaveLikeToUD60x18();
    });
  });
}
