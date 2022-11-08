// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { MAX_WHOLE_SD59x18, MAX_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI, SD59x18, ZERO, frac } from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__FracTest is SD59x18__BaseTest {
    function testFrac__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = frac(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function negativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: -792003956564819968 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: ZERO }));
        sets.push(set({ x: -1e36, expected: ZERO }));
        sets.push(set({ x: -4.2e18, expected: -2e17 }));
        sets.push(set({ x: negativePI, expected: -141592653589793238 }));
        sets.push(set({ x: -2e18, expected: ZERO }));
        sets.push(set({ x: -1.125e18, expected: -125e15 }));
        sets.push(set({ x: -1e18, expected: ZERO }));
        sets.push(set({ x: -0.5e18, expected: -5e17 }));
        sets.push(set({ x: -0.1e18, expected: -1e17 }));
        return sets;
    }

    function testFrac__Negative() external parameterizedTest(negativeSets()) NotZero {
        SD59x18 actual = frac(s.x);
        assertEq(actual, s.expected);
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 1e17 }));
        sets.push(set({ x: 0.5e18, expected: 5e17 }));
        sets.push(set({ x: 1e18, expected: ZERO }));
        sets.push(set({ x: 1.125e18, expected: 125e15 }));
        sets.push(set({ x: 2e18, expected: ZERO }));
        sets.push(set({ x: PI, expected: 141592653589793238 }));
        sets.push(set({ x: 4.2e18, expected: 2e17 }));
        sets.push(set({ x: 1e36, expected: ZERO }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: ZERO }));
        sets.push(set({ x: MAX_SD59x18, expected: 792003956564819967 }));
        return sets;
    }

    function testFrac() external parameterizedTest(positiveSets()) NotZero {
        SD59x18 actual = frac(s.x);
        assertEq(actual, s.expected);
    }
}
