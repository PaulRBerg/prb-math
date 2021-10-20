import { baseContext } from "../shared/contexts";
import { unitTestPrbMathSd59x18 } from "./prbMathSd59x18/PRBMathSD59x18.test";
import { unitTestPrbMathUd60x18 } from "./prbMathUd60x18/PRBMathUD60x18.test";

baseContext("PRBMath Solidity", function () {
  unitTestPrbMathSd59x18();
  unitTestPrbMathUd60x18();
});
