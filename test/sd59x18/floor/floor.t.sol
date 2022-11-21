// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__FloorUnderflow,
    MIN_WHOLE_SD59x18,
    SD59x18,
    ZERO,
    floor
} from "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__FloorTest is SD59x18__BaseTest {
    function testFloor__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = floor(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function testCannotFloor__Negative__LessThanMinPermitted() external NotZero {
        SD59x18 x = MIN_WHOLE_SD59x18.sub(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__FloorUnderflow.selector, x));
        floor(x);
    }

    function negativeAndGreaterThanOrEqualToMinPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: -1e24, expected: -1e24 }));
        sets.push(set({ x: -4.2e18, expected: -5e18 }));
        sets.push(set({ x: -2e18, expected: -2e18 }));
        sets.push(set({ x: -1.125e18, expected: -2e18 }));
        sets.push(set({ x: -1e18, expected: -1e18 }));
        sets.push(set({ x: -0.5e18, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, expected: -1e18 }));
        return sets;
    }

    function testFloor__Negative__GreaterThanOrEqualToMinPermitted()
        external
        parameterizedTest(negativeAndGreaterThanOrEqualToMinPermittedSets())
        NotZero
    {
        SD59x18 actual = floor(s.x);
        assertEq(actual, s.expected);
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0 }));
        sets.push(set({ x: 0.5e18, expected: 0 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 3e18 }));
        sets.push(set({ x: 4.2e18, expected: 4e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function testFloor__Positive() external parameterizedTest(positiveSets()) NotZero {
        SD59x18 actual = floor(s.x);
        assertEq(actual, s.expected);
    }
}
