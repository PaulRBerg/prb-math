// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { sd } from "src/sd59x18/Casting.sol";
import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, ZERO } from "src/sd59x18/Constants.sol";
import { PRBMath_SD59x18_Log_InputTooSmall } from "src/sd59x18/Errors.sol";
import { log10 } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Unit_Test } from "../../SD59x18.t.sol";

contract Log10_Unit_Test is SD59x18_Unit_Test {
    function test_RevertWhen_Zero() external {
        SD59x18 x = ZERO;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Log_InputTooSmall.selector, x));
        log10(x);
    }

    modifier whenNotZero() {
        _;
    }

    function test_RevertWhen_Negative() external whenNotZero {
        SD59x18 x = sd(-1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Log_InputTooSmall.selector, x));
        log10(x);
    }

    modifier whenPositive() {
        _;
    }

    function powerOfTenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, expected: -18e18 }));
        sets.push(set({ x: 0.00000000000000001e18, expected: -17e18 }));
        sets.push(set({ x: 0.00000000000001e18, expected: -14e18 }));
        sets.push(set({ x: 0.0000000001e18, expected: -10e18 }));
        sets.push(set({ x: 0.00000001e18, expected: -8e18 }));
        sets.push(set({ x: 0.0000001e18, expected: -7e18 }));
        sets.push(set({ x: 0.001e18, expected: -3e18 }));
        sets.push(set({ x: 0.1e18, expected: -1e18 }));
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 10e18, expected: 1e18 }));
        sets.push(set({ x: 100e18, expected: 2e18 }));
        sets.push(set({ x: 1e24, expected: 6e18 }));
        sets.push(set({ x: 1e67, expected: 49e18 }));
        sets.push(set({ x: 1e75, expected: 57e18 }));
        sets.push(set({ x: 1e76, expected: 58e18 }));
        return sets;
    }

    function test_Log10_PowerOfTen() external parameterizedTest(powerOfTenSets()) whenNotZero whenPositive {
        SD59x18 actual = log10(s.x);
        assertEq(actual, s.expected, "SD59x18 log10");
    }

    function notPowerOfTenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 7.892191e6, expected: -11_102802412872166458 }));
        sets.push(set({ x: 0.0091e18, expected: -2_040958607678906397 }));
        sets.push(set({ x: 0.083e18, expected: -1_080921907623926093 }));
        sets.push(set({ x: 0.1982e18, expected: -702896349850743472 }));
        sets.push(set({ x: 0.313e18, expected: -504455662453551511 }));
        sets.push(set({ x: 0.4666e18, expected: -331055265542266175 }));
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
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 58_762648894315204791 }));
        sets.push(set({ x: MAX_SD59x18, expected: 58_762648894315204791 }));
        return sets;
    }

    function test_Log10_NotPowerOfTen() external parameterizedTest(notPowerOfTenSets()) whenNotZero whenPositive {
        SD59x18 actual = log10(s.x);
        assertEq(actual, s.expected, "SD59x18 log10");
    }

    function test_Log10_AllPowersOfTenAndNeighbors() external pure {
        int256 power = 1;
        for (int256 exponent = -18; exponent <= 58; ++exponent) {
            int256 expected = exponent * 1e18;
            assertEq(log10(sd(power)), sd(expected), "exact power");
            int256 above = log10(sd(power + 1)).unwrap();
            assertGe(above, expected, "above power lower bound");
            assertLe(above, expected + 1e18, "above power upper bound");
            if (power > 1) {
                int256 below = log10(sd(power - 1)).unwrap();
                assertLe(below, expected, "below power upper bound");
                assertGe(below, expected - 1e18, "below power lower bound");
            }
            if (exponent < 58) {
                power *= 10;
            }
        }
    }

    function test_Log10_AboveTen() external pure {
        assertEq(log10(sd(10e18 + 1)), sd(1e18));
    }

    function test_Log10_MaxValueDecade() external pure {
        int256 actual = log10(MAX_SD59x18).unwrap();
        assertGe(actual, 58e18);
        assertLe(actual, 59e18);
    }
}
