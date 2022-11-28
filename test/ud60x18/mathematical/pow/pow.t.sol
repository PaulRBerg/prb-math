// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../../UD60x18BaseTest.t.sol";

contract UD60x18__PowTest is UD60x18__BaseTest {
    UD60x18 internal constant MAX_PERMITTED = UD60x18.wrap(2 ** 192 * 10 ** 18 - 1);

    function testPow__BaseAndExponentZero() external {
        UD60x18 x = ZERO;
        UD60x18 y = ZERO;
        UD60x18 actual = pow(x, y);
        UD60x18 expected = ud(1e18);
        assertEq(actual, expected);
    }

    function baseZeroExponentNotZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: E, expected: 0 }));
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        return sets;
    }

    function testPow__BaseZeroExponentNotZero() external parameterizedTest(baseZeroExponentNotZeroSets()) {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier BaseNotZero() {
        _;
    }

    function testCannotPow__BaseLessThanOne() external BaseNotZero {
        UD60x18 x = ud(1e18 - 1);
        UD60x18 y = PI;
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__LogInputTooSmall.selector, x));
        pow(x, y);
    }

    modifier BaseGreaterThanOrEqualToOne() {
        _;
    }

    function exponentZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 0, expected: 1e18 }));
        sets.push(set({ x: E, y: 0, expected: 1e18 }));
        sets.push(set({ x: PI, y: 0, expected: 1e18 }));
        return sets;
    }

    function testPow__ExponentZero()
        external
        parameterizedTest(exponentZeroSets())
        BaseNotZero
        BaseGreaterThanOrEqualToOne
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier ExponentNotZero() {
        _;
    }

    function exponentOneSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 1e18, expected: 1e18 }));
        sets.push(set({ x: E, y: 1e18, expected: E }));
        sets.push(set({ x: PI, y: 1e18, expected: PI }));
        return sets;
    }

    function testPow__ExponentOne()
        external
        parameterizedTest(exponentOneSets())
        BaseNotZero
        BaseGreaterThanOrEqualToOne
        ExponentNotZero
        ExponentLessThanOrEqualToMaxPermitted
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier ExponentNotOne() {
        _;
    }

    function testCannotPow__ExponentGreaterThanOrEqualToMaxPermitted()
        external
        BaseNotZero
        BaseGreaterThanOrEqualToOne
        ExponentNotZero
        ExponentNotOne
    {
        UD60x18 x = MAX_PERMITTED.add(ud(1));
        UD60x18 y = ud(1e18 + 1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__Exp2InputTooBig.selector, ud(192e18 + 192)));
        pow(x, y);
    }

    modifier ExponentLessThanOrEqualToMaxPermitted() {
        _;
    }

    function powSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 2e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: PI, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 1.5e18, expected: 2_828427124746190097 }));
        sets.push(set({ x: E, y: 1.66976e18, expected: 5_310893029888037560 }));
        sets.push(set({ x: E, y: E, expected: 15_154262241479263793 }));
        sets.push(set({ x: PI, y: PI, expected: 36_462159607207910473 }));
        sets.push(set({ x: 11e18, y: 28.5e18, expected: 478290249106383504389245497918_050372801213485439 }));
        sets.push(
            set({ x: 32.15e18, y: 23.99e18, expected: 1436387590627448555101723413293079116_943375472179194989 })
        );
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
            set({
                x: MAX_PERMITTED,
                y: 1e18 - 1,
                expected: 6277101735386679823624773486129835356722228023657461399187e18
            })
        );
        return sets;
    }

    function testPow()
        external
        parameterizedTest(powSets())
        BaseNotZero
        ExponentNotZero
        ExponentNotOne
        ExponentLessThanOrEqualToMaxPermitted
    {
        UD60x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
