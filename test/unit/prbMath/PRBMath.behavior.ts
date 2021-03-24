import shouldBehaveLikeLog2 from "./pure/log2";

export function shouldBehaveLikePrbMath(): void {
  describe("Pure Functions", function () {
    describe("log2", function () {
      shouldBehaveLikeLog2();
    });
  });
}
