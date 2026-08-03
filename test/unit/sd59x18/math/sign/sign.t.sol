// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { MAX_SD59x18, MIN_SD59x18, PI, ZERO } from "src/sd59x18/Constants.sol";
import { sign } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Unit_Test } from "../../SD59x18.t.sol";

contract Sign_Unit_Test is SD59x18_Unit_Test {
    function test_Sign_Zero() external pure {
        SD59x18 x = ZERO;
        SD59x18 actual = sign(x);
        assertEq(actual, ZERO, "SD59x18 sign zero");
    }

    function negativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: -1e18 }));
        sets.push(set({ x: -4.2e18, expected: -1e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: -1e18 }));
        sets.push(set({ x: -1e18, expected: -1e18 }));
        sets.push(set({ x: -0.5e18, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, expected: -1e18 }));
        return sets;
    }

    function test_Sign_Negative() external parameterizedTest(negativeSets()) {
        SD59x18 actual = sign(s.x);
        assertEq(actual, s.expected, "SD59x18 sign negative");
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 1e18 }));
        sets.push(set({ x: 0.5e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: PI, expected: 1e18 }));
        sets.push(set({ x: 4.2e18, expected: 1e18 }));
        sets.push(set({ x: MAX_SD59x18, expected: 1e18 }));
        return sets;
    }

    function test_Sign_Positive() external parameterizedTest(positiveSets()) {
        SD59x18 actual = sign(s.x);
        assertEq(actual, s.expected, "SD59x18 sign positive");
    }
}
