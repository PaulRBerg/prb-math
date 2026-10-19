// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { log10 } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { Base_Test } from "../../../../Base.t.sol";

contract Log10_Fuzz_Test is Base_Test {
    function testFuzz_Log10_DecadeBounds(int256 raw) external pure {
        raw = bound(raw, 1, type(int256).max);
        // Count decimal digits independently of Common.log10.
        int256 decade = -18;
        for (int256 remaining = raw; remaining >= 10; remaining /= 10) {
            ++decade;
        }
        int256 actual = log10(SD59x18.wrap(raw)).unwrap();
        assertGe(actual, decade * 1e18);
        assertLe(actual, (decade + 1) * 1e18);
    }

    function testFuzz_Log10_AdjacentInputs(int256 raw) external pure {
        raw = bound(raw, 1, type(int256).max - 1);
        assertLe(log10(SD59x18.wrap(raw)).unwrap(), log10(SD59x18.wrap(raw + 1)).unwrap());
    }

    function testFuzz_Log10_OrderedInputs(int256 a, int256 b) external pure {
        a = bound(a, 1, type(int256).max);
        b = bound(b, a, type(int256).max);
        assertLe(log10(SD59x18.wrap(a)).unwrap(), log10(SD59x18.wrap(b)).unwrap());
    }

    function testFuzz_Log10_SubunitDecades(uint8 exponent, int256 raw) external pure {
        exponent = uint8(bound(exponent, 0, 17));
        int256 lower = int256(10 ** uint256(exponent));
        raw = bound(raw, lower, lower * 10 - 1);
        int256 actual = log10(SD59x18.wrap(raw)).unwrap();
        int256 decade = int256(uint256(exponent)) - 18;
        assertGe(actual, decade * 1e18);
        assertLe(actual, (decade + 1) * 1e18);
        assertLe(actual, log10(SD59x18.wrap(raw + 1)).unwrap());
    }
}
