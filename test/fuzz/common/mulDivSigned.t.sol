// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { mulDivSigned } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

contract Common_MulDivSigned_Fuzz_Test is Base_Test {
    function testFuzz_MulDivSigned_MatchesNativeArithmetic(int128 x, int128 y, int256 denominator) external pure {
        vm.assume(denominator != 0 && denominator != MIN_INT256);
        // Two int128 operands have a product that fits in int256, so native arithmetic is an independent oracle.
        int256 expected = int256(x) * int256(y) / denominator;
        assertEq(mulDivSigned(x, y, denominator), expected);
    }

    function testFuzz_MulDivSigned_CancelDenominator(int256 x, int256 y) external pure {
        vm.assume(x != MIN_INT256 && y != MIN_INT256 && y != 0);
        // The quotient is x even when the intermediate product needs 512 bits.
        assertEq(mulDivSigned(x, y, y), x);
    }

    function testFuzz_MulDivSigned_ResultMin(uint8 exponent) external pure {
        exponent = uint8(bound(exponent, 1, 254));
        int256 x = int256(2 ** uint256(exponent));
        int256 y = int256(2 ** 254);
        int256 denominator = int256(2 ** uint256(exponent - 1));
        assertEq(mulDivSigned(-x, y, denominator), MIN_INT256);
        assertEq(mulDivSigned(x, -y, denominator), MIN_INT256);
        assertEq(mulDivSigned(x, y, -denominator), MIN_INT256);
        assertEq(mulDivSigned(-x, -y, -denominator), MIN_INT256);
    }
}
