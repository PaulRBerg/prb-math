// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__GmTest is SD59x18__BaseTest {
    // Greatest number whose non-fixed-point square fits within int256
    SD59x18 internal constant SQRT_MAX_INT256 = SD59x18.wrap(240615969168004511545_033772477625056927);
    // Smallest number whose non-fixed-point square fits within int256
    SD59x18 internal constant NEGATIVE_SQRT_MAX_INT256 = SD59x18.wrap(-240615969168004511545033772477625056927);

    function oneOperandZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        sets.push(set({ x: PI, y: 0, expected: 0 }));
        return sets;
    }

    function testGm__OneOperandZero() external parameterizedTest(oneOperandZeroSets()) {
        SD59x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier NotZeroOperands() {
        _;
    }

    function testCannotGm__ProductNegative__1() external NotZeroOperands {
        SD59x18 x = sd(-1e18);
        SD59x18 y = PI;
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmNegativeProduct.selector, x, y));
        gm(x, y);
    }

    function testCannotGm__ProductNegative__2() external NotZeroOperands {
        SD59x18 x = PI;
        SD59x18 y = sd(-1e18);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmNegativeProduct.selector, x, y));
        gm(x, y);
    }

    modifier PositiveProduct() {
        _;
    }

    function testCannotGm__ProductOverflow__1() external NotZeroOperands PositiveProduct {
        SD59x18 x = MIN_SD59x18;
        SD59x18 y = wrap(0.000000000000000002e18);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmOverflow.selector, x, y));
        gm(x, y);
    }

    function testCannotGm__ProductOverflow__2() external NotZeroOperands PositiveProduct {
        SD59x18 x = NEGATIVE_SQRT_MAX_INT256;
        SD59x18 y = NEGATIVE_SQRT_MAX_INT256.sub(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmOverflow.selector, x, y));
        gm(x, y);
    }

    function testCannotGm__ProductOverflow__3() external NotZeroOperands PositiveProduct {
        SD59x18 x = SQRT_MAX_INT256.add(sd(1));
        SD59x18 y = SQRT_MAX_INT256.add(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmOverflow.selector, x, y));
        gm(x, y);
    }

    function testCannotGm__ProductOverflow__4() external NotZeroOperands PositiveProduct {
        SD59x18 x = MAX_SD59x18;
        SD59x18 y = wrap(0.000000000000000002e18);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmOverflow.selector, x, y));
        gm(x, y);
    }

    modifier ProductNotOverflow() {
        _;
    }

    function gmSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_WHOLE_SD59x18, y: -0.000000000000000001e18, expected: SQRT_MAX_INT256 }));
        sets.push(set({ x: NEGATIVE_SQRT_MAX_INT256, y: NEGATIVE_SQRT_MAX_INT256, expected: SQRT_MAX_INT256 }));
        sets.push(set({ x: -2404.8e18, y: -7899.210662e18, expected: 4358_442588812843362311 }));
        sets.push(set({ x: -322.47e18, y: -674.77e18, expected: 466_468736251423392217 }));
        sets.push(set({ x: NEGATIVE_PI, y: -8.2e18, expected: 5_075535416036056441 }));
        sets.push(set({ x: NEGATIVE_E, y: -89.01e18, expected: 15_554879155787087514 }));
        sets.push(set({ x: -2e18, y: -8e18, expected: 4e18 }));
        sets.push(set({ x: -1e18, y: -4e18, expected: 2e18 }));
        sets.push(set({ x: -1e18, y: -1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: 4e18, expected: 2e18 }));
        sets.push(set({ x: 2e18, y: 8e18, expected: 4e18 }));
        sets.push(set({ x: E, y: 89.01e18, expected: 15_554879155787087514 }));
        sets.push(set({ x: PI, y: 8.2e18, expected: 5_075535416036056441 }));
        sets.push(set({ x: 322.47e18, y: 674.77e18, expected: 466_468736251423392217 }));
        sets.push(set({ x: 2404.8e18, y: 7899.210662e18, expected: 4358_442588812843362311 }));
        sets.push(set({ x: SQRT_MAX_INT256, y: SQRT_MAX_INT256, expected: SQRT_MAX_INT256 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, y: 0.000000000000000001e18, expected: SQRT_MAX_INT256 }));
        sets.push(set({ x: MAX_SD59x18, y: 0.000000000000000001e18, expected: SQRT_MAX_INT256 }));
        return sets;
    }

    function testGm() external parameterizedTest(gmSets()) NotZeroOperands PositiveProduct ProductNotOverflow {
        SD59x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
