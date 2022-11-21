// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    MAX_WHOLE_SD59x18,
    MIN_WHOLE_SD59x18,
    PRBMathSD59x18__ToSD59x18Underflow,
    PRBMathSD59x18__ToSD59x18Overflow,
    SD59x18,
    toSD59x18
} from "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__ToTest is SD59x18__BaseTest {
    function testCannotTo__LessThanMinPermitted() external {
        int256 x = SD59x18.unwrap(MIN_SCALED_SD59x18) - 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__ToSD59x18Underflow.selector, x));
        toSD59x18(x);
    }

    modifier GreaterThanMinPermitted() {
        _;
    }

    function testCannotTo__GreaterThanMaxPermitted() external GreaterThanMinPermitted {
        int256 x = SD59x18.unwrap(MAX_SCALED_SD59x18) + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__ToSD59x18Overflow.selector, x));
        toSD59x18(x);
    }

    modifier LessThanOrEqualToMaxPermitted() {
        _;
    }

    function toSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SCALED_SD59x18, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: -3.1415e42, expected: -3.1415e60 }));
        sets.push(set({ x: -2.7182e38, expected: -2.7182e56 }));
        sets.push(set({ x: -1e24, expected: -1e42 }));
        sets.push(set({ x: -5e18, expected: -5e36 }));
        sets.push(set({ x: -1e18, expected: -1e36 }));
        sets.push(set({ x: -0.000000000000001729e18, expected: -1729e18 }));
        sets.push(set({ x: -0.000000000000000002e18, expected: -2e18 }));
        sets.push(set({ x: -0.000000000000000001e18, expected: -1e18 }));
        sets.push(set({ x: 0.000000000000000001e18, expected: 1e18 }));
        sets.push(set({ x: 0.000000000000000002e18, expected: 2e18 }));
        sets.push(set({ x: 0.000000000000001729e18, expected: 1729e18 }));
        sets.push(set({ x: 1e18, expected: 1e36 }));
        sets.push(set({ x: 5e18, expected: 5e36 }));
        sets.push(set({ x: 2.7182e38, expected: 2.7182e56 }));
        sets.push(set({ x: 3.1415e42, expected: 3.1415e60 }));
        sets.push(set({ x: MAX_SCALED_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function testTo() external parameterizedTest(toSets()) GreaterThanMinPermitted LessThanOrEqualToMaxPermitted {
        SD59x18 x = toSD59x18(SD59x18.unwrap(s.x));
        assertEq(x, s.expected);
    }
}
