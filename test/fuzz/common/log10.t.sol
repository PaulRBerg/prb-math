// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { log10 } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

contract Common_Log10_Fuzz_Test is Base_Test {
    function testFuzz_Log10_DivisionOracle(uint256 x) external pure {
        uint256 expected;
        for (uint256 remaining = x; remaining >= 10; remaining /= 10) {
            ++expected;
        }
        assertEq(log10(x), expected);
    }

    function testFuzz_Log10_DecadeBracket(uint256 x) external pure {
        x = bound(x, 1, type(uint256).max);
        uint256 exponent = log10(x);
        assertLe(exponent, 77);
        uint256 lower = 10 ** exponent;
        assertLe(lower, x);
        // The last representable decade has no representable upper power of ten.
        if (exponent < 77) {
            assertLt(x, lower * 10);
        }
    }
}
