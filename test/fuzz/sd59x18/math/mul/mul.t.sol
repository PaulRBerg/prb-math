// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { sd } from "src/sd59x18/Casting.sol";
import { MIN_SD59x18 } from "src/sd59x18/Constants.sol";
import { PRBMath_SD59x18_Mul_Overflow } from "src/sd59x18/Errors.sol";
import { mul } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { Base_Test } from "../../../../Base.t.sol";

contract Mul_Fuzz_Test is Base_Test {
    /// @dev Splits the magnitude 2^255 across the operands so that x*y÷UNIT is exactly 2^255 for any split.
    function boundaryOperands(uint8 exponent) internal pure returns (SD59x18 x, SD59x18 y) {
        // y must stay below 2^255, so its power of two is at most 2^194 (2^194 * 1e18 < 2^254).
        exponent = uint8(bound(exponent, 61, 254));
        x = sd(int256(2 ** uint256(exponent)));
        y = sd(int256(2 ** uint256(255 - exponent)) * 1e18);
    }

    function testFuzz_Mul_ResultMin(uint8 exponent) external pure {
        (SD59x18 x, SD59x18 y) = boundaryOperands(exponent);
        assertEq(mul(-x, y), MIN_SD59x18, "SD59x18 mul");
        assertEq(mul(x, -y), MIN_SD59x18, "SD59x18 mul");
    }

    function testFuzz_RevertWhen_Mul_ResultMaxPlusOne(uint8 exponent) external {
        (SD59x18 x, SD59x18 y) = boundaryOperands(exponent);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Mul_Overflow.selector, x, y));
        mul(x, y);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Mul_Overflow.selector, -x, -y));
        mul(-x, -y);
    }
}
