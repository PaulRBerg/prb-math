// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ud } from "src/ud60x18/Casting.sol";
import { E, PI, UNIT, ZERO } from "src/ud60x18/Constants.sol";
import { pow } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Test } from "../../UD60x18.t.sol";

contract Pow_Test is UD60x18_Test {
    modifier baseZero() {
        _;
    }

    function test_Pow_ExponentZero() external baseZero {
        UD60x18 x = ZERO;
        UD60x18 y = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = UNIT;
        assertEq(actual, expected);
    }

    function testFuzz_Pow_ExponentNotZero(UD60x18 y) external baseZero {
        vm.assume(y != ZERO);
        UD60x18 x = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier whenBaseNotZero() {
        _;
    }

    function testFuzz_Pow_BaseUnit(UD60x18 y) external whenBaseNotZero {
        UD60x18 x = UNIT;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = UNIT;
        assertEq(actual, expected);
    }

    modifier whenBaseNotUnit() {
        _;
    }

    function testFuzz_Pow_ExponentZero(UD60x18 x) external whenBaseNotZero whenBaseNotUnit {
        vm.assume(x != ZERO && x != UNIT);
        UD60x18 y = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = UNIT;
        assertEq(actual, expected);
    }

    modifier whenExponentNotZero() {
        _;
    }

    function testFuzz_Pow_ExponentUnit(UD60x18 x) external whenBaseNotZero whenBaseNotUnit whenExponentNotZero {
        vm.assume(x != ZERO && x != UNIT);
        UD60x18 y = UNIT;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = x;
        assertEq(actual, expected);
    }

    modifier whenExponentNotUnit() {
        _;
    }

    function baseGreaterThanUnit_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18 + 1, y: 2e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 1.5e18, expected: 2_828427124746190097 }));
        sets.push(set({ x: E, y: 1.66976e18, expected: 5_310893029888037560 }));
        sets.push(set({ x: E, y: E, expected: 15_154262241479263793 }));
        sets.push(set({ x: PI, y: PI, expected: 36_462159607207910473 }));
        sets.push(set({ x: 11e18, y: 28.5e18, expected: 478290249106383504389245497918_050372801213485439 }));
        sets.push(set({ x: 32.15e18, y: 23.99e18, expected: 1436387590627448555101723413293079116_943375472179194989 }));
        sets.push(set({ x: 406e18, y: 0.25e18, expected: 4_488812947719016318 }));
        sets.push(set({ x: 1729e18, y: 0.98e18, expected: 1489_495149922256917866 }));
        sets.push(set({ x: 33441e18, y: 2.1891e18, expected: 8018621589_681923269491820156 }));
        sets.push(
            set({
                x: 340282366920938463463374607431768211455e18,
                y: 1e18 + 1,
                expected: 340282366920938487757736552507248225013_000000000004316573
            })
        );
        sets.push(
            set({ x: 2 ** 192 * 1e18 - 1, y: 1e18 - 1, expected: 6277101735386679823624773486129835356722228023657461399187e18 })
        );
        return sets;
    }

    function test_Pow_BaseGreaterThanUnit()
        external
        parameterizedTest(baseGreaterThanUnit_Sets())
        whenBaseNotZero
        whenBaseNotUnit
        whenExponentNotZero
        whenExponentNotUnit
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function baseLessThanUnit_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, y: 1.78e18, expected: 0 }));
        sets.push(set({ x: 0.01e18, y: E, expected: 0.000003659622955309e18 }));
        sets.push(set({ x: 0.125e18, y: PI, expected: 0.001454987061394186e18 }));
        sets.push(set({ x: 0.25e18, y: 3e18, expected: 0.015625e18 }));
        sets.push(set({ x: 0.45e18, y: 2.2e18, expected: 0.172610627076774731e18 }));
        sets.push(set({ x: 0.5e18, y: 0.481e18, expected: 0.716480825186549911e18 }));
        sets.push(set({ x: 0.6e18, y: 0.95e18, expected: 0.615522152723696171e18 }));
        sets.push(set({ x: 0.7e18, y: 3.1e18, expected: 0.330981655626097448e18 }));
        sets.push(set({ x: 0.75e18, y: 4e18, expected: 0.316406250000000008e18 }));
        sets.push(set({ x: 0.8e18, y: 5e18, expected: 0.327680000000000015e18 }));
        sets.push(set({ x: 0.9e18, y: 2.5e18, expected: 0.768433471420916194e18 }));
        sets.push(set({ x: 0.999999999999999999e18, y: 0.08e18, expected: UNIT }));
        return sets;
    }

    function test_Pow_BaseLessThanUnit()
        external
        parameterizedTest(baseLessThanUnit_Sets())
        whenBaseNotZero
        whenBaseNotUnit
        whenExponentNotZero
        whenExponentNotUnit
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
