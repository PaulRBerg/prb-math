// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/SD59x18.sol";
import { PRBMath__MulDiv18Overflow } from "src/Core.sol";
import { SD59x18_Test } from "../../SD59x18.t.sol";

contract Mul_Test is SD59x18_Test {
    function oneOperandZero_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(1)), y: 0, expected: 0 }));
        sets.push(set({ x: 0, y: MIN_SD59x18.add(sd(1)), expected: 0 }));
        sets.push(set({ x: 0, y: MAX_SD59x18, expected: 0 }));
        sets.push(set({ x: MAX_SD59x18, y: 0, expected: 0 }));
        return sets;
    }

    function test_Mul_OneOperandZero() external parameterizedTest(oneOperandZero_Sets()) {
        SD59x18 actual = mul(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier NeitherOperandZero() {
        _;
    }

    function test_RevertWhen_OneOperandMinSD59x18__1() external NeitherOperandZero {
        SD59x18 x = MIN_SD59x18;
        SD59x18 y = sd(0.000000000000000001e18);
        vm.expectRevert(PRBMathSD59x18__MulInputTooSmall.selector);
        mul(x, y);
    }

    function test_RevertWhen_OneOperandMinSD59x18__2() external NeitherOperandZero {
        SD59x18 x = sd(0.000000000000000001e18);
        SD59x18 y = MIN_SD59x18;
        vm.expectRevert(PRBMathSD59x18__MulInputTooSmall.selector);
        mul(x, y);
    }

    modifier NeitherOperandMinSD59x18() {
        _;
    }

    function test_RevertWhen_ResultOverflowSD59x18_1() external NeitherOperandZero NeitherOperandMinSD59x18 {
        SD59x18 x = NEGATIVE_SQRT_MAX_SD59x18;
        SD59x18 y = NEGATIVE_SQRT_MAX_SD59x18.sub(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__MulOverflow.selector, x, y));
        mul(x, y);
    }

    function test_RevertWhen_ResultOverflowSD59x18_2() external NeitherOperandZero NeitherOperandMinSD59x18 {
        SD59x18 x = SQRT_MAX_SD59x18;
        SD59x18 y = SQRT_MAX_SD59x18.add(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__MulOverflow.selector, x, y));
        mul(x, y);
    }

    modifier ResultDoesNotOverflowSD59x18() {
        _;
    }

    function resultOverflowUint256_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(1)), y: MIN_SD59x18.add(sd(1)), expected: NIL }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, y: MIN_WHOLE_SD59x18, expected: NIL }));
        sets.push(set({ x: NEGATIVE_SQRT_MAX_UD60x18.sub(sd(1)), y: NEGATIVE_SQRT_MAX_UD60x18.sub(sd(1)), expected: NIL }));
        sets.push(set({ x: SQRT_MAX_UD60x18.add(sd(1)), y: SQRT_MAX_UD60x18.add(sd(1)), expected: NIL }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, y: MAX_WHOLE_SD59x18, expected: NIL }));
        sets.push(set({ x: MAX_SD59x18, y: MAX_SD59x18, expected: NIL }));
        return sets;
    }

    function test_RevertWhen_ResultOverflowUint256()
        external
        parameterizedTest(resultOverflowUint256_Sets())
        NeitherOperandZero
        NeitherOperandMinSD59x18
        ResultDoesNotOverflowSD59x18
    {
        vm.expectRevert(
            abi.encodeWithSelector(
                PRBMath__MulDiv18Overflow.selector,
                s.x.lt(ZERO) ? s.x.uncheckedUnary() : s.x,
                s.y.lt(ZERO) ? s.y.uncheckedUnary() : s.y
            )
        );
        mul(s.x, s.y);
    }

    modifier ResultDoesNotOverflowUint256() {
        _;
    }

    function operandsSameSign_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(0.5e18 + 1)), y: -0.000000000000000001e18, expected: MAX_SCALED_SD59x18 }));
        sets.push(
            set({ x: MIN_WHOLE_SD59x18.add(sd(0.5e18)), y: -0.000000000000000001e18, expected: MAX_SCALED_SD59x18.sub(sd(1)) })
        );
        sets.push(set({ x: -1e24, y: -1e20, expected: 1e26 }));
        sets.push(set({ x: -12_983.989e18, y: -782.99e18, expected: 1_016_6333.54711e18 }));
        sets.push(set({ x: -9_817e18, y: -2_348e18, expected: 23_050_316e18 }));
        sets.push(set({ x: -314.271e18, y: -188.19e18, expected: 59_142.65949e18 }));
        sets.push(set({ x: -18.3e18, y: -12.04e18, expected: 220.332e18 }));
        sets.push(set({ x: NEGATIVE_PI, y: NEGATIVE_E, expected: 8_539734222673567063 }));
        sets.push(set({ x: -2.098e18, y: -1.119e18, expected: 2.347662e18 }));
        sets.push(set({ x: -1e18, y: -1e18, expected: 1e18 }));
        sets.push(set({ x: -0.01e18, y: -0.05e18, expected: 0.0005e18 }));
        sets.push(set({ x: -0.001e18, y: -0.01e18, expected: 0.00001e18 }));
        sets.push(set({ x: -0.00001e18, y: -0.00001e18, expected: 0.0000000001e18 }));
        sets.push(set({ x: -0.000000001e18, y: -0.000000001e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: -0.000000000000000001e18, y: -0.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: -0.000000000000000006e18, y: -0.1e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: 0.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000006e18, y: 0.1e18, expected: 0 }));
        sets.push(set({ x: 0.000000001e18, y: 0.000000001e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 0.00001e18, y: 0.00001e18, expected: 0.0000000001e18 }));
        sets.push(set({ x: 0.001e18, y: 0.01e18, expected: 0.00001e18 }));
        sets.push(set({ x: 0.01e18, y: 0.05e18, expected: 0.0005e18 }));
        sets.push(set({ x: 1e18, y: 1e18, expected: 1e18 }));
        sets.push(set({ x: 2.098e18, y: 1.119e18, expected: 2.347662e18 }));
        sets.push(set({ x: PI, y: E, expected: 8_539734222673567063 }));
        sets.push(set({ x: 18.3e18, y: 12.04e18, expected: 220.332e18 }));
        sets.push(set({ x: 314.271e18, y: 188.19e18, expected: 59_142.65949e18 }));
        sets.push(set({ x: 9_817e18, y: 2_348e18, expected: 23_050_316e18 }));
        sets.push(set({ x: 12_983.989e18, y: 782.99e18, expected: 1_016_6333.54711e18 }));
        sets.push(set({ x: 1e24, y: 1e20, expected: 1e26 }));
        sets.push(
            set({ x: MAX_WHOLE_SD59x18.sub(sd(0.5e18)), y: 0.000000000000000001e18, expected: MAX_SCALED_SD59x18.sub(sd(1)) })
        );
        sets.push(set({ x: MAX_SD59x18.sub(sd(0.5e18)), y: 0.000000000000000001e18, expected: MAX_SCALED_SD59x18 }));
        return sets;
    }

    function test_Mul_OperandsSameSign()
        external
        parameterizedTest(operandsSameSign_Sets())
        NeitherOperandZero
        NeitherOperandMinSD59x18
        ResultDoesNotOverflowSD59x18
        ResultDoesNotOverflowUint256
    {
        SD59x18 actual = mul(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function operandsDifferentSigns_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18.add(sd(0.5e18 + 1)), y: 0.000000000000000001e18, expected: MIN_SCALED_SD59x18 }));
        sets.push(
            set({ x: MIN_WHOLE_SD59x18.add(sd(0.5e18)), y: 0.000000000000000001e18, expected: MIN_SCALED_SD59x18.add(sd(1)) })
        );
        sets.push(set({ x: -1e24, y: 1e20, expected: -1e26 }));
        sets.push(set({ x: -12_983.989e18, y: 782.99e18, expected: -1_016_6333.54711e18 }));
        sets.push(set({ x: -9_817e18, y: 2_348e18, expected: -23_050_316e18 }));
        sets.push(set({ x: -314.271e18, y: 188.19e18, expected: -59_142.65949e18 }));
        sets.push(set({ x: -18.3e18, y: 12.04e18, expected: -220.332e18 }));
        sets.push(set({ x: NEGATIVE_PI, y: E, expected: -8_539734222673567063 }));
        sets.push(set({ x: -2.098e18, y: 1.119e18, expected: -2.347662e18 }));
        sets.push(set({ x: -1e18, y: 1e18, expected: -1e18 }));
        sets.push(set({ x: -0.01e18, y: 0.05e18, expected: -0.0005e18 }));
        sets.push(set({ x: -0.001e18, y: 0.01e18, expected: -0.00001e18 }));
        sets.push(set({ x: -0.00001e18, y: 0.00001e18, expected: -0.0000000001e18 }));
        sets.push(set({ x: -0.000000001e18, y: 0.000000001e18, expected: -0.000000000000000001e18 }));
        sets.push(set({ x: -0.000000000000000001e18, y: 0.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: -0.000000000000000006e18, y: 0.1e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: -0.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000006e18, y: -0.1e18, expected: 0 }));
        sets.push(set({ x: 0.000000001e18, y: -0.000000001e18, expected: -0.000000000000000001e18 }));
        sets.push(set({ x: 0.00001e18, y: -0.00001e18, expected: -0.0000000001e18 }));
        sets.push(set({ x: 0.001e18, y: -0.01e18, expected: -0.00001e18 }));
        sets.push(set({ x: 0.01e18, y: -0.05e18, expected: -0.0005e18 }));
        sets.push(set({ x: 1e18, y: -1e18, expected: -1e18 }));
        sets.push(set({ x: 2.098e18, y: -1.119e18, expected: -2.347662e18 }));
        sets.push(set({ x: PI, y: NEGATIVE_E, expected: -8_539734222673567063 }));
        sets.push(set({ x: 18.3e18, y: -12.04e18, expected: -220.332e18 }));
        sets.push(set({ x: 314.271e18, y: -188.19e18, expected: -59_142.65949e18 }));
        sets.push(set({ x: 9_817e18, y: -2_348e18, expected: -23_050_316e18 }));
        sets.push(set({ x: 12_983.989e18, y: -782.99e18, expected: -1_016_6333.54711e18 }));
        sets.push(set({ x: 1e24, y: -1e20, expected: -1e26 }));
        sets.push(
            set({ x: MAX_WHOLE_SD59x18.sub(sd(0.5e18)), y: -0.000000000000000001e18, expected: MIN_SCALED_SD59x18.add(sd(1)) })
        );
        sets.push(set({ x: MAX_SD59x18.sub(sd(0.5e18)), y: -0.000000000000000001e18, expected: MIN_SCALED_SD59x18 }));
        return sets;
    }

    function test_Mul_OperandsDifferentSign()
        external
        parameterizedTest(operandsDifferentSigns_Sets())
        NeitherOperandZero
        NeitherOperandMinSD59x18
        ResultDoesNotOverflowSD59x18
        ResultDoesNotOverflowUint256
    {
        SD59x18 actual = mul(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
