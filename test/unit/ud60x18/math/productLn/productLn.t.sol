// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, UNIT } from "src/ud60x18/Constants.sol";
import { PRBMath_UD60x18_ProductLn_InputTooBig } from "src/ud60x18/Errors.sol";
import { productLn } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";

contract Product_Ln_Unit_Test is UD60x18_Unit_Test {
    function test_RevertWhen_GtMaxMinusUnit() external {
        UD60x18 x = MAX_UD60x18 - UNIT + UD60x18.wrap(1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_ProductLn_InputTooBig.selector, x));
        productLn(x);
    }

    // Actual values as provided by Wolfram Alpha. Expected values differ slightly due to precision loss.
    //     sets.push(set({ x: 0.1e18, expected: 0.091276527160862264e18 }));
    //     sets.push(set({ x: 0.5e18, expected: 0.351733711249195826e18 }));
    //     sets.push(set({ x: 1e18, expected: 0.567143290409783872e18 }));
    //     sets.push(set({ x: 2e18, expected: 0.852605502013725491e18 }));
    //     sets.push(set({ x: E, expected: 0.99999999999999999e18 }));
    //     sets.push(set({ x: PI, expected: 1.073658194796149172e18 }));
    //     sets.push(set({ x: 4e18, expected: 1.202167873197042939e18 }));
    //     sets.push(set({ x: 8e18, expected: 1.605811996320177596e18 }));
    //     sets.push(set({ x: 1e24, expected: 11.383358086140052622e18 }));
    //     sets.push(set({ x: 1e36, expected: 37.813856075588763228e18 }));
    //     sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 131.123010654220946391e18 }));
    //     sets.push(set({ x: MAX_UD60x18, expected: 131.123010654220946391e18 }));
    function productLn_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, expected: 0 }));
        sets.push(set({ x: 0.1e18, expected: 0.091276527160862263e18 })); // 1 wei off
        sets.push(set({ x: 0.5e18, expected: 0.351733711249195823e18 })); // 3 wei off
        sets.push(set({ x: 1e18, expected: 0.567143290409783868e18 })); // 4 wei off
        sets.push(set({ x: 2e18, expected: 0.852605502013725487e18 })); // 4 wei off
        sets.push(set({ x: E, expected: 0.999999999999999994e18 })); // 6 wei off
        sets.push(set({ x: PI, expected: 1.073658194796149166e18 })); // 6 wei off
        sets.push(set({ x: 4e18, expected: 1.202167873197042932e18 })); // 7 wei off
        sets.push(set({ x: 8e18, expected: 1.605811996320177591e18 })); // 5 wei off
        sets.push(set({ x: 1e24, expected: 11.383358086140052608e18 })); // 14 wei off
        sets.push(set({ x: 1e36, expected: 37.813856075588763202e18 })); // 26 wei off
        sets.push(set({ x: MAX_WHOLE_UD60x18 - UNIT, expected: 131.123010654220946305e18 })); // 86 wei off
        sets.push(set({ x: MAX_UD60x18 - UNIT, expected: 131.123010654220946305e18 })); // 86 wei off
        return sets;
    }

    function test_ProductLn() external parameterizedTest(productLn_Sets()) {
        UD60x18 actual = productLn(s.x);
        assertEq(actual, s.expected, "UD60x18 productLn");
    }
}
