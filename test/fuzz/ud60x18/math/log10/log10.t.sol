// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { log10 } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { Base_Test } from "../../../../Base.t.sol";

contract Log10_Fuzz_Test is Base_Test {
    function testFuzz_Log10_DecadeBounds(uint256 raw) external pure {
        raw = bound(raw, 1e18, type(uint256).max);
        // Count decimal digits independently of Common.log10.
        uint256 decade;
        for (uint256 remaining = raw / 1e18; remaining >= 10; remaining /= 10) {
            ++decade;
        }
        uint256 actual = log10(UD60x18.wrap(raw)).unwrap();
        assertGe(actual, decade * 1e18);
        assertLe(actual, (decade + 1) * 1e18);
    }

    function testFuzz_Log10_AdjacentInputs(uint256 raw) external pure {
        raw = bound(raw, 1e18, type(uint256).max - 1);
        assertLe(log10(UD60x18.wrap(raw)).unwrap(), log10(UD60x18.wrap(raw + 1)).unwrap());
    }

    function testFuzz_Log10_OrderedInputs(uint256 a, uint256 b) external pure {
        a = bound(a, 1e18, type(uint256).max);
        b = bound(b, a, type(uint256).max);
        assertLe(log10(UD60x18.wrap(a)).unwrap(), log10(UD60x18.wrap(b)).unwrap());
    }
}
