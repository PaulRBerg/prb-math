// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, PRBMathUD60x18__GmOverflow, UD60x18, gm } from "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__GmTest is UD60x18__BaseTest {
    // Biggest number whose square fits within uint256
    UD60x18 internal constant SQRT_MAX_UD60x18_DIV_BY_SCALE = UD60x18.wrap(340282366920938463463_374607431768211455);

    function oneOperandZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        sets.push(set({ x: PI, y: 0, expected: 0 }));
        return sets;
    }

    function testGm__OneOperandZero() external parameterizedTest(oneOperandZeroSets()) {
        UD60x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier NotZeroOperands() {
        _;
    }

    function productOverflowSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(
            set({
                x: SQRT_MAX_UD60x18_DIV_BY_SCALE.add(ud(1)),
                y: SQRT_MAX_UD60x18_DIV_BY_SCALE.add(ud(1)),
                expected: NIL
            })
        );
        sets.push(set({ x: MAX_WHOLE_UD60x18, y: 0.000000000000000003e18, expected: NIL }));
        sets.push(set({ x: MAX_UD60x18, y: 0.000000000000000002e18, expected: NIL }));
        return sets;
    }

    function testCannotGm__ProductOverflow() external parameterizedTest(productOverflowSets()) NotZeroOperands {
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__GmOverflow.selector, s.x, s.y));
        gm(s.x, s.y);
    }

    modifier ProductNotOverflow() {
        _;
    }

    function gmSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: 4e18, expected: 2e18 }));
        sets.push(set({ x: 2e18, y: 8e18, expected: 4e18 }));
        sets.push(set({ x: E, y: 89.01e18, expected: 15_554879155787087514 }));
        sets.push(set({ x: PI, y: 8.2e18, expected: 5_075535416036056441 }));
        sets.push(set({ x: 322.47e18, y: 674.77e18, expected: 466_468736251423392217 }));
        sets.push(set({ x: 2404.8e18, y: 7899.210662e18, expected: 4358_442588812843362311 }));
        sets.push(
            set({
                x: SQRT_MAX_UD60x18_DIV_BY_SCALE,
                y: SQRT_MAX_UD60x18_DIV_BY_SCALE,
                expected: SQRT_MAX_UD60x18_DIV_BY_SCALE
            })
        );
        sets.push(set({ x: MAX_WHOLE_UD60x18, y: 0.000000000000000001e18, expected: SQRT_MAX_UD60x18_DIV_BY_SCALE }));
        sets.push(set({ x: MAX_UD60x18, y: 0.000000000000000001e18, expected: SQRT_MAX_UD60x18_DIV_BY_SCALE }));
        return sets;
    }

    function testGm() external parameterizedTest(gmSets()) NotZeroOperands ProductNotOverflow {
        UD60x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
