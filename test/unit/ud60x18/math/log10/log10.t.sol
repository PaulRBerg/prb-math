// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, UNIT } from "src/ud60x18/Constants.sol";
import { PRBMath_UD60x18_Log_InputTooSmall } from "src/ud60x18/Errors.sol";
import { log10 } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";

contract Log10_Unit_Test is UD60x18_Unit_Test {
    function test_RevertWhen_LtUnit() external {
        UD60x18 x = UNIT - ud(1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Log_InputTooSmall.selector, x));
        log10(x);
    }

    modifier whenGteUnit() {
        _;
    }

    function powerOfTenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 10e18, expected: 1e18 }));
        sets.push(set({ x: 100e18, expected: 2e18 }));
        sets.push(set({ x: 1e24, expected: 6e18 }));
        sets.push(set({ x: 1e67, expected: 49e18 }));
        sets.push(set({ x: 1e75, expected: 57e18 }));
        sets.push(set({ x: 1e76, expected: 58e18 }));
        return sets;
    }

    function test_Log10_PowerOfTen() external parameterizedTest(powerOfTenSets()) whenGteUnit {
        UD60x18 actual = log10(s.x);
        assertEq(actual, s.expected, "UD60x18 log10");
    }

    function notPowerOfTenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1.00000000000001e18, expected: 0.000000000000004341e18 }));
        sets.push(set({ x: E, expected: 0.434294481903251823e18 }));
        sets.push(set({ x: PI, expected: 0.497149872694133849e18 }));
        sets.push(set({ x: 4e18, expected: 0.60205999132796239e18 }));
        sets.push(set({ x: 16e18, expected: 1_204119982655924781 }));
        sets.push(set({ x: 32e18, expected: 1_505149978319905976 }));
        sets.push(set({ x: 42.12e18, expected: 1_624488362513448905 }));
        sets.push(set({ x: 1010.892143e18, expected: 3_004704821071980110 }));
        sets.push(set({ x: 440934.1881e18, expected: 5_644373773418177966 }));
        sets.push(set({ x: 1000000000000000000.000000000001e18, expected: 18e18 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 59_063678889979185987 }));
        sets.push(set({ x: MAX_UD60x18, expected: 59_063678889979185987 }));
        return sets;
    }

    function test_Log10_NotPowerOfTen() external parameterizedTest(notPowerOfTenSets()) whenGteUnit {
        UD60x18 actual = log10(s.x);
        assertEq(actual, s.expected, "UD60x18 log10");
    }

    function test_Log10_AllPowersOfTenAndNeighbors() external pure {
        uint256 power = 1e18;
        for (uint256 exponent = 0; exponent <= 59; ++exponent) {
            uint256 expected = exponent * 1e18;
            assertEq(log10(ud(power)), ud(expected), "exact power");
            uint256 above = log10(ud(power + 1)).unwrap();
            assertGe(above, expected, "above power lower bound");
            assertLe(above, expected + 1e18, "above power upper bound");
            if (power > 1e18) {
                uint256 below = log10(ud(power - 1)).unwrap();
                assertLe(below, expected, "below power upper bound");
                assertGe(below, expected - 1e18, "below power lower bound");
            }
            if (exponent < 59) {
                power *= 10;
            }
        }
    }

    function test_Log10_AboveTen() external pure {
        assertEq(log10(ud(10e18 + 1)), ud(1e18));
    }

    function test_Log10_MaxValueDecade() external pure {
        uint256 actual = log10(MAX_UD60x18).unwrap();
        assertGe(actual, 59e18);
        assertLe(actual, 60e18);
    }
}
