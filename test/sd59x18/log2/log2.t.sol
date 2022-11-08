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
    log2
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__Log2Test is SD59x18__BaseTest {
    function testLog2__Zero() external {
        SD59x18 x = ZERO;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        log2(x);
    }

    modifier NotZero() {
        _;
    }

    function testLog2__Negative() external {
        SD59x18 x = sd(-1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        log2(x);
    }

    modifier NotNegative() {
        _;
    }

    function powerSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.0625e18, expected: -4e18 }));
        sets.push(set({ x: 0.125e18, expected: -3e18 }));
        sets.push(set({ x: 0.25e18, expected: -2e18 }));
        sets.push(set({ x: 0.5e18, expected: -1e18 }));
        sets.push(set({ x: 1e18, expected: ZERO }));
        sets.push(set({ x: 2e18, expected: 1e18 }));
        sets.push(set({ x: 4e18, expected: 2e18 }));
        sets.push(set({ x: 8e18, expected: 3e18 }));
        sets.push(set({ x: 16e18, expected: 4e18 }));
        sets.push(set({ x: 195e18, expected: 7_607330313749610674 }));
        return sets;
    }

    function testLog2__PowerOfTwo() external parameterizedTest(powerSets()) NotZero NotNegative {
        SD59x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }

    function notPowerSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.0091e18, expected: -6_779917739350753112 }));
        sets.push(set({ x: 0.083e18, expected: -3_590744853315162277 }));
        sets.push(set({ x: 0.1e18, expected: -3_321928094887362334 }));
        sets.push(set({ x: 0.2e18, expected: -2_321928094887362334 }));
        sets.push(set({ x: 0.3e18, expected: -1_736965594166206154 }));
        sets.push(set({ x: 0.4e18, expected: -1_321928094887362334 }));
        sets.push(set({ x: 0.6e18, expected: -736965594166206154 }));
        sets.push(set({ x: 0.7e18, expected: -514573172829758229 }));
        sets.push(set({ x: 0.8e18, expected: -321928094887362334 }));
        sets.push(set({ x: 0.9e18, expected: -152003093445049973 }));
        sets.push(set({ x: 1.125e18, expected: 169925001442312346 }));
        sets.push(set({ x: E, expected: 1_442695040888963394 }));
        sets.push(set({ x: PI, expected: 1_651496129472318782 }));
        sets.push(set({ x: 1e36, expected: 59_794705707972522245 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 195_205294292027477728 }));
        sets.push(set({ x: MAX_SD59x18, expected: 195_205294292027477728 }));
        return sets;
    }

    function testLog2() external parameterizedTest(notPowerSets()) NotZero NotNegative {
        SD59x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }
}
