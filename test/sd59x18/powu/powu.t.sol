// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__Exp2InputTooBig,
    PRBMathSD59x18__LogInputTooSmall,
    PRBMathSD59x18__PowuOverflow,
    SD59x18,
    ZERO,
    powu
} from "~/SD59x18.sol";
import { PRBMath__MulDiv18Overflow } from "~/Helpers.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__PowuTest is SD59x18__BaseTest {
    SD59x18 internal constant SQRT_MAX_SD59x18 = SD59x18.wrap(240615969168004511545033772477_625056927114980741);
    SD59x18 internal constant SQRT_MIN_SD59x18 = SD59x18.wrap(-240615969168004511545033772477_625056927114980741);

    function testPowu__BaseAndExponentZero() external {
        SD59x18 x = ZERO;
        uint256 y = 0;
        SD59x18 actual = powu(x, y);
        SD59x18 expected = sd(1e18);
        assertEq(actual, expected);
    }

    function baseZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: E, expected: 0 }));
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        return sets;
    }

    function testPowu__BaseZeroExponentNotZero() external parameterizedTest(baseZeroSets()) {
        SD59x18 actual = powu(s.x, sdToU(s.y));
        assertEq(actual, s.expected);
    }

    modifier BaseNotZero() {
        _;
    }

    function exponentZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.uncheckedAdd(sd(1)), expected: 1e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: 1e18 }));
        sets.push(set({ x: -1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: PI, expected: 1e18 }));
        sets.push(set({ x: MAX_SD59x18.uncheckedSub(sd(1)), expected: 1e18 }));
        return sets;
    }

    function testPowu__ExponentZero() external parameterizedTest(exponentZeroSets()) BaseNotZero {
        SD59x18 actual = powu(s.x, sdToU(s.y));
        assertEq(actual, s.expected);
    }

    modifier ExponentNotZero() {
        _;
    }

    function overflowSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.uncheckedAdd(sd(1)), y: 2, expected: 0 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, y: 2, expected: 0 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, y: 2, expected: 0 }));
        sets.push(set({ x: MAX_SD59x18, y: 2, expected: 0 }));
        return sets;
    }

    function testPowu__ResultOverflowUint256() external parameterizedTest(overflowSets()) BaseNotZero ExponentNotZero {
        vm.expectRevert(
            abi.encodeWithSelector(PRBMath__MulDiv18Overflow.selector, sdToU(MAX_SD59x18), sdToU(MAX_SD59x18))
        );
        powu(s.x, sdToU(s.y));
    }

    modifier ResultDoesNotOverflowOrUnderflowUint256() {
        _;
    }

    function overflowOrUnderflowSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: SQRT_MIN_SD59x18.uncheckedSub(sd(1)), y: 2, expected: 0 }));
        sets.push(set({ x: -38685626227668133590.597632e18, y: 3, expected: 0 }));
        sets.push(set({ x: 38685626227668133590.597632e18, y: 3, expected: 0 }));
        sets.push(set({ x: SQRT_MAX_SD59x18.uncheckedAdd(sd(1)), y: 2, expected: 0 }));
        return sets;
    }

    function testPowu__ResultOverflowOrUnderflowSd59x18()
        external
        parameterizedTest(overflowOrUnderflowSets())
        BaseNotZero
        ExponentNotZero
        ResultDoesNotOverflowOrUnderflowUint256
    {
        if (s.x.eq(SQRT_MIN_SD59x18.uncheckedSub(sd(1)))) {
            vm.expectRevert(
                abi.encodeWithSelector(
                    PRBMathSD59x18__PowuOverflow.selector,
                    57896044618658097711785492504343953926634992333271124942194_363391669063698216
                )
            );
        } else {
            vm.expectRevert(
                abi.encodeWithSelector(PRBMathSD59x18__PowuOverflow.selector, MAX_SD59x18.uncheckedAdd(sd(1)))
            );
        }

        powu(s.x, sdToU(s.y));
    }

    modifier ResultDoesNotOverflowSd59x18() {
        _;
    }

    function powuSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.uncheckedAdd(sd(1)), y: 1, expected: MIN_SD59x18.uncheckedAdd(sd(1)) }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, y: 1, expected: MIN_WHOLE_SD59x18 }));
        sets.push(
            set({
                x: SQRT_MIN_SD59x18,
                y: 2,
                expected: 57896044618658097711785492504343953926634992332789893003858_354368578996153260
            })
        );
        sets.push(
            set({
                x: -38685626227668133590.597631999999999999e18,
                y: 3,
                expected: -57896044618658097711785492504343953922145259302939748255014_626107971862774100
            })
        );
        sets.push(set({ x: -1e36, y: 3, expected: -1e72 }));
        sets.push(set({ x: -6452.166e18, y: 7, expected: -4655204093726194074224341678_62736844121311696 }));
        sets.push(
            set({
                x: -478.77e18,
                y: 20,
                expected: 400441047687151121501368529571950234763284476825512183_793320584974037932
            })
        );
        sets.push(set({ x: -100e18, y: 4, expected: 1e26 }));
        sets.push(set({ x: -5.491e18, y: 19, expected: -113077820843204_476043049664958629 }));
        sets.push(set({ x: NEGATIVE_E, y: 2, expected: 7_389056098930650225 }));
        sets.push(set({ x: NEGATIVE_PI, y: 3, expected: -31_006276680299820162 }));
        sets.push(set({ x: -2e18, y: 100, expected: 1267650600228_229401496703205376e18 }));
        sets.push(set({ x: -2e18, y: 5, expected: -32e18 }));
        sets.push(set({ x: -1e18, y: 1, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, y: 2, expected: 1e16 }));
        sets.push(set({ x: -0.001e18, y: 3, expected: -1e9 }));
        sets.push(set({ x: 0.001e18, y: 3, expected: 1e9 }));
        sets.push(set({ x: 0.1e18, y: 2, expected: 1e16 }));
        sets.push(set({ x: 1e18, y: 1, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 5, expected: 32e18 }));
        sets.push(set({ x: 2e18, y: 100, expected: 1267650600228_229401496703205376e18 }));
        sets.push(set({ x: E, y: 2, expected: 7_389056098930650225 }));
        sets.push(set({ x: PI, y: 3, expected: 31_006276680299820162 }));
        sets.push(set({ x: 5.491e18, y: 19, expected: 113077820843204_476043049664958629 }));
        sets.push(set({ x: 100e18, y: 4, expected: 1e26 }));
        sets.push(
            set({
                x: 478.77e18,
                y: 20,
                expected: 400441047687151121501368529571950234763284476825512183_793320584974037932
            })
        );
        sets.push(set({ x: 6452.166e18, y: 7, expected: 4655204093726194074224341678_62736844121311696 }));
        sets.push(set({ x: 1e36, y: 3, expected: 1e72 }));
        sets.push(
            set({
                x: 38685626227668133590.597631999999999999e18,
                y: 3,
                expected: 57896044618658097711785492504343953922145259302939748255014_626107971862774100
            })
        );
        sets.push(
            set({
                x: SQRT_MAX_SD59x18,
                y: 2,
                expected: 57896044618658097711785492504343953926634992332789893003858_354368578996153260
            })
        );
        sets.push(set({ x: MAX_WHOLE_SD59x18, y: 1, expected: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18, y: 1, expected: MAX_SD59x18 }));
        return sets;
    }

    function testPowu()
        external
        parameterizedTest(powuSets())
        BaseNotZero
        ExponentNotZero
        ResultDoesNotOverflowOrUnderflowUint256
        ResultDoesNotOverflowSd59x18
    {
        SD59x18 actual = powu(s.x, sdToU(s.y));
        assertEq(actual, s.expected);
    }

    /// @dev Helper function to convert a `SD59x18` to `uint256`.
    function sdToU(SD59x18 x) internal pure returns (uint256 result) {
        result = uint256(SD59x18.unwrap(x));
    }
}
