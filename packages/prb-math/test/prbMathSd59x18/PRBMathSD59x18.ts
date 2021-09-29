import { baseContext } from "../shared/contexts";
import { unitFixturePRBMathSd59x18 } from "../shared/fixtures";
import { shouldBehaveLikePRBMathSd59x18 } from "./PRBMathSD59x18.behavior";

baseContext("PRBMathSD59x18", function () {
  beforeEach(async function () {
    const { prbMathSd59x18, prbMathSd59x18Typed } = await this.loadFixture(unitFixturePRBMathSd59x18);
    this.contracts.prbMathSd59x18 = prbMathSd59x18;
    this.contracts.prbMathSd59x18Typed = prbMathSd59x18Typed;
  });

  shouldBehaveLikePRBMathSd59x18();
});
