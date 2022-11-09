// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_SD59x18,
    MAX_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__Exp2InputTooBig,
    PRBMathSD59x18__LogInputTooSmall,
    SD59x18,
    ZERO,
    pow
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__PowTest is SD59x18__BaseTest {
    // 2^192
    SD59x18 internal constant MAX_PERMITTED =
        SD59x18.wrap(6277101735386680763835789423207666416102_355444464034512896e18);

    function testPow__BaseAndExponentZero() external {
        SD59x18 x = ZERO;
        SD59x18 y = ZERO;
        SD59x18 actual = pow(x, y);
        SD59x18 expected = sd(1e18);
        assertEq(actual, expected);
    }

    function baseZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: E, expected: 0 }));
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        return sets;
    }

    function testPow__BaseZeroExponentNotZero() external parameterizedTest(baseZeroSets()) {
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier BaseNotZero() {
        _;
    }

    function negativeSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: NEGATIVE_PI, y: 1e18, expected: 0 }));
        sets.push(set({ x: NEGATIVE_E, y: E, expected: 0 }));
        sets.push(set({ x: -1e18, y: PI, expected: 0 }));
        return sets;
    }

    function testPow__BaseNegative() external parameterizedTest(negativeSets()) BaseNotZero {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__LogInputTooSmall.selector, s.x));
        pow(s.x, s.y);
    }

    modifier BasePositive() {
        _;
    }

    function exponentZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: E, expected: 1e18 }));
        sets.push(set({ x: PI, expected: 1e18 }));
        return sets;
    }

    function testPow__ExponentZero() external parameterizedTest(exponentZeroSets()) BaseNotZero BasePositive {
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }

    modifier ExponentNotZero() {
        _;
    }

    function greaterThanOrEqualSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MAX_PERMITTED, y: 1e18, expected: 0 }));
        sets.push(set({ x: MAX_SD59x18, y: 1e18, expected: 0 }));
        return sets;
    }

    function testPow__ExponentGreaterThanOrEqualToMaxPermitted()
        external
        parameterizedTest(greaterThanOrEqualSets())
        BaseNotZero
        BasePositive
        ExponentNotZero
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__Exp2InputTooBig.selector, sd(192e18)));
        pow(s.x, s.y);
    }

    modifier ExponentLessThanMaxPermitted() {
        _;
    }

    function powSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1, y: -1, expected: 1e18 + 41 }));
        sets.push(set({ x: 1e6, y: -4.4e9, expected: 1_000000121576500300 }));
        sets.push(set({ x: 0.1e18, y: -0.8e18, expected: 6_309573444801932444 }));
        sets.push(set({ x: 0.24e18, y: -11e18, expected: 6571678_991286039528731186 }));
        sets.push(set({ x: 0.5e18, y: -0.7373e18, expected: 1_667053032211341971 }));
        sets.push(set({ x: 0.799291e18, y: -69e18, expected: 5168450_048540730175583501 }));
        sets.push(set({ x: 1e18, y: -1e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, y: NEGATIVE_PI, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: -1.5e18, expected: 353553390593273762 }));
        sets.push(set({ x: E, y: NEGATIVE_E, expected: 65988035845312538 }));
        sets.push(set({ x: E, y: -1.66976e18, expected: 188292250356449310 }));
        sets.push(set({ x: PI, y: -1.5e18, expected: 179587122125166564 }));
        sets.push(set({ x: 11e18, y: -28.5e18, expected: 0 }));
        sets.push(set({ x: 32.15e18, y: -23.99e18, expected: 0 }));
        sets.push(set({ x: 406e18, y: -0.25e18, expected: 222776046060941016 }));
        sets.push(set({ x: 1729e18, y: -0.98e18, expected: 671368416373960 }));
        sets.push(set({ x: 33441e18, y: -2.1891e18, expected: 124709713 }));
        sets.push(set({ x: 340282366920938463463374607431768211455e18, y: -1e18, expected: 0 }));
        sets.push(set({ x: MAX_PERMITTED.uncheckedSub(sd(1)), y: -1e18, expected: 0 }));
        sets.push(set({ x: 1, y: 1, expected: 999999999999999959 }));
        sets.push(set({ x: 1e6, y: 4.4e9, expected: 999999878423514480 }));
        sets.push(set({ x: 0.1e18, y: 0.8e18, expected: 158489319246111349 }));
        sets.push(set({ x: 0.24e18, y: 11e18, expected: 152168114316 }));
        sets.push(set({ x: 0.5e18, y: 0.7373e18, expected: 599860940640563980 }));
        sets.push(set({ x: 0.799291e18, y: 69e18, expected: 193481602919 }));
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
            set({
                x: MAX_PERMITTED.uncheckedSub(sd(1)),
                y: 1e18,
                expected: 6277101735386680659358266643954607672760_949507286104301595e18
            })
        );
        return sets;
    }

    function testPow()
        external
        parameterizedTest(powSets())
        BaseNotZero
        BasePositive
        ExponentNotZero
        ExponentLessThanMaxPermitted
    {
        SD59x18 actual = pow(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
