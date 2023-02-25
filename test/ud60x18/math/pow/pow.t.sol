// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ud } from "src/ud60x18/Casting.sol";
import { E, PI, ZERO } from "src/ud60x18/Constants.sol";
import { PRBMath_UD60x18_Exp2_InputTooBig, PRBMath_UD60x18_Log_InputTooSmall } from "src/ud60x18/Errors.sol";
import { pow } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Test } from "../../UD60x18.t.sol";

contract PowTest is UD60x18_Test {
    UD60x18 internal constant MAX_PERMITTED = UD60x18.wrap(2 ** 192 * 10 ** 18 - 1);

    function test_Pow_BaseAndExponentZero() external {
        UD60x18 x = ZERO;
        UD60x18 y = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = ud(1e18);
        assertEq(actual, expected);
    }

    function baseZeroExponentNotZero_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: E, expected: 0 }));
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        return sets;
    }

    function test_Pow_BaseZeroExponentNotZero() external parameterizedTest(baseZeroExponentNotZero_Sets()) {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier baseNotZero() {
        _;
    }

    function test_RevertWhen_BaseLessThanOne() external baseNotZero {
        UD60x18 x = ud(1e18 - 1);
        UD60x18 y = PI;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Log_InputTooSmall.selector, x));
        pow(x, y);
    }

    modifier baseGreaterThanOrEqualToOne() {
        _;
    }

    function exponentZero_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 0, expected: 1e18 }));
        sets.push(set({ x: E, y: 0, expected: 1e18 }));
        sets.push(set({ x: PI, y: 0, expected: 1e18 }));
        return sets;
    }

    function test_Pow_ExponentZero() external parameterizedTest(exponentZero_Sets()) baseNotZero baseGreaterThanOrEqualToOne {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier exponentNotZero() {
        _;
    }

    function exponentOne_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 1e18, expected: 1e18 }));
        sets.push(set({ x: E, y: 1e18, expected: E }));
        sets.push(set({ x: PI, y: 1e18, expected: PI }));
        return sets;
    }

    function test_Pow_ExponentOne()
        external
        parameterizedTest(exponentOne_Sets())
        baseNotZero
        baseGreaterThanOrEqualToOne
        exponentNotZero
        exponentLessThanOrEqualToMaxPermitted
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier exponentNotOne() {
        _;
    }

    function test_RevertWhen_ExponentGreaterThanOrEqualToMaxPermitted()
        external
        baseNotZero
        baseGreaterThanOrEqualToOne
        exponentNotZero
        exponentNotOne
    {
        UD60x18 x = MAX_PERMITTED.add(ud(1));
        UD60x18 y = ud(1e18 + 1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Exp2_InputTooBig.selector, ud(192e18 + 192)));
        pow(x, y);
    }

    modifier exponentLessThanOrEqualToMaxPermitted() {
        _;
    }

    function pow_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 2e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: PI, expected: 1e18 }));
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
        sets.push(set({ x: MAX_PERMITTED, y: 1e18 - 1, expected: 6277101735386679823624773486129835356722228023657461399187e18 }));
        return sets;
    }

    function test_Pow()
        external
        parameterizedTest(pow_Sets())
        baseNotZero
        exponentNotZero
        exponentNotOne
        exponentLessThanOrEqualToMaxPermitted
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
