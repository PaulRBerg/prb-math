import shouldBehaveLikeAbs from "./pure/abs";
import shouldBehaveLikeAdd from "./pure/add";
import shouldBehaveLikeAvg from "./pure/avg";
import shouldBehaveLikeCeil from "./pure/ceil";
import shouldBehaveLikeDiv from "./pure/div";
import shouldBehaveLikeEGetter from "./pure/e";
import shouldBehaveLikeExp from "./pure/exp";
import shouldBehaveLikeExp2 from "./pure/exp2";
import shouldBehaveLikeFloor from "./pure/floor";
import shouldBehaveLikeFrac from "./pure/frac";
import shouldBehaveLikeFromInt from "./pure/fromInt";
import shouldBehaveLikeGm from "./pure/gm";
import shouldBehaveLikeInv from "./pure/inv";
import shouldBehaveLikeLn from "./pure/ln";
import shouldBehaveLikeLog10 from "./pure/log10";
import shouldBehaveLikeLog2 from "./pure/log2";
import shouldBehaveLikeMul from "./pure/mul";
import shouldBehaveLikePiGetter from "./pure/pi";
import shouldBehaveLikePow from "./pure/pow";
import shouldBehaveLikePowu from "./pure/powu";
import shouldBehaveLikeScaleGetter from "./pure/scale";
import shouldBehaveLikeSqrt from "./pure/sqrt";
import shouldBehaveLikeSub from "./pure/sub";
import shouldBehaveLikeToInt from "./pure/toInt";

export function shouldBehaveLikePRBMathSd59x18(): void {
  describe("Pure Functions", function () {
    describe("abs", function () {
      shouldBehaveLikeAbs();
    });

    describe("add", function () {
      shouldBehaveLikeAdd();
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

    describe("e", function () {
      shouldBehaveLikeEGetter();
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

    describe("fromInt", function () {
      shouldBehaveLikeFromInt();
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

    describe("pi", function () {
      shouldBehaveLikePiGetter();
    });

    describe("pow", function () {
      shouldBehaveLikePow();
    });

    describe("powu", function () {
      shouldBehaveLikePowu();
    });

    describe("scale", function () {
      shouldBehaveLikeScaleGetter();
    });

    describe("sqrt", function () {
      shouldBehaveLikeSqrt();
    });

    describe("sub", function () {
      shouldBehaveLikeSub();
    });

    describe("toInt", function () {
      shouldBehaveLikeToInt();
    });
  });
}
