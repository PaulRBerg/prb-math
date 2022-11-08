// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_WHOLE_SD59x18,
    MAX_SD59x18,
    PI,
    PRBMathSD59x18__LogInputTooSmall,
    SD59x18,
    ZERO,
    log10
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__Log10Test is SD59x18__BaseTest {
    function testLog10__Zero() external {
        SD59x18 x = ZERO;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        log10(x);
    }

    modifier NotZero() {
        _;
    }

    function testLog10__Negative() external NotZero {
        SD59x18 x = sd(-1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        log10(x);
    }

    modifier Positive() {
        _;
    }

    function powerSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1, expected: -18e18 }));
        sets.push(set({ x: 10, expected: -17e18 }));
        sets.push(set({ x: 1e4, expected: -14e18 }));
        sets.push(set({ x: 1e8, expected: -10e18 }));
        sets.push(set({ x: 1e10, expected: -8e18 }));
        sets.push(set({ x: 1e11, expected: -7e18 }));
        sets.push(set({ x: 0.001e18, expected: -3e18 }));
        sets.push(set({ x: 0.1e18, expected: -1e18 }));
        sets.push(set({ x: 1e18, expected: ZERO }));
        sets.push(set({ x: 10e18, expected: 1e18 }));
        sets.push(set({ x: 100e18, expected: 2e18 }));
        sets.push(set({ x: 1e36, expected: 18e18 }));
        sets.push(set({ x: 1e67, expected: 49e18 }));
        sets.push(set({ x: 1e75, expected: 57e18 }));
        sets.push(set({ x: 1e76, expected: 58e18 }));
        return sets;
    }

    function testLog10__PowerOfTen() external parameterizedTest(powerSets()) NotZero Positive {
        SD59x18 actual = log10(s.x);
        assertEq(actual, s.expected);
    }

    function notPowerSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 7.892191e6, expected: -11_102802412872166458 }));
        sets.push(set({ x: 0.0091e18, expected: -2_040958607678906397 }));
        sets.push(set({ x: 0.083e18, expected: -1_080921907623926093 }));
        sets.push(set({ x: 0.1982e18, expected: -702896349850743472 }));
        sets.push(set({ x: 0.313e18, expected: -504455662453551511 }));
        sets.push(set({ x: 0.4666e18, expected: -331055265542266175 }));
        sets.push(set({ x: 1.00000000000001e18, expected: 4341 }));
        sets.push(set({ x: E, expected: 434294481903251823 }));
        sets.push(set({ x: PI, expected: 497149872694133849 }));
        sets.push(set({ x: 4e18, expected: 602059991327962390 }));
        sets.push(set({ x: 16e18, expected: 1_204119982655924781 }));
        sets.push(set({ x: 32e18, expected: 1_505149978319905976 }));
        sets.push(set({ x: 42.12e18, expected: 1_624488362513448905 }));
        sets.push(set({ x: 1010.892143e18, expected: 3_004704821071980110 }));
        sets.push(set({ x: 440934.1881e18, expected: 5_644373773418177966 }));
        sets.push(set({ x: 1000000000000000000.000000000001e18, expected: 17_999999999999999999 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 58_762648894315204791 }));
        sets.push(set({ x: MAX_SD59x18, expected: 58_762648894315204791 }));
        return sets;
    }

    function testLog10() external parameterizedTest(notPowerSets()) NotZero Positive {
        SD59x18 actual = log10(s.x);
        assertEq(actual, s.expected);
    }
}
