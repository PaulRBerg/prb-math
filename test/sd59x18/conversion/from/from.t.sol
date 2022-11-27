// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../../SD59x18BaseTest.t.sol";

contract SD59x18__FromTest is SD59x18__BaseTest {
    function lessThanAbsoluteOneSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: -1e18 + 1 }));
        sets.push(set({ x: -1 }));
        sets.push(set({ x: ZERO }));
        sets.push(set({ x: 1 }));
        sets.push(set({ x: 1e18 - 1 }));
        return sets;
    }

    function testFrom__LessThanAbsoluteOne() external parameterizedTest(lessThanAbsoluteOneSets()) {
        int256 actual = fromSD59x18(s.x);
        int256 expected = 0;
        assertEq(actual, expected);
    }

    modifier GreaterThanOrEqualToAbsoluteOne() {
        _;
    }

    function greaterThanAbsoluteOneSets() internal returns (Set[] memory) {
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

    function testFrom() external parameterizedTest(greaterThanAbsoluteOneSets()) GreaterThanOrEqualToAbsoluteOne {
        int256 actual = fromSD59x18(s.x);
        int256 expected = SD59x18.unwrap(s.expected);
        assertEq(actual, expected);
    }
}
