// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    SD59x18,
    SCALE,
    ZERO,
    fromSD59x18
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__FromTest is SD59x18__BaseTest {
    SD59x18 internal constant MIN_SD59x18_SCALED =
        SD59x18.wrap(-57896044618658097711785492504343953926634992332820282019728);
    SD59x18 internal constant MAX_SD59x18_SCALED =
        SD59x18.wrap(57896044618658097711785492504343953926634992332820282019728);

    function lessThanSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: -1e18 + 1 }));
        sets.push(set({ x: -1 }));
        sets.push(set({ x: ZERO }));
        sets.push(set({ x: 1 }));
        sets.push(set({ x: 1e18 - 1 }));
        return sets;
    }

    function testFrom__LessThanAbsoluteOne() external parameterizedTest(lessThanSets()) {
        int256 actual = fromSD59x18(s.x);
        int256 expected = 0;
        assertEq(actual, expected);
    }

    modifier GreaterThanOrEqualToAbsoluteOne() {
        _;
    }

    function greaterThanSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: MIN_SD59x18_SCALED }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: MIN_SD59x18_SCALED }));
        sets.push(set({ x: -4.2e45, expected: -42e26 }));
        sets.push(set({ x: -1729e18, expected: -1729 }));
        sets.push(set({ x: NEGATIVE_PI, expected: -3 }));
        sets.push(set({ x: NEGATIVE_E, expected: -2 }));
        sets.push(set({ x: -2e18, expected: -2 }));
        sets.push(set({ x: -2e18 + 1, expected: -1 }));
        sets.push(set({ x: -2e18 - 1, expected: -2 }));
        sets.push(set({ x: -1e18, expected: -1 }));
        sets.push(set({ x: 1e18, expected: 1 }));
        sets.push(set({ x: 1e18 + 1, expected: 1 }));
        sets.push(set({ x: 2e18 - 1, expected: 1 }));
        sets.push(set({ x: 2e18, expected: 2 }));
        sets.push(set({ x: E, expected: 2 }));
        sets.push(set({ x: PI, expected: 3 }));
        sets.push(set({ x: 1729e18, expected: 1729 }));
        sets.push(set({ x: 4.2e45, expected: 42e26 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: MAX_SD59x18_SCALED }));
        sets.push(set({ x: MAX_SD59x18, expected: MAX_SD59x18_SCALED }));
        return sets;
    }

    function testFrom() external parameterizedTest(greaterThanSets()) GreaterThanOrEqualToAbsoluteOne {
        int256 actual = fromSD59x18(s.x);
        int256 expected = SD59x18.unwrap(s.expected);
        assertEq(actual, expected);
    }
}
