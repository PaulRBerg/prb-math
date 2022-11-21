// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__GmTest is UD60x18__BaseTest {
    // Biggest number whose non-fixed-point square fits within uint256
    UD60x18 internal constant SQRT_MAX_UINT256 = UD60x18.wrap(340282366920938463463374607431768211455);

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

    function testCannotGm__ProductOverflow() external NotZeroOperands {
        UD60x18 x = SQRT_MAX_UD60x18.add(ud(1));
        UD60x18 y = SQRT_MAX_UD60x18.add(ud(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__GmOverflow.selector, x, y));
        gm(x, y);
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
        sets.push(set({ x: SQRT_MAX_UINT256, y: SQRT_MAX_UINT256, expected: SQRT_MAX_UINT256 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, y: 0.000000000000000001e18, expected: SQRT_MAX_UINT256 }));
        sets.push(set({ x: MAX_UD60x18, y: 0.000000000000000001e18, expected: SQRT_MAX_UINT256 }));
        return sets;
    }

    function testGm() external parameterizedTest(gmSets()) NotZeroOperands ProductNotOverflow {
        UD60x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
