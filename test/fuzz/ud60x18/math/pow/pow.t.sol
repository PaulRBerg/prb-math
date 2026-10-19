// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { UNIT, ZERO } from "src/ud60x18/Constants.sol";
import { pow } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { Base_Test } from "../../../../Base.t.sol";

contract Pow_Fuzz_Test is Base_Test {
    function testFuzz_Pow_BaseZero_ExponentNotZero(UD60x18 y) external pure {
        vm.assume(y != ZERO);
        UD60x18 x = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = ZERO;
        assertEq(actual, expected, "UD60x18 pow");
    }

    modifier whenBaseNotZero() {
        _;
    }

    function testFuzz_Pow_BaseUnit(UD60x18 y) external pure whenBaseNotZero {
        UD60x18 x = UNIT;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = UNIT;
        assertEq(actual, expected, "UD60x18 pow");
    }

    modifier whenBaseNotUnit() {
        _;
    }

    function testFuzz_Pow_ExponentZero(UD60x18 x) external pure whenBaseNotZero whenBaseNotUnit {
        vm.assume(x != ZERO && x != UNIT);
        UD60x18 y = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = UNIT;
        assertEq(actual, expected, "UD60x18 pow");
    }

    modifier whenExponentNotZero() {
        _;
    }

    function testFuzz_Pow_ExponentUnit(UD60x18 x) external pure whenBaseNotZero whenBaseNotUnit whenExponentNotZero {
        vm.assume(x != ZERO && x != UNIT);
        UD60x18 y = UNIT;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = x;
        assertEq(actual, expected, "UD60x18 pow");
    }

    function testFuzz_Pow_ExponentUnitNeighbors(uint256 raw) external pure {
        raw = bound(raw, 1, 1e36);
        UD60x18 x = UD60x18.wrap(raw);
        uint256 below = pow(x, UD60x18.wrap(1e18 - 1)).unwrap();
        uint256 above = pow(x, UD60x18.wrap(1e18 + 1)).unwrap();
        if (raw > 1e18) {
            assertLe(below, raw);
            assertGe(above, raw);
        } else {
            assertGe(below, raw);
            assertLe(above, raw);
        }
    }

    function testFuzz_Pow_OrderingWithBase(uint256 raw, uint256 exponent) external pure {
        raw = bound(raw, 1, 1e36);
        exponent = bound(exponent, 0, 2e18);
        uint256 actual = pow(UD60x18.wrap(raw), UD60x18.wrap(exponent)).unwrap();
        if (raw == 1e18 || exponent == 1e18) {
            assertEq(actual, raw);
        } else if ((raw > 1e18) == (exponent > 1e18)) {
            assertGe(actual, raw);
        } else {
            assertLe(actual, raw);
        }
    }
}
