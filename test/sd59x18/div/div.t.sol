// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import { PRBMath__MulDivOverflow } from "~/Helpers.sol";
import {
    MAX_SD59x18,
    MAX_SD59x18_INT,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_SD59x18_INT,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__DivInputTooSmall,
    PRBMathSD59x18__DivOverflow,
    SCALE,
    SCALE_INT,
    SD59x18,
    ZERO,
    div
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__DivTest is SD59x18__BaseTest {
    function testDiv__DenomitorZero() external {
        SD59x18 x = sd(1);
        SD59x18 y = ZERO;
        vm.expectRevert();
        div(x, y);
    }

    modifier DenominatorNotZero() {
        _;
    }

    function testDiv__DenomitorMin() external DenominatorNotZero {
        SD59x18 x = sd(1);
        SD59x18 y = MIN_SD59x18;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__DivInputTooSmall.selector));
        div(x, y);
    }

    modifier DenominatorNotMin() {
        _;
    }

    function numeratorZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: -1e36, expected: ZERO }));
        sets.push(set({ x: -3.141592653589793238e18, expected: ZERO }));
        sets.push(set({ x: -1e18, expected: ZERO }));
        sets.push(set({ x: -1, expected: ZERO }));
        sets.push(set({ x: 1, expected: ZERO }));
        sets.push(set({ x: 1e18, expected: ZERO }));
        sets.push(set({ x: PI, expected: ZERO }));
        sets.push(set({ x: 1e36, expected: ZERO }));
        return sets;
    }

    function testDiv__NumeratorZero()
        external
        parameterizedTest(numeratorZeroSets())
        DenominatorNotZero
        DenominatorNotMin
    {
        SD59x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier NumeratorNotZero() {
        _;
    }

    function testDiv__NumeratorMin() external DenominatorNotZero DenominatorNotMin NumeratorNotZero {
        SD59x18 x = MIN_SD59x18;
        SD59x18 y = sd(1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__DivInputTooSmall.selector));
        div(x, y);
    }

    modifier NumeratorNotMin() {
        _;
    }

    function resultOverflowSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: sd(MIN_SD59x18_INT / SCALE_INT).uncheckedSub(sd(1)), y: 1, expected: ZERO }));
        sets.push(set({ x: sd(MIN_SD59x18_INT / SCALE_INT).uncheckedSub(sd(1)), y: 1, expected: ZERO }));
        sets.push(set({ x: sd(MAX_SD59x18_INT / SCALE_INT).uncheckedAdd(sd(1)), y: 1, expected: ZERO }));
        sets.push(set({ x: sd(MAX_SD59x18_INT / SCALE_INT).uncheckedAdd(sd(1)), y: 1, expected: ZERO }));
        return sets;
    }

    function testDiv__ResultOverflow()
        external
        parameterizedTest(resultOverflowSets())
        DenominatorNotZero
        DenominatorNotMin
        NumeratorNotZero
        NumeratorNotMin
    {
        vm.expectRevert(
            abi.encodeWithSelector(
                PRBMathSD59x18__DivOverflow.selector,
                57896044618658097711785492504343953926634992332820282019729_000000000000000000
            )
        );
        div(s.x, s.y);
    }

    modifier NotOverflow() {
        _;
    }

    function numeratorDenominatorSameSignSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(
            set({
                x: -57896044618658097711785492504343953926634.992332820282019728e18,
                y: -1,
                expected: MAX_WHOLE_SD59x18
            })
        );
        sets.push(set({ x: -1e36, y: -1e18, expected: 1e36 }));
        sets.push(set({ x: -2503e18, y: -918882.11e18, expected: 2723962054283546 }));
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
        sets.push(set({ x: -1, y: -1e18, expected: 1 }));
        sets.push(set({ x: -1, y: -1.000000000000000001e18, expected: ZERO }));
        sets.push(set({ x: -1, y: MIN_SD59x18.uncheckedAdd(sd(1)), expected: ZERO }));
        sets.push(set({ x: 1, y: MAX_SD59x18, expected: ZERO }));
        sets.push(set({ x: 1, y: 1.000000000000000001e18, expected: ZERO }));
        sets.push(set({ x: 1, y: 1e18, expected: 1 }));
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
        sets.push(set({ x: 2503e18, y: 918882.11e18, expected: 2723962054283546 }));
        sets.push(set({ x: 1e36, y: 1e18, expected: 1e36 }));
        sets.push(
            set({
                x: 57896044618658097711785492504343953926634.992332820282019728e18,
                y: 1,
                expected: MAX_WHOLE_SD59x18
            })
        );
        return sets;
    }

    function testDiv__SameSign()
        external
        parameterizedTest(numeratorDenominatorSameSignSets())
        DenominatorNotZero
        DenominatorNotMin
        NumeratorNotZero
        NumeratorNotMin
        NotOverflow
    {
        SD59x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function numeratorDenominatorDifferentSignSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(
            set({
                x: -57896044618658097711785492504343953926634.992332820282019728e18,
                y: 1,
                expected: MIN_WHOLE_SD59x18
            })
        );
        sets.push(set({ x: -1e36, y: 1e18, expected: -1e36 }));
        sets.push(set({ x: -2503e18, y: 918882.11e18, expected: -2723962054283546 }));
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
        sets.push(set({ x: -1, y: 1e18, expected: -1 }));
        sets.push(set({ x: -1, y: 1.000000000000000001e18, expected: ZERO }));
        sets.push(set({ x: -1, y: MAX_SD59x18, expected: ZERO }));
        sets.push(set({ x: 1, y: MIN_SD59x18.uncheckedAdd(sd(1)), expected: ZERO }));
        sets.push(set({ x: 1, y: -1.000000000000000001e18, expected: ZERO }));
        sets.push(set({ x: 1, y: -1e18, expected: -1 }));
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
        sets.push(set({ x: 2503e18, y: -918882.11e18, expected: -2723962054283546 }));
        sets.push(set({ x: 1e36, y: -1e18, expected: -1e36 }));
        sets.push(
            set({
                x: 57896044618658097711785492504343953926634.992332820282019728e18,
                y: 1,
                expected: MAX_WHOLE_SD59x18
            })
        );
        return sets;
    }

    function testDiv__DifferentSign()
        external
        parameterizedTest(numeratorDenominatorSameSignSets())
        DenominatorNotZero
        DenominatorNotMin
        NumeratorNotZero
        NumeratorNotMin
        NotOverflow
    {
        SD59x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
