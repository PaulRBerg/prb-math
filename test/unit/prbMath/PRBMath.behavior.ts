import shouldBehaveLikeAbs from "./pure/abs";
import shouldBehaveLikeCeil from "./pure/ceil";
import shouldBehaveLikeFloor from "./pure/floor";
import shouldBehaveLikeFrac from "./pure/frac";
import shouldBehaveLikeLn from "./pure/ln";
import shouldBehaveLikeLog2 from "./pure/log2";

export function shouldBehaveLikePrbMath(): void {
  describe("Pure Functions", function () {
    describe("abs", function () {
      shouldBehaveLikeAbs();
    });

    describe("ceil", function () {
      shouldBehaveLikeCeil();
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
  });
}
