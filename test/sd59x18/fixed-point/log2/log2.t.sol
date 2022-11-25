// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../../SD59x18BaseTest.t.sol";

contract SD59x18__Log2Test is SD59x18__BaseTest {
    function testCannotLog2__Zero() external {
        SD59x18 x = ZERO;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        log2(x);
    }

    modifier NotZero() {
        _;
    }

    function testCannotLog2__Negative() external NotZero {
        SD59x18 x = sd(-1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        log2(x);
    }

    modifier Positive() {
        _;
    }

    function powerOfTwoSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.0625e18, expected: -4e18 }));
        sets.push(set({ x: 0.125e18, expected: -3e18 }));
        sets.push(set({ x: 0.25e18, expected: -2e18 }));
        sets.push(set({ x: 0.5e18, expected: -1e18 }));
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 2e18, expected: 1e18 }));
        sets.push(set({ x: 4e18, expected: 2e18 }));
        sets.push(set({ x: 8e18, expected: 3e18 }));
        sets.push(set({ x: 16e18, expected: 4e18 }));
        sets.push(set({ x: 2**195 * 10**18, expected: 195e18 }));
        return sets;
    }

    function testLog2__PowerOfTwo() external parameterizedTest(powerOfTwoSets()) NotZero Positive {
        SD59x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }

    function notPowerOfTwoSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.0091e18, expected: -6_779917739350753112 }));
        sets.push(set({ x: 0.083e18, expected: -3_590744853315162277 }));
        sets.push(set({ x: 0.1e18, expected: -3_321928094887362334 }));
        sets.push(set({ x: 0.2e18, expected: -2_321928094887362334 }));
        sets.push(set({ x: 0.3e18, expected: -1_736965594166206154 }));
        sets.push(set({ x: 0.4e18, expected: -1_321928094887362334 }));
        sets.push(set({ x: 0.6e18, expected: -0.736965594166206154e18 }));
        sets.push(set({ x: 0.7e18, expected: -0.514573172829758229e18 }));
        sets.push(set({ x: 0.8e18, expected: -0.321928094887362334e18 }));
        sets.push(set({ x: 0.9e18, expected: -0.152003093445049973e18 }));
        sets.push(set({ x: 1.125e18, expected: 0.169925001442312346e18 }));
        sets.push(set({ x: E, expected: 1_442695040888963394 }));
        sets.push(set({ x: PI, expected: 1_651496129472318782 }));
        sets.push(set({ x: 1e24, expected: 19_931568569324174075 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 195_205294292027477728 }));
        sets.push(set({ x: MAX_SD59x18, expected: 195_205294292027477728 }));
        return sets;
    }

    function testLog2__NotPowerOfTwo() external parameterizedTest(notPowerOfTwoSets()) NotZero Positive {
        SD59x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }
}
