// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../../UD60x18BaseTest.t.sol";

contract UD60x18__Log10Test is UD60x18__BaseTest {
    function testCannotLog10__LessThanOne() external {
        UD60x18 x = ud(1e18 - 1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__LogInputTooSmall.selector, x));
        log10(x);
    }

    modifier GreaterThanOrEqualToOne() {
        _;
    }

    function powerOfTenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 10e18, expected: 1e18 }));
        sets.push(set({ x: 100e18, expected: 2e18 }));
        sets.push(set({ x: 1e24, expected: 6e18 }));
        sets.push(set({ x: 1e67, expected: 49e18 }));
        sets.push(set({ x: 1e75, expected: 57e18 }));
        sets.push(set({ x: 1e76, expected: 58e18 }));
        return sets;
    }

    function testLog10__PowerOfTen() external parameterizedTest(powerOfTenSets()) GreaterThanOrEqualToOne {
        UD60x18 actual = log10(s.x);
        assertEq(actual, s.expected);
    }

    function notPowerOfTenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1.00000000000001e18, expected: 0.000000000000004341e18 }));
        sets.push(set({ x: E, expected: 0.434294481903251823e18 }));
        sets.push(set({ x: PI, expected: 0.497149872694133849e18 }));
        sets.push(set({ x: 4e18, expected: 0.60205999132796239e18 }));
        sets.push(set({ x: 16e18, expected: 1_204119982655924781 }));
        sets.push(set({ x: 32e18, expected: 1_505149978319905976 }));
        sets.push(set({ x: 42.12e18, expected: 1_624488362513448905 }));
        sets.push(set({ x: 1010.892143e18, expected: 3_004704821071980110 }));
        sets.push(set({ x: 440934.1881e18, expected: 5_644373773418177966 }));
        sets.push(set({ x: 1000000000000000000.000000000001e18, expected: 17_999999999999999999 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 59_063678889979185987 }));
        sets.push(set({ x: MAX_UD60x18, expected: 59_063678889979185987 }));
        return sets;
    }

    function testLog10__NotPowerOfTen() external parameterizedTest(notPowerOfTenSets()) GreaterThanOrEqualToOne {
        UD60x18 actual = log10(s.x);
        assertEq(actual, s.expected);
    }
}
