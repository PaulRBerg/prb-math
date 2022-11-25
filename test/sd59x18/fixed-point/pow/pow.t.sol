// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../../SD59x18BaseTest.t.sol";

contract SD59x18__PowTest is SD59x18__BaseTest {
    SD59x18 internal constant MAX_PERMITTED = SD59x18.wrap(2**192 * 10**18 - 1);

    function testPow__BaseAndExponentZero() external {
        SD59x18 x = ZERO;
        SD59x18 y = ZERO;
        SD59x18 actual = pow(x, y);
        SD59x18 expected = sd(1e18);
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
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier BaseNotZero() {
        _;
    }

    function testCannotPow__BaseNegative() external BaseNotZero {
        SD59x18 x = sd(-0.000000000000000001e18);
        SD59x18 y = sd(1e18);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, x));
        pow(x, y);
    }

    modifier BasePositive() {
        _;
    }

    function exponentZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, y: 0, expected: 1e18 }));
        sets.push(set({ x: E, y: 0, expected: 1e18 }));
        sets.push(set({ x: PI, y: 0, expected: 1e18 }));
        return sets;
    }

    function testPow__ExponentZero() external parameterizedTest(exponentZeroSets()) BaseNotZero BasePositive {
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier ExponentNotZero() {
        _;
    }

    function testCannotPow__ExponentGreaterThanMaxPermitted() external BaseNotZero BasePositive ExponentNotZero {
        SD59x18 x = MAX_PERMITTED.add(sd(1));
        SD59x18 y = sd(1e18);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__Exp2InputTooBig.selector, sd(192e18)));
        pow(x, y);
    }

    modifier ExponentLessThanOrEqualToMaxPermitted() {
        _;
    }

    function negativeExponentSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, y: -0.000000000000000001e18, expected: 1e18 + 41 }));
        sets.push(set({ x: 0.000000000001e18, y: -4.4e9, expected: 1_000000121576500300 }));
        sets.push(set({ x: 0.1e18, y: -0.8e18, expected: 6_309573444801932444 }));
        sets.push(set({ x: 0.24e18, y: -11e18, expected: 6571678_991286039528731186 }));
        sets.push(set({ x: 0.5e18, y: -0.7373e18, expected: 1_667053032211341971 }));
        sets.push(set({ x: 0.799291e18, y: -69e18, expected: 5168450_048540730175583501 }));
        sets.push(set({ x: 1e18, y: -1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: NEGATIVE_PI, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: -1.5e18, expected: 0.353553390593273762e18 }));
        sets.push(set({ x: E, y: NEGATIVE_E, expected: 0.065988035845312538e18 }));
        sets.push(set({ x: E, y: -1.66976e18, expected: 0.18829225035644931e18 }));
        sets.push(set({ x: PI, y: -1.5e18, expected: 0.179587122125166564e18 }));
        sets.push(set({ x: 11e18, y: -28.5e18, expected: 0 }));
        sets.push(set({ x: 32.15e18, y: -23.99e18, expected: 0 }));
        sets.push(set({ x: 406e18, y: -0.25e18, expected: 0.222776046060941016e18 }));
        sets.push(set({ x: 1729e18, y: -0.98e18, expected: 0.00067136841637396e18 }));
        sets.push(set({ x: 33441e18, y: -2.1891e18, expected: 0.000000000124709713e18 }));
        sets.push(set({ x: 2**128 * 10**18 - 1, y: -1e18, expected: 0 }));
        sets.push(set({ x: MAX_PERMITTED, y: -1e18, expected: 0 }));
        return sets;
    }

    function testPow__NegativeExponent()
        external
        parameterizedTest(negativeExponentSets())
        BaseNotZero
        BasePositive
        ExponentNotZero
        ExponentLessThanOrEqualToMaxPermitted
    {
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function positiveExponentSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, y: 0.000000000000000001e18, expected: 0.999999999999999959e18 }));
        sets.push(set({ x: 1e6, y: 4.4e9, expected: 0.99999987842351448e18 }));
        sets.push(set({ x: 0.1e18, y: 0.8e18, expected: 0.158489319246111349e18 }));
        sets.push(set({ x: 0.24e18, y: 11e18, expected: 0.000000152168114316e18 }));
        sets.push(set({ x: 0.5e18, y: 0.7373e18, expected: 0.59986094064056398e18 }));
        sets.push(set({ x: 0.799291e18, y: 69e18, expected: 0.000000193481602919e18 }));
        sets.push(set({ x: 1e18, y: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: PI, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 1.5e18, expected: 2_828427124746190097 }));
        sets.push(set({ x: E, y: E, expected: 15_154262241479263804 }));
        sets.push(set({ x: E, y: 1.66976e18, expected: 5_310893029888037563 }));
        sets.push(set({ x: PI, y: PI, expected: 36_462159607207910473 }));
        sets.push(set({ x: 11e18, y: 28.5e18, expected: 478290249106383504726311660571_903531944106436935 }));
        sets.push(
            set({ x: 32.15e18, y: 23.99e18, expected: 1436387590627448555101723413293079116_943375472179194989 })
        );
        sets.push(set({ x: 406e18, y: 0.25e18, expected: 4_488812947719016318 }));
        sets.push(set({ x: 1729e18, y: 0.98e18, expected: 1489_495149922256917866 }));
        sets.push(set({ x: 33441e18, y: 2.1891e18, expected: 8018621589_681923269491820156 }));
        sets.push(
            set({
                x: 340282366920938463463374607431768211455e18,
                y: 1e18,
                expected: 340282366920938457799636748773271041925_182187238234989391
            })
        );
        sets.push(
            set({ x: MAX_PERMITTED, y: 1e18, expected: 6277101735386680659358266643954607672760_949507286104301595e18 })
        );
        return sets;
    }

    function testPow__PositiveExponent()
        external
        parameterizedTest(positiveExponentSets())
        BaseNotZero
        BasePositive
        ExponentNotZero
        ExponentLessThanOrEqualToMaxPermitted
    {
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
