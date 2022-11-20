// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import {
    E,
    MAX_WHOLE_UD60x18,
    MAX_UD60x18,
    PI,
    PRBMathUD60x18__LogInputTooSmall,
    UD60x18,
    ZERO,
    log2
} from "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__Log2Test is UD60x18__BaseTest {
    function lessThanOneSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: ZERO }));
        sets.push(set({ x: 0.0625e18 }));
        sets.push(set({ x: 1e18 - 1 }));
        return sets;
    }

    function testCannotLog2__LessThanOne() external parameterizedTest(lessThanOneSets()) {
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__LogInputTooSmall.selector, s.x));
        log2(s.x);
    }

    modifier GreaterThanOrEqualToOne() {
        _;
    }

    function powerOfTwoSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 2e18, expected: 1e18 }));
        sets.push(set({ x: 4e18, expected: 2e18 }));
        sets.push(set({ x: 8e18, expected: 3e18 }));
        sets.push(set({ x: 16e18, expected: 4e18 }));
        sets.push(set({ x: 2**195 * 10**18, expected: 195e18 }));
        return sets;
    }

    function testLog2__PowerOfTwo() external parameterizedTest(powerOfTwoSets()) GreaterThanOrEqualToOne {
        UD60x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }

    function notPowerOfTwoSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1.125e18, expected: 0.169925001442312346e18 }));
        sets.push(set({ x: E, expected: 1_442695040888963394 }));
        sets.push(set({ x: PI, expected: 1_651496129472318782 }));
        sets.push(set({ x: 1e24, expected: 19_931568569324174075 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 196_205294292027477728 }));
        sets.push(set({ x: MAX_UD60x18, expected: 196_205294292027477728 }));
        return sets;
    }

    function testLog2__NotPowerOfTwo() external parameterizedTest(notPowerOfTwoSets()) GreaterThanOrEqualToOne {
        UD60x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }
}
