// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/src/StdError.sol";

import { MAX_UD60x18, ZERO } from "src/ud60x18/Constants.sol";
import { mulDiv } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";
import { PRBMath_MulDiv_Overflow } from "src/Common.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";

contract MulDiv_Unit_Test is UD60x18_Unit_Test {
    function test_RevertWhen_DenominatorZero() external {
        UD60x18 x = ud(1e18);
        UD60x18 y = ud(1e18);
        UD60x18 denominator = ZERO;
        vm.expectRevert(stdError.divisionError);
        mulDiv(x, y, denominator);
    }

    modifier whenDenominatorNotZero() {
        _;
    }

    function test_RevertWhen_ResultOverflow() external whenDenominatorNotZero {
        UD60x18 x = MAX_UD60x18;
        UD60x18 y = MAX_UD60x18;
        UD60x18 denominator = ud(1e18);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, x.unwrap(), y.unwrap(), denominator.unwrap()));
        mulDiv(x, y, denominator);
    }

    modifier whenResultDoesNotOverflowUD60x18() {
        _;
    }

    function test_MulDiv_NumeratorZero() external whenDenominatorNotZero whenResultDoesNotOverflowUD60x18 {
        assertEq(mulDiv(ZERO, ud(5e18), ud(1e18)), ZERO, "UD60x18 mulDiv numerator zero");
    }

    function test_MulDiv() external whenDenominatorNotZero whenResultDoesNotOverflowUD60x18 {
        // 2 * 3 / 1 == 6 (also exercises the `using for` method form).
        assertEq(mulDiv(ud(2e18), ud(3e18), ud(1e18)), ud(6e18), "UD60x18 mulDiv 2*3/1");
        assertEq(ud(2e18).mulDiv(ud(3e18), ud(1e18)), ud(6e18), "UD60x18 mulDiv 2*3/1 (method)");

        // 6 * 1 / 3 == 2.
        assertEq(mulDiv(ud(6e18), ud(1e18), ud(3e18)), ud(2e18), "UD60x18 mulDiv 6*1/3");

        // 1 * 1 / 2 == 0.5.
        assertEq(mulDiv(ud(1e18), ud(1e18), ud(2e18)), ud(0.5e18), "UD60x18 mulDiv 1*1/2");

        // 10 * 10 / 100 == 1.
        assertEq(mulDiv(ud(10e18), ud(10e18), ud(100e18)), ud(1e18), "UD60x18 mulDiv 10*10/100");

        // 3 * 4 / 6 == 2.
        assertEq(mulDiv(ud(3e18), ud(4e18), ud(6e18)), ud(2e18), "UD60x18 mulDiv 3*4/6");

        // 1 * 1 / 3 == 0.333... (rounded toward zero).
        assertEq(mulDiv(ud(1e18), ud(1e18), ud(3e18)).unwrap(), 333_333_333_333_333_333, "UD60x18 mulDiv 1*1/3 floored");
    }
}
