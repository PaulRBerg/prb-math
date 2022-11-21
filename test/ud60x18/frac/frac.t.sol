// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__FracTest is UD60x18__BaseTest {
    function testFrac__Zero() external {
        UD60x18 x = ZERO;
        UD60x18 actual = frac(x);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function fracSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0.1e18 }));
        sets.push(set({ x: 0.5e18, expected: 0.5e18 }));
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 1.125e18, expected: 0.125e18 }));
        sets.push(set({ x: 2e18, expected: 0 }));
        sets.push(set({ x: PI, expected: 0.141592653589793238e18 }));
        sets.push(set({ x: 4.2e18, expected: 0.2e18 }));
        sets.push(set({ x: 1e24, expected: 0 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 0 }));
        sets.push(set({ x: MAX_UD60x18, expected: 0.584007913129639935e18 }));
        return sets;
    }

    function testFrac() external parameterizedTest(fracSets()) NotZero {
        UD60x18 actual = frac(s.x);
        assertEq(actual, s.expected);
    }
}
