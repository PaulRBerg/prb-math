import shouldBehaveLikeAbs from "./pure/abs";
import shouldBehaveLikeAvg from "./pure/avg";
import shouldBehaveLikeCeil from "./pure/ceil";
import shouldBehaveLikeEGetter from "./pure/e";
import shouldBehaveLikeFloor from "./pure/floor";
import shouldBehaveLikeFrac from "./pure/frac";
import shouldBehaveLikeLn from "./pure/ln";
import shouldBehaveLikeLog2 from "./pure/log2";
import shouldBehaveLikePiGetter from "./pure/pi";
import shouldBehaveLikeUnitGetter from "./pure/unit";

export function shouldBehaveLikePrbMath(): void {
  describe("Pure Functions", function () {
    describe("abs", function () {
      shouldBehaveLikeAbs();
    });

    describe("avg", function () {
      shouldBehaveLikeAvg();
    });

    describe("ceil", function () {
      shouldBehaveLikeCeil();
    });

    describe("e", function () {
      shouldBehaveLikeEGetter();
    });

    describe("floor", function () {
      shouldBehaveLikeFloor();
    });

    describe("frac", function () {
      shouldBehaveLikeFrac();
    });

    describe("ln", function () {
      shouldBehaveLikeLn();
    });

    describe("log2", function () {
      shouldBehaveLikeLog2();
    });

    describe("pi", function () {
      shouldBehaveLikePiGetter();
    });

    describe("unit", function () {
      shouldBehaveLikeUnitGetter();
    });
  });
}
