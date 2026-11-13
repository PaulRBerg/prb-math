// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/src/StdError.sol";

import { mulDiv, PRBMath_MulDiv_Overflow } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

contract Common_MulDiv_Unit_Test is Base_Test {
    function test_RevertWhen_MulDiv_DenominatorZero_ZeroOperands() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(0, 0, 0);
    }

    function test_RevertWhen_MulDiv_DenominatorZero_ZeroProduct() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(0, type(uint256).max, 0);
    }

    function test_RevertWhen_MulDiv_DenominatorZero_SmallProduct() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(1, 1, 0);
    }

    function test_RevertWhen_MulDiv_DenominatorZero_Max256BitProduct() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(type(uint256).max, 1, 0);
    }

    function test_RevertWhen_MulDiv_DenominatorZero_Min512BitProduct() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(2 ** 128, 2 ** 128, 0);
    }

    function test_RevertWhen_MulDiv_DenominatorZero_Max512BitProduct() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(type(uint256).max, type(uint256).max, 0);
    }

    function test_MulDiv_NonzeroDenominator() external pure {
        assertEq(mulDiv(0, type(uint256).max, 1), 0);
        assertEq(mulDiv(6, 7, 2), 21);
        assertEq(mulDiv(type(uint256).max, type(uint256).max, type(uint256).max), type(uint256).max);
    }

    function test_RevertWhen_MulDiv_ResultOverflow() external {
        vm.expectRevert(
            abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, type(uint256).max, type(uint256).max, type(uint256).max - 1)
        );
        mulDiv(type(uint256).max, type(uint256).max, type(uint256).max - 1);
    }
}
