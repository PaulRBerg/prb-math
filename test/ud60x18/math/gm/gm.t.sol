// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, ZERO } from "src/ud60x18/Constants.sol";
import { PRBMath_UD60x18_Gm_Overflow } from "src/ud60x18/Errors.sol";
import { gm } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Test } from "../../UD60x18.t.sol";

contract Gm_Test is UD60x18_Test {
    // Biggest number whose non-fixed-point square fits within uint256
    uint256 internal constant SQRT_MAX_UINT256 = 340282366920938463463374607431768211455;

    function oneOperandZero_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        sets.push(set({ x: PI, y: 0, expected: 0 }));
        return sets;
    }

    function test_Gm_OneOperandZero() external parameterizedTest(oneOperandZero_Sets()) {
        UD60x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier notZeroOperands() {
        _;
    }

    function test_RevertWhen_ProductOverflow() external notZeroOperands {
        UD60x18 x = SQRT_MAX_UD60x18.add(ud(1));
        UD60x18 y = SQRT_MAX_UD60x18.add(ud(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Gm_Overflow.selector, x, y));
        gm(x, y);
    }

    modifier productNotOverflow() {
        _;
    }

    function gm_Sets() internal returns (Set[] memory) {
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

    function test_Gm() external parameterizedTest(gm_Sets()) notZeroOperands productNotOverflow {
        UD60x18 actual = gm(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
