// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { UNIT, ZERO } from "src/sd59x18/Constants.sol";
import { pow } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { Base_Test } from "../../../../Base.t.sol";

contract Pow_Fuzz_Test is Base_Test {
    function testFuzz_Pow_BaseZero_ExponentNotZero(SD59x18 y) external pure {
        vm.assume(y != ZERO);
        SD59x18 x = ZERO;
        SD59x18 actual = pow(x, y);
        SD59x18 expected = ZERO;
        assertEq(actual, expected, "SD59x18 pow");
    }

    modifier whenBaseNotZero() {
        _;
    }

    function testFuzz_Pow_BaseUnit(SD59x18 y) external pure whenBaseNotZero {
        SD59x18 x = UNIT;
        SD59x18 actual = pow(x, y);
        SD59x18 expected = UNIT;
        assertEq(actual, expected, "SD59x18 pow");
    }

    modifier whenBaseNotUnit() {
        _;
    }

    function testFuzz_Pow_ExponentZero(SD59x18 x) external pure whenBaseNotZero whenBaseNotUnit {
        vm.assume(x != ZERO && x != UNIT);
        SD59x18 y = ZERO;
        SD59x18 actual = pow(x, y);
        SD59x18 expected = UNIT;
        assertEq(actual, expected, "SD59x18 pow");
    }

    modifier whenExponentNotZero() {
        _;
    }

    function testFuzz_Pow_ExponentUnit(SD59x18 x) external pure whenBaseNotZero whenBaseNotUnit whenExponentNotZero {
        vm.assume(x != ZERO && x != UNIT);
        SD59x18 y = UNIT;
        SD59x18 actual = pow(x, y);
        SD59x18 expected = x;
        assertEq(actual, expected, "SD59x18 pow");
    }

    function testFuzz_Pow_ExponentUnitNeighbors(int256 raw) external pure {
        raw = bound(raw, 1, 1e36);
        SD59x18 x = SD59x18.wrap(raw);
        int256 below = pow(x, SD59x18.wrap(1e18 - 1)).unwrap();
        int256 above = pow(x, SD59x18.wrap(1e18 + 1)).unwrap();
        if (raw > 1e18) {
            assertLe(below, raw);
            assertGe(above, raw);
        } else {
            assertGe(below, raw);
            assertLe(above, raw);
        }
    }

    function testFuzz_Pow_OrderingWithBase(int256 raw, int256 exponent) external pure {
        // This range keeps both positive and negative exponents inside exp2's domain.
        raw = bound(raw, 1e9, 1e27);
        exponent = bound(exponent, -2e18, 2e18);
        int256 actual = pow(SD59x18.wrap(raw), SD59x18.wrap(exponent)).unwrap();
        if (raw == 1e18 || exponent == 1e18) {
            assertEq(actual, raw);
        } else if ((raw > 1e18) == (exponent > 1e18)) {
            assertGe(actual, raw);
        } else {
            assertLe(actual, raw);
        }
    }
}
