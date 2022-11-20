// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__AbsMinSD59x18,
    SD59x18,
    ZERO,
    abs
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__AbsTest is SD59x18__BaseTest {
    function testCannotAbs__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = abs(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function testCannotAbs__MinSD59x18() external NotZero {
        SD59x18 x = MIN_SD59x18;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__AbsMinSD59x18.selector));
        abs(x);
    }

    modifier NotMinSD59x18() {
        _;
    }

    function negativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(1)), expected: MAX_SD59x18 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: -1e24, expected: 1e24 }));
        sets.push(set({ x: -4.2e18, expected: 4.2e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: PI }));
        sets.push(set({ x: -2e18, expected: 2e18 }));
        sets.push(set({ x: -1.125e18, expected: 1.125e18 }));
        sets.push(set({ x: -1e18, expected: 1e18 }));
        sets.push(set({ x: -0.5e18, expected: 0.5e18 }));
        sets.push(set({ x: -0.1e18, expected: 0.1e18 }));
        return sets;
    }

    function testAbs__Negative() external parameterizedTest(negativeSets()) NotZero NotMinSD59x18 {
        SD59x18 actual = abs(s.x);
        assertEq(actual, s.expected);
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0.1e18 }));
        sets.push(set({ x: 0.5e18, expected: 0.5e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 1.125e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: PI }));
        sets.push(set({ x: 4.2e18, expected: 4.2e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18, expected: MAX_SD59x18 }));
        return sets;
    }

    function testAbs() external parameterizedTest(positiveSets()) NotZero NotMinSD59x18 {
        SD59x18 actual = abs(s.x);
        assertEq(actual, s.expected);
    }
}
