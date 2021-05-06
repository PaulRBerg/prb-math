import { baseContext } from "../../contexts";
import { unitFixturePrbMathUd60x18 } from "../fixtures";
import { shouldBehaveLikePrbMathUd60x18 } from "./PRBMathUD60x18.behavior";

baseContext("Unit tests", function () {
  describe("PRBMathUD60x18", function () {
    beforeEach(async function () {
      const { prbMathUd60x18 } = await this.loadFixture(unitFixturePrbMathUd60x18);
      this.contracts.prbMathUd60x18 = prbMathUd60x18;
    });

    shouldBehaveLikePrbMathUd60x18();
  });
});
