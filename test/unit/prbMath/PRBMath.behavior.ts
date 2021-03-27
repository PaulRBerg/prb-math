import shouldBehaveLikeAbs from "./pure/abs";
import shouldBehaveLikeCeil from "./pure/ceil";
import shouldBehaveLikeFloor from "./pure/floor";
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

    describe("log2", function () {
      shouldBehaveLikeLog2();
    });
  });
}
