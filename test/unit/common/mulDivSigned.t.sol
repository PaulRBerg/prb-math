// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/src/StdError.sol";

import {
    mulDivSigned,
    PRBMath_MulDiv_Overflow,
    PRBMath_MulDivSigned_InputTooSmall,
    PRBMath_MulDivSigned_Overflow
} from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

contract Common_MulDivSigned_Unit_Test is Base_Test {
    int256 internal constant HALF_MIN = MIN_INT256 / 2;

    function test_MulDivSigned_SignCombinations() external pure {
        assertEq(mulDivSigned(6, 7, 2), 21);
        assertEq(mulDivSigned(-6, 7, 2), -21);
        assertEq(mulDivSigned(6, -7, 2), -21);
        assertEq(mulDivSigned(6, 7, -2), -21);
        assertEq(mulDivSigned(-6, -7, 2), 21);
        assertEq(mulDivSigned(-6, 7, -2), 21);
        assertEq(mulDivSigned(6, -7, -2), 21);
        assertEq(mulDivSigned(-6, -7, -2), -21);
    }

    function test_MulDivSigned_Zero() external pure {
        assertEq(mulDivSigned(0, 0, 1), 0);
        assertEq(mulDivSigned(0, MAX_INT256, -1), 0);
        assertEq(mulDivSigned(-MAX_INT256, 0, 1), 0);
        assertEq(mulDivSigned(0, -MAX_INT256, 1), 0);
        assertEq(mulDivSigned(MAX_INT256, 0, -1), 0);
    }

    function test_MulDivSigned_RoundTowardZero() external pure {
        assertEq(mulDivSigned(5, 3, 2), 7);
        assertEq(mulDivSigned(-5, 3, 2), -7);
        assertEq(mulDivSigned(5, -3, 2), -7);
        assertEq(mulDivSigned(5, 3, -2), -7);
        assertEq(mulDivSigned(-5, -3, 2), 7);
        assertEq(mulDivSigned(-5, 3, -2), 7);
        assertEq(mulDivSigned(5, -3, -2), 7);
        assertEq(mulDivSigned(-5, -3, -2), -7);
        assertEq(mulDivSigned(1, 1, 2), 0);
        assertEq(mulDivSigned(-1, 1, 2), 0);
        assertEq(mulDivSigned(1, -1, 2), 0);
        assertEq(mulDivSigned(1, 1, -2), 0);
    }

    function test_MulDivSigned_ResultMaxAndMinPlusOne() external pure {
        assertEq(mulDivSigned(MAX_INT256, 1, 1), MAX_INT256);
        assertEq(mulDivSigned(-MAX_INT256, 1, 1), MIN_INT256 + 1);
        assertEq(mulDivSigned(MAX_INT256, MAX_INT256, MAX_INT256), MAX_INT256);
        assertEq(mulDivSigned(-MAX_INT256, MAX_INT256, MAX_INT256), MIN_INT256 + 1);
    }

    function test_MulDivSigned_ResultMin() external pure {
        assertEq(mulDivSigned(HALF_MIN, 2, 1), MIN_INT256);
        assertEq(mulDivSigned(-HALF_MIN, -2, 1), MIN_INT256);
        assertEq(mulDivSigned(-HALF_MIN, 2, -1), MIN_INT256);
        assertEq(mulDivSigned(HALF_MIN, -2, -1), MIN_INT256);
    }

    function test_MulDivSigned_ResultMinWith512BitProduct() external pure {
        assertEq(mulDivSigned(HALF_MIN, 4, 2), MIN_INT256);
        assertEq(mulDivSigned(-HALF_MIN, -4, 2), MIN_INT256);
        assertEq(mulDivSigned(-HALF_MIN, 4, -2), MIN_INT256);
        assertEq(mulDivSigned(HALF_MIN, -4, -2), MIN_INT256);
    }

    function test_MulDivSigned_RoundToMin() external pure {
        // (2^255 - 1)^2 / (2^255 - 2) = 2^255 + 1 / (2^255 - 2).
        assertEq(mulDivSigned(-MAX_INT256, MAX_INT256, MAX_INT256 - 1), MIN_INT256);
        assertEq(mulDivSigned(MAX_INT256, -MAX_INT256, MAX_INT256 - 1), MIN_INT256);
        assertEq(mulDivSigned(MAX_INT256, MAX_INT256, 1 - MAX_INT256), MIN_INT256);
        assertEq(mulDivSigned(-MAX_INT256, -MAX_INT256, 1 - MAX_INT256), MIN_INT256);
    }

    function test_RevertWhen_MulDivSigned_InputMin() external {
        vm.expectRevert(PRBMath_MulDivSigned_InputTooSmall.selector);
        mulDivSigned(MIN_INT256, 1, 1);
        vm.expectRevert(PRBMath_MulDivSigned_InputTooSmall.selector);
        mulDivSigned(1, MIN_INT256, 1);
        vm.expectRevert(PRBMath_MulDivSigned_InputTooSmall.selector);
        mulDivSigned(1, 1, MIN_INT256);
    }

    function test_RevertWhen_MulDivSigned_DenominatorZero() external {
        vm.expectRevert(stdError.divisionError);
        mulDivSigned(1, -1, 0);
        vm.expectRevert(stdError.divisionError);
        mulDivSigned(0, 0, 0);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, uint256(-HALF_MIN), 4, 0));
        mulDivSigned(HALF_MIN, 4, 0);
    }

    function test_RevertWhen_MulDivSigned_ResultMaxPlusOne() external {
        expectOverflow(-HALF_MIN, 2, 1);
        expectOverflow(HALF_MIN, -2, 1);
        expectOverflow(HALF_MIN, 2, -1);
        expectOverflow(-HALF_MIN, -2, -1);
    }

    function test_RevertWhen_MulDivSigned_ResultMaxPlusOneWith512BitProduct() external {
        expectOverflow(-HALF_MIN, 4, 2);
        expectOverflow(HALF_MIN, -4, 2);
        expectOverflow(HALF_MIN, 4, -2);
        expectOverflow(-HALF_MIN, -4, -2);
    }

    function test_RevertWhen_MulDivSigned_ResultMinMinusOne() external {
        int256 x = MAX_INT256 / 3 + 1;
        expectOverflow(-x, 3, 1);
        expectOverflow(x, -3, 1);
        expectOverflow(x, 3, -1);
        expectOverflow(-x, -3, -1);
    }

    function test_RevertWhen_MulDivSigned_ResultOverflowUint256() external {
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, uint256(MAX_INT256), uint256(MAX_INT256), 1));
        mulDivSigned(-MAX_INT256, MAX_INT256, 1);
    }

    function expectOverflow(int256 x, int256 y, int256 denominator) internal {
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDivSigned_Overflow.selector, x, y));
        mulDivSigned(x, y, denominator);
    }
}
