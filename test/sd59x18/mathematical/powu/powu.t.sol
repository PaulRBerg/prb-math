// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/SD59x18.sol";
import { PRBMath_MulDiv18Overflow } from "src/Core.sol";
import { SD59x18_Test } from "../../SD59x18.t.sol";

contract Powu_Test is SD59x18_Test {
    function test_Powu_BaseAndExponentZero() external {
        SD59x18 x = ZERO;
        uint256 y = 0;
        SD59x18 actual = powu(x, y);
        SD59x18 expected = sd(1e18);
        assertEq(actual, expected);
    }

    function baseZeroExponentNotZero_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: 2, expected: 0 }));
        sets.push(set({ x: 0, y: 3, expected: 0 }));
        return sets;
    }

    function test_Powu_BaseZeroExponentNotZero() external parameterizedTest(baseZeroExponentNotZero_Sets()) {
        SD59x18 actual = powu(s.x, sdToUint(s.y));
        assertEq(actual, s.expected);
    }

    modifier BaseNotZero() {
        _;
    }

    function exponentZero_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(1)), expected: 1e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: 1e18 }));
        sets.push(set({ x: -1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: PI, expected: 1e18 }));
        sets.push(set({ x: MAX_SD59x18.sub(sd(1)), expected: 1e18 }));
        return sets;
    }

    function test_Powu_ExponentZero() external parameterizedTest(exponentZero_Sets()) BaseNotZero {
        SD59x18 actual = powu(s.x, sdToUint(s.y));
        assertEq(actual, s.expected);
    }

    modifier ExponentNotZero() {
        _;
    }

    function test_RevertWhen_ResultOverflowUint256() external BaseNotZero ExponentNotZero {
        SD59x18 x = MIN_SD59x18.add(sd(1));
        uint256 y = 2;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv18Overflow.selector, uint256(uMAX_SD59x18), uint256(uMAX_SD59x18)));
        powu(x, y);
    }

    modifier ResultDoesNotOverflowUint256() {
        _;
    }

    function test_RevertWhen_ResultUnderflowSD59x18() external BaseNotZero ExponentNotZero ResultDoesNotOverflowUint256 {
        SD59x18 x = NEGATIVE_SQRT_MAX_SD59x18.sub(sd(1));
        uint256 y = 2;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_PowuOverflow.selector, x, y));
        powu(x, y);
    }

    function test_RevertWhen_ResultOverflowSD59x18() external BaseNotZero ExponentNotZero ResultDoesNotOverflowUint256 {
        SD59x18 x = SQRT_MAX_SD59x18.add(sd(1));
        uint256 y = 2;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_PowuOverflow.selector, x, y));
        powu(x, y);
    }

    modifier ResultDoesNotOverflowOrUnderflowSD59x18() {
        _;
    }

    function negativeBase_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(1)), y: 1, expected: MIN_SD59x18.add(sd(1)) }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, y: 1, expected: MIN_WHOLE_SD59x18 }));
        sets.push(
            set({
                x: NEGATIVE_SQRT_MAX_SD59x18,
                y: 2,
                expected: 57896044618658097711785492504343953926634992332789893003858_354368578996153260
            })
        );
        sets.push(
            set({
                x: -38685626227668133590.597631999999999999e18,
                y: 3,
                expected: -57896044618658097711785492504343953922145259302939748254975_940481744194640509
            })
        );
        sets.push(set({ x: -1e24, y: 3, expected: -1e36 }));
        sets.push(set({ x: -6452.166e18, y: 7, expected: -4655204093726194074224341678_62736844121311696 }));
        sets.push(
            set({ x: -478.77e18, y: 20, expected: 400441047687151121501368529571950234763284476825512183_793320584974037932 })
        );
        sets.push(set({ x: -100e18, y: 4, expected: 1e26 }));
        sets.push(set({ x: -5.491e18, y: 19, expected: -113077820843204_476043049664958463 }));
        sets.push(set({ x: NEGATIVE_E, y: 2, expected: 7_389056098930650225 }));
        sets.push(set({ x: NEGATIVE_PI, y: 3, expected: -31_006276680299820158 }));
        sets.push(set({ x: -2e18, y: 100, expected: 1267650600228_229401496703205376e18 }));
        sets.push(set({ x: -2e18, y: 5, expected: -32e18 }));
        sets.push(set({ x: -1e18, y: 1, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, y: 2, expected: 0.01e18 }));
        sets.push(set({ x: -0.001e18, y: 3, expected: -0.000000001e18 }));
        return sets;
    }

    function test_Powu_NegativeBase()
        external
        parameterizedTest(negativeBase_Sets())
        BaseNotZero
        ExponentNotZero
        ResultDoesNotOverflowUint256
        ResultDoesNotOverflowOrUnderflowSD59x18
    {
        SD59x18 actual = powu(s.x, sdToUint(s.y));
        assertEq(actual, s.expected);
    }

    function positiveBase_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.001e18, y: 3, expected: 1e9 }));
        sets.push(set({ x: 0.1e18, y: 2, expected: 1e16 }));
        sets.push(set({ x: 1e18, y: 1, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 5, expected: 32e18 }));
        sets.push(set({ x: 2e18, y: 100, expected: 1267650600228_229401496703205376e18 }));
        sets.push(set({ x: E, y: 2, expected: 7_389056098930650225 }));
        sets.push(set({ x: PI, y: 3, expected: 31_006276680299820158 }));
        sets.push(set({ x: 5.491e18, y: 19, expected: 113077820843204_476043049664958463 }));
        sets.push(set({ x: 100e18, y: 4, expected: 1e26 }));
        sets.push(
            set({ x: 478.77e18, y: 20, expected: 400441047687151121501368529571950234763284476825512183_793320584974037932 })
        );
        sets.push(set({ x: 6452.166e18, y: 7, expected: 4655204093726194074224341678_62736844121311696 }));
        sets.push(set({ x: 1e24, y: 3, expected: 1e36 }));
        sets.push(
            set({
                x: 38685626227668133590.597631999999999999e18,
                y: 3,
                expected: 57896044618658097711785492504343953922145259302939748254975_940481744194640509
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

    function test_Powu_PositiveBase()
        external
        parameterizedTest(positiveBase_Sets())
        BaseNotZero
        ExponentNotZero
        ResultDoesNotOverflowUint256
        ResultDoesNotOverflowOrUnderflowSD59x18
    {
        SD59x18 actual = powu(s.x, sdToUint(s.y));
        assertEq(actual, s.expected);
    }
}
