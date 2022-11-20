// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    MAX_WHOLE_SD59x18,
    MAX_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__CeilOverflow,
    SD59x18,
    ZERO,
    ceil
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__CeilTest is SD59x18__BaseTest {
    function testCannotCeil__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = ceil(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function negativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: -1e24, expected: -1e24 }));
        sets.push(set({ x: -4.2e18, expected: -4e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: -3e18 }));
        sets.push(set({ x: -2e18, expected: -2e18 }));
        sets.push(set({ x: -1.125e18, expected: -1e18 }));
        sets.push(set({ x: -1e18, expected: -1e18 }));
        sets.push(set({ x: -0.5e18, expected: 0 }));
        sets.push(set({ x: -0.1e18, expected: 0 }));
        return sets;
    }

    function testCeil__Negative() external parameterizedTest(negativeSets()) NotZero {
        SD59x18 actual = ceil(s.x);
        assertEq(actual, s.expected);
    }

    function greaterThanMaxPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MAX_WHOLE_SD59x18.add(sd(1)) }));
        sets.push(set({ x: MAX_SD59x18 }));
        return sets;
    }

    function testCannotCeil__GreaterThanMaxPermitted()
        external
        parameterizedTest(greaterThanMaxPermittedSets())
        NotZero
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__CeilOverflow.selector, s.x));
        ceil(s.x);
    }

    modifier LessThanOrEqualToMaxPermitted() {
        _;
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 1e18 }));
        sets.push(set({ x: 0.5e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 2e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 4e18 }));
        sets.push(set({ x: 4.2e18, expected: 5e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function testCeil__Positive() external parameterizedTest(positiveSets()) NotZero LessThanOrEqualToMaxPermitted {
        SD59x18 actual = ceil(s.x);
        assertEq(actual, s.expected);
    }
}
