// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { sd } from "src/sd59x18/Casting.sol";
import { MIN_SD59x18 } from "src/sd59x18/Constants.sol";
import { PRBMath_SD59x18_Div_Overflow } from "src/sd59x18/Errors.sol";
import { div } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { Base_Test } from "../../../../Base.t.sol";

contract Div_Fuzz_Test is Base_Test {
    /// @dev Picks x = 2^(255-k) and y = UNIT÷2^k so that x*UNIT÷y is exactly 2^255 for any k.
    function boundaryOperands(uint8 exponent) internal pure returns (SD59x18 x, SD59x18 y) {
        // 1e18 = 2^18 * 5^18, so UNIT is divisible by 2^k only for k <= 18.
        exponent = uint8(bound(exponent, 1, 18));
        x = sd(int256(2 ** (255 - uint256(exponent))));
        y = sd(1e18 / int256(2 ** uint256(exponent)));
    }

    function testFuzz_Div_ResultMin(uint8 exponent) external pure {
        (SD59x18 x, SD59x18 y) = boundaryOperands(exponent);
        assertEq(div(-x, y), MIN_SD59x18, "SD59x18 div");
        assertEq(div(x, -y), MIN_SD59x18, "SD59x18 div");
    }

    function testFuzz_RevertWhen_Div_ResultMaxPlusOne(uint8 exponent) external {
        (SD59x18 x, SD59x18 y) = boundaryOperands(exponent);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Div_Overflow.selector, x, y));
        div(x, y);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Div_Overflow.selector, -x, -y));
        div(-x, -y);
    }
}
