// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__GmOverflow,
    PRBMathSD59x18__GmNegativeProduct,
    SD59x18,
    gm
} from "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__GmTest is SD59x18__BaseTest {
    // Greatest number whose square fits within int256
    SD59x18 internal constant SQRT_MAX_SD59x18_DIV_BY_SCALE = SD59x18.wrap(240615969168004511545_033772477625056927);
    // Smallest number whose square fits within int256
    SD59x18 internal constant SQRT_MIN_SD59x18_DIV_BY_SCALE = SD59x18.wrap(-240615969168004511545_033772477625056927);

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

    function productNegativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: -7.1e18, y: 20.05e18, expected: NIL }));
        sets.push(set({ x: -1e18, y: PI, expected: NIL }));
        sets.push(set({ x: PI, y: -1e18, expected: NIL }));
        sets.push(set({ x: 7.1e18, y: -20.05e18, expected: NIL }));
        return sets;
    }

    function testCannotGm__ProductNegative() external parameterizedTest(productNegativeSets()) NotZeroOperands {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmNegativeProduct.selector, s.x, s.y));
        gm(s.x, s.y);
    }

    modifier PositiveProduct() {
        _;
    }

    function productOverflowSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, y: 0.000000000000000002e18, expected: NIL }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, y: 0.000000000000000003e18, expected: NIL }));
        sets.push(
            set({ x: SQRT_MIN_SD59x18_DIV_BY_SCALE, y: SQRT_MIN_SD59x18_DIV_BY_SCALE.sub(sd(1)), expected: NIL })
        );
        sets.push(
            set({
                x: SQRT_MAX_SD59x18_DIV_BY_SCALE.add(sd(1)),
                y: SQRT_MAX_SD59x18_DIV_BY_SCALE.add(sd(1)),
                expected: NIL
            })
        );
        sets.push(set({ x: MAX_WHOLE_SD59x18, y: 0.000000000000000003e18, expected: NIL }));
        sets.push(set({ x: MAX_SD59x18, y: 0.000000000000000002e18, expected: NIL }));
        return sets;
    }

    function testCannotGm__ProductOverflow()
        external
        parameterizedTest(productOverflowSets())
        NotZeroOperands
        PositiveProduct
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__GmOverflow.selector, s.x, s.y));
        gm(s.x, s.y);
    }

    modifier ProductNotOverflow() {
        _;
    }

    function gmSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(
            set({
                x: MIN_WHOLE_SD59x18,
                y: -0.000000000000000001e18,
                expected: 240615969168004511545_033772477625056927
            })
        );
        sets.push(
            set({
                x: SQRT_MIN_SD59x18_DIV_BY_SCALE,
                y: SQRT_MIN_SD59x18_DIV_BY_SCALE,
                expected: 240615969168004511545_033772477625056927
            })
        );
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
        sets.push(
            set({
                x: SQRT_MAX_SD59x18_DIV_BY_SCALE,
                y: SQRT_MAX_SD59x18_DIV_BY_SCALE,
                expected: 240615969168004511545_033772477625056927
            })
        );
        sets.push(
            set({
                x: MAX_WHOLE_SD59x18,
                y: 0.000000000000000001e18,
                expected: 240615969168004511545_033772477625056927
            })
        );
        sets.push(
            set({ x: MAX_SD59x18, y: 0.000000000000000001e18, expected: 240615969168004511545_033772477625056927 })
        );
        return sets;
    }

    function testGm() external parameterizedTest(gmSets()) NotZeroOperands PositiveProduct ProductNotOverflow {
        SD59x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
