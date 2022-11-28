// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/UD60x18.sol";
import { PRBMath__MulDiv18Overflow } from "src/Core.sol";
import { UD60x18__BaseTest } from "../../UD60x18BaseTest.t.sol";

contract UD60x18__MulTest is UD60x18__BaseTest {
    function oneOperandZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: MAX_UD60x18, expected: 0 }));
        sets.push(set({ x: MAX_UD60x18, y: 0, expected: 0 }));
        return sets;
    }

    function testMul__OneOperandZero() external parameterizedTest(oneOperandZeroSets()) {
        UD60x18 actual = mul(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier NeitherOperandZero() {
        _;
    }

    function testCannotMul__ResultOverflowUD60x18_1() external NeitherOperandZero {
        UD60x18 x = SQRT_MAX_UD60x18.add(ud(1));
        UD60x18 y = SQRT_MAX_UD60x18.add(ud(1));
        vm.expectRevert(
            abi.encodeWithSelector(PRBMath__MulDiv18Overflow.selector, UD60x18.unwrap(x), UD60x18.unwrap(y))
        );
        mul(x, y);
    }

    function testCannotMul__ResultOverflowUD60x18_2() external NeitherOperandZero {
        UD60x18 x = SQRT_MAX_UD60x18.add(ud(1));
        UD60x18 y = SQRT_MAX_UD60x18.add(ud(1));
        vm.expectRevert(
            abi.encodeWithSelector(PRBMath__MulDiv18Overflow.selector, UD60x18.unwrap(x), UD60x18.unwrap(y))
        );
        mul(x, y);
    }

    modifier ResultDoesNotOverflowUD60x18() {
        _;
    }

    function mulSets() internal returns (Set[] memory) {
        delete sets;
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
            set({
                x: SQRT_MAX_UD60x18,
                y: SQRT_MAX_UD60x18,
                expected: 115792089237316195423570985008687907853269984664959999305615_707080986380425072
            })
        );
        sets.push(set({ x: MAX_WHOLE_UD60x18, y: 0.000000000000000001e18, expected: MAX_SCALED_UD60x18 }));
        sets.push(set({ x: MAX_UD60x18.sub(ud(0.5e18)), y: 0.000000000000000001e18, expected: MAX_SCALED_UD60x18 }));
        return sets;
    }

    function testMul() external parameterizedTest(mulSets()) NeitherOperandZero ResultDoesNotOverflowUD60x18 {
        UD60x18 actual = mul(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
