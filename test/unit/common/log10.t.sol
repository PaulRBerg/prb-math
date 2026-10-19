// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { log10 } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

contract Common_Log10_Unit_Test is Base_Test {
    function test_Log10_Zero() external pure {
        assertEq(log10(0), 0);
    }

    function test_Log10_AllPowersOfTenAndNeighbors() external pure {
        uint256 power = 1;
        for (uint256 exponent; exponent <= 77; ++exponent) {
            assertEq(log10(power), exponent, "exact power");
            assertEq(log10(power + 1), exponent, "above power");
            assertEq(log10(power - 1), exponent == 0 ? 0 : exponent - 1, "below power");
            if (exponent < 77) {
                power *= 10;
            }
        }
    }

    function test_Log10_MaxUint256() external pure {
        assertEq(log10(type(uint256).max), 77);
    }
}
