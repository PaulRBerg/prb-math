// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import {
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__DivInputTooSmall,
    PRBMathSD59x18__DivOverflow,
    SCALE,
    SD59x18,
    ZERO,
    div
} from "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__DivTest is SD59x18__BaseTest {
    SD59x18 internal constant MAX_SD59x18_DIV_BY_SCALE =
        SD59x18.wrap(57896044618658097711785492504343953926634_992332820282019728);
    SD59x18 internal constant MIN_SD59x18_DIV_BY_SCALE =
        SD59x18.wrap(-57896044618658097711785492504343953926634_992332820282019728);

    function testCannotDiv__DenominatorZero() external {
        SD59x18 x = sd(1);
        SD59x18 y = ZERO;
        vm.expectRevert(stdError.divisionError);
        div(x, y);
    }

    modifier DenominatorNotZero() {
        _;
    }

    function testCannotDiv__DenominatorMinSD59x18() external DenominatorNotZero {
        SD59x18 x = sd(1);
        SD59x18 y = MIN_SD59x18;
        vm.expectRevert(PRBMathSD59x18__DivInputTooSmall.selector);
        div(x, y);
    }

    modifier DenominatorNotMinSD59x18() {
        _;
    }

    function numeratorZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: NEGATIVE_PI, expected: 0 }));
        sets.push(set({ x: 0, y: -1e18, expected: 0 }));
        sets.push(set({ x: 0, y: -1, expected: 0 }));
        sets.push(set({ x: 0, y: 1, expected: 0 }));
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        return sets;
    }

    function testDiv__NumeratorZero()
        external
        parameterizedTest(numeratorZeroSets())
        DenominatorNotZero
        DenominatorNotMinSD59x18
    {
        SD59x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier NumeratorNotZero() {
        _;
    }

    function testCannotDiv__NumeratorMinSD59x18()
        external
        DenominatorNotZero
        DenominatorNotMinSD59x18
        NumeratorNotZero
    {
        SD59x18 x = MIN_SD59x18;
        SD59x18 y = sd(1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__DivInputTooSmall.selector));
        div(x, y);
    }

    modifier NumeratorNotMinSD59x18() {
        _;
    }

    function resultOverflowSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18_DIV_BY_SCALE.sub(sd(1)), y: 0.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: MAX_SD59x18_DIV_BY_SCALE.sub(sd(1)), y: 0.000000000000000001e18, expected: 0 }));
        return sets;
    }

    function testCannotDiv__ResultOverflow()
        external
        parameterizedTest(resultOverflowSets())
        DenominatorNotZero
        DenominatorNotMinSD59x18
        NumeratorNotZero
        NumeratorNotMinSD59x18
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__DivOverflow.selector, s.x, s.y));
        div(s.x, s.y);
    }

    modifier ResultNotOverflow() {
        _;
    }

    function numeratorDenominatorSameSignSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18_DIV_BY_SCALE, y: -0.000000000000000001e18, expected: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: -1e24, y: -1e18, expected: 1e24 }));
        sets.push(set({ x: -2503e18, y: -918882.11e18, expected: 0.002723962054283546e18 }));
        sets.push(set({ x: -772.05e18, y: -199.98e18, expected: 3_860636063606360636 }));
        sets.push(set({ x: -100.135e18, y: -100.134e18, expected: 1_000009986617931971 }));
        sets.push(set({ x: -22e18, y: -7e18, expected: 3_142857142857142857 }));
        sets.push(set({ x: -4e18, y: -2e18, expected: 2e18 }));
        sets.push(set({ x: -2e18, y: -5e18, expected: 4e17 }));
        sets.push(set({ x: -2e18, y: -2e18, expected: 1e18 }));
        sets.push(set({ x: -0.1e18, y: -0.01e18, expected: 1e19 }));
        sets.push(set({ x: -0.05e18, y: -0.02e18, expected: 25e17 }));
        sets.push(set({ x: -1e13, y: -0.00002e18, expected: 5e17 }));
        sets.push(set({ x: -1e13, y: -1e13, expected: 1e18 }));
        sets.push(set({ x: -0.000000000000000001e18, y: -1e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: -0.000000000000000001e18, y: -1.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: -0.000000000000000001e18, y: MIN_SD59x18.add(sd(1)), expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: MAX_SD59x18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: 1.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: 1e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 1e13, y: 1e13, expected: 1e18 }));
        sets.push(set({ x: 1e13, y: 0.00002e18, expected: 5e17 }));
        sets.push(set({ x: 0.05e18, y: 0.02e18, expected: 25e17 }));
        sets.push(set({ x: 0.1e18, y: 0.01e18, expected: 10e18 }));
        sets.push(set({ x: 2e18, y: 2e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 5e18, expected: 4e17 }));
        sets.push(set({ x: 4e18, y: 2e18, expected: 2e18 }));
        sets.push(set({ x: 22e18, y: 7e18, expected: 3_142857142857142857 }));
        sets.push(set({ x: 100.135e18, y: 100.134e18, expected: 1_000009986617931971 }));
        sets.push(set({ x: 772.05e18, y: 199.98e18, expected: 3_860636063606360636 }));
        sets.push(set({ x: 2503e18, y: 918882.11e18, expected: 0.002723962054283546e18 }));
        sets.push(set({ x: 1e24, y: 1e18, expected: 1e24 }));
        sets.push(set({ x: MAX_SD59x18_DIV_BY_SCALE, y: 1, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function testDiv__NumeratorDenominatorSameSign()
        external
        parameterizedTest(numeratorDenominatorSameSignSets())
        DenominatorNotZero
        DenominatorNotMinSD59x18
        NumeratorNotZero
        NumeratorNotMinSD59x18
        ResultNotOverflow
    {
        SD59x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function numeratorDenominatorDifferentSignSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18_DIV_BY_SCALE, y: 1, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: -1e24, y: 1e18, expected: -1e24 }));
        sets.push(set({ x: -2503e18, y: 918882.11e18, expected: -0.002723962054283546e18 }));
        sets.push(set({ x: -772.05e18, y: 199.98e18, expected: -3_860636063606360636 }));
        sets.push(set({ x: -100.135e18, y: 100.134e18, expected: -1_000009986617931971 }));
        sets.push(set({ x: -22e18, y: 7e18, expected: -3_142857142857142857 }));
        sets.push(set({ x: -4e18, y: 2e18, expected: -2e18 }));
        sets.push(set({ x: -2e18, y: 5e18, expected: -4e17 }));
        sets.push(set({ x: -2e18, y: 2e18, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, y: 0.01e18, expected: -1e19 }));
        sets.push(set({ x: -0.05e18, y: 0.02e18, expected: -25e17 }));
        sets.push(set({ x: -1e13, y: 2e13, expected: -5e17 }));
        sets.push(set({ x: -1e13, y: 1e13, expected: -1e18 }));
        sets.push(set({ x: -0.000000000000000001e18, y: 1e18, expected: -0.000000000000000001e18 }));
        sets.push(set({ x: -0.000000000000000001e18, y: 1.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: -0.000000000000000001e18, y: MAX_SD59x18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: MIN_SD59x18.add(sd(1)), expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: -1.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: -1e18, expected: -0.000000000000000001e18 }));
        sets.push(set({ x: 1e13, y: -1e13, expected: -1e18 }));
        sets.push(set({ x: 1e13, y: -2e13, expected: -5e17 }));
        sets.push(set({ x: 0.05e18, y: -0.02e18, expected: -25e17 }));
        sets.push(set({ x: 0.1e18, y: -0.01e18, expected: -10e18 }));
        sets.push(set({ x: 2e18, y: -2e18, expected: -1e18 }));
        sets.push(set({ x: 2e18, y: -5e18, expected: -4e17 }));
        sets.push(set({ x: 4e18, y: -2e18, expected: -2e18 }));
        sets.push(set({ x: 22e18, y: -7e18, expected: -3_142857142857142857 }));
        sets.push(set({ x: 100.135e18, y: -100.134e18, expected: -1_000009986617931971 }));
        sets.push(set({ x: 772.05e18, y: -199.98e18, expected: -3_860636063606360636 }));
        sets.push(set({ x: 2503e18, y: -918882.11e18, expected: -0.002723962054283546e18 }));
        sets.push(set({ x: 1e24, y: -1e18, expected: -1e24 }));
        sets.push(set({ x: MAX_SD59x18_DIV_BY_SCALE, y: 1, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function testDiv__NumeratorDenominatorDifferentSign()
        external
        parameterizedTest(numeratorDenominatorDifferentSignSets())
        DenominatorNotZero
        DenominatorNotMinSD59x18
        NumeratorNotZero
        NumeratorNotMinSD59x18
        ResultNotOverflow
    {
        SD59x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
