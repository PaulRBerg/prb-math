// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_WHOLE_SD59x18,
    MAX_SD59x18,
    PI,
    PRBMathSD59x18__LogInputTooSmall,
    SD59x18,
    ZERO,
    ln
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__LnTest is SD59x18__BaseTest {
    function testLn__Zero() external {
        SD59x18 x = ZERO;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        ln(x);
    }

    modifier NotZero() {
        _;
    }

    function testLn__Negative() external NotZero {
        SD59x18 x = sd(-1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        ln(x);
    }

    modifier Positive() {
        _;
    }

    function positiveSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: -2_302585092994045674 }));
        sets.push(set({ x: 0.2e18, expected: -1_609437912434100365 }));
        sets.push(set({ x: 0.3e18, expected: -1_203972804325935984 }));
        sets.push(set({ x: 0.4e18, expected: -916290731874155055 }));
        sets.push(set({ x: 0.5e18, expected: -693147180559945309 }));
        sets.push(set({ x: 0.6e18, expected: -510825623765990674 }));
        sets.push(set({ x: 0.7e18, expected: -356674943938732371 }));
        sets.push(set({ x: 0.8e18, expected: -223143551314209746 }));
        sets.push(set({ x: 0.9e18, expected: -105360515657826292 }));
        sets.push(set({ x: 1e18, expected: ZERO }));
        sets.push(set({ x: 1.125e18, expected: 117783035656383442 }));
        sets.push(set({ x: 2e18, expected: 693147180559945309 }));
        sets.push(set({ x: E, expected: 999999999999999990 }));
        sets.push(set({ x: PI, expected: 1_144729885849400163 }));
        sets.push(set({ x: 4e18, expected: 1_386294361119890619 }));
        sets.push(set({ x: 8e18, expected: 2_079441541679835928 }));
        sets.push(set({ x: 1e36, expected: 41_446531673892822311 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 135_305999368893231615 }));
        sets.push(set({ x: MAX_SD59x18, expected: 135_305999368893231615 }));
        return sets;
    }

    function testLn() external parameterizedTest(positiveSets()) NotZero Positive {
        SD59x18 actual = ln(s.x);
        assertEq(actual, s.expected);
    }
}
