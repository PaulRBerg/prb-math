import { baseContext } from "../shared/contexts";
import { unitFixturePrbMathUd60x18 } from "../shared/fixtures";
import { shouldBehaveLikePrbMathUd60x18 } from "./PRBMathUD60x18.behavior";

baseContext("PRBMathUD60x18", function () {
  beforeEach(async function () {
    const { prbMathUd60x18, prbMathUd60x18Typed } = await this.loadFixture(unitFixturePrbMathUd60x18);
    this.contracts.prbMathUd60x18 = prbMathUd60x18;
    this.contracts.prbMathUd60x18Typed = prbMathUd60x18Typed;
  });

  shouldBehaveLikePrbMathUd60x18();
});
