// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__InvTest is SD59x18__BaseTest {
    function testCannotInv__Zero() external {
        SD59x18 x = ZERO;
        vm.expectRevert(stdError.divisionError);
        inv(x);
    }

    modifier NotZero() {
        _;
    }

    function negativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: 0 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: 0 }));
        sets.push(set({ x: -1e36 - 1, expected: 0 }));
        sets.push(set({ x: -1e36, expected: -1 }));
        sets.push(set({ x: -2503e18, expected: -0.000399520575309628e18 }));
        sets.push(set({ x: -772.05e18, expected: -0.001295252898128359e18 }));
        sets.push(set({ x: -100.135e18, expected: -0.00998651820042942e18 }));
        sets.push(set({ x: -22e18, expected: -0.045454545454545454e18 }));
        sets.push(set({ x: -4e18, expected: -0.25e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: -0.318309886183790671e18 }));
        sets.push(set({ x: -2e18, expected: -0.5e18 }));
        sets.push(set({ x: -1e18, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, expected: -10e18 }));
        sets.push(set({ x: -0.05e18, expected: -20e18 }));
        sets.push(set({ x: -0.00001e18, expected: -100_000e18 }));
        sets.push(set({ x: -1, expected: -1e36 }));
        return sets;
    }

    function testInv__Negative() external parameterizedTest(negativeSets()) NotZero {
        SD59x18 actual = inv(s.x);
        assertEq(actual, s.expected);
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, expected: 1e36 }));
        sets.push(set({ x: 0.00001e18, expected: 100_000e18 }));
        sets.push(set({ x: 0.05e18, expected: 20e18 }));
        sets.push(set({ x: 0.1e18, expected: 10e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, expected: 0.5e18 }));
        sets.push(set({ x: PI, expected: 0.318309886183790671e18 }));
        sets.push(set({ x: 4e18, expected: 0.25e18 }));
        sets.push(set({ x: 22e18, expected: 0.045454545454545454e18 }));
        sets.push(set({ x: 100.135e18, expected: 0.00998651820042942e18 }));
        sets.push(set({ x: 772.05e18, expected: 0.001295252898128359e18 }));
        sets.push(set({ x: 2503e18, expected: 0.000399520575309628e18 }));
        sets.push(set({ x: 1e36, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 1e36 + 1, expected: 0 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 0 }));
        sets.push(set({ x: MAX_SD59x18, expected: 0 }));
        return sets;
    }

    function testInv__Positive() external parameterizedTest(positiveSets()) NotZero {
        SD59x18 actual = inv(s.x);
        assertEq(actual, s.expected);
    }
}
