// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/SD59x18.sol";
import { SD59x18_Test } from "../../SD59x18.t.sol";

contract ConvertFrom_Test is SD59x18_Test {
    function lessThanAbsoluteOne_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: -1e18 + 1 }));
        sets.push(set({ x: -1 }));
        sets.push(set({ x: ZERO }));
        sets.push(set({ x: 1 }));
        sets.push(set({ x: 1e18 - 1 }));
        return sets;
    }

    function test_ConvertFrom_LessThanAbsoluteOne() external parameterizedTest(lessThanAbsoluteOne_Sets()) {
        int256 actual = fromSD59x18(s.x);
        int256 expected = 0;
        assertEq(actual, expected);
    }

    modifier greaterThanOrEqualToAbsoluteOne() {
        _;
    }

    function greaterThanAbsoluteOne_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: MIN_SCALED_SD59x18 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: MIN_SCALED_SD59x18 }));
        sets.push(set({ x: -4.2e45, expected: -4.2e27 }));
        sets.push(set({ x: -1729e18, expected: -0.000000000000001729e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: -0.000000000000000003e18 }));
        sets.push(set({ x: NEGATIVE_E, expected: -0.000000000000000002e18 }));
        sets.push(set({ x: -2e18 - 1, expected: -0.000000000000000002e18 }));
        sets.push(set({ x: -2e18, expected: -0.000000000000000002e18 }));
        sets.push(set({ x: -2e18 + 1, expected: -0.000000000000000001e18 }));
        sets.push(set({ x: -1e18, expected: -0.000000000000000001e18 }));
        sets.push(set({ x: 1e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 1e18 + 1, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 2e18 - 1, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 2e18, expected: 0.000000000000000002e18 }));
        sets.push(set({ x: 2e18 + 1, expected: 0.000000000000000002e18 }));
        sets.push(set({ x: E, expected: 0.000000000000000002e18 }));
        sets.push(set({ x: PI, expected: 0.000000000000000003e18 }));
        sets.push(set({ x: 1729e18, expected: 0.000000000000001729e18 }));
        sets.push(set({ x: 4.2e45, expected: 4.2e27 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: MAX_SCALED_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18, expected: MAX_SCALED_SD59x18 }));
        return sets;
    }

    function test_ConvertFrom() external parameterizedTest(greaterThanAbsoluteOne_Sets()) greaterThanOrEqualToAbsoluteOne {
        int256 actual = fromSD59x18(s.x);
        int256 expected = SD59x18.unwrap(s.expected);
        assertEq(actual, expected);
    }
}
