// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__CeilTest is UD60x18__BaseTest {
    function testCeil__Zero() external {
        UD60x18 x = ZERO;
        UD60x18 actual = ceil(x);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function testCannotCeil__GreaterThanMaxPermitted() external NotZero {
        UD60x18 x = MAX_WHOLE_UD60x18.add(ud(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__CeilOverflow.selector, x));
        ceil(x);
    }

    modifier LessThanOrEqualToMaxWholeUD60x18() {
        _;
    }

    function ceilSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 1e18 }));
        sets.push(set({ x: 0.5e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 2e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 4e18 }));
        sets.push(set({ x: 4.2e18, expected: 5e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        return sets;
    }

    function testCeil() external parameterizedTest(ceilSets()) NotZero LessThanOrEqualToMaxWholeUD60x18 {
        UD60x18 actual = ceil(s.x);
        assertEq(actual, s.expected);
    }
}
