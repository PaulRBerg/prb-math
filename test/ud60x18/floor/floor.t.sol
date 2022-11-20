// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI, UD60x18, ZERO, floor } from "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__FloorTest is UD60x18__BaseTest {
    function testFloor__Zero() external {
        UD60x18 x = ZERO;
        UD60x18 actual = floor(x);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function floorSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0 }));
        sets.push(set({ x: 0.5e18, expected: 0 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 3e18 }));
        sets.push(set({ x: 4.2e18, expected: 4e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        sets.push(set({ x: MAX_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        return sets;
    }

    function testFloor__Positive() external parameterizedTest(floorSets()) NotZero {
        UD60x18 actual = floor(s.x);
        assertEq(actual, s.expected);
    }
}
