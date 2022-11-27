// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../../UD60x18BaseTest.t.sol";

contract UD60x18__LnTest is UD60x18__BaseTest {
    function testCannotLog10__LessThanOne() external {
        UD60x18 x = ud(1e18 - 1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__LogInputTooSmall.selector, x));
        ln(x);
    }

    modifier GreaterThanOrEqualToOne() {
        _;
    }

    function lnSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 1.125e18, expected: 0.117783035656383442e18 }));
        sets.push(set({ x: 2e18, expected: 0.693147180559945309e18 }));
        sets.push(set({ x: E, expected: 0.99999999999999999e18 }));
        sets.push(set({ x: PI, expected: 1_144729885849400163 }));
        sets.push(set({ x: 4e18, expected: 1_386294361119890619 }));
        sets.push(set({ x: 8e18, expected: 2_079441541679835928 }));
        sets.push(set({ x: 1e24, expected: 13_815510557964274099 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 135_999146549453176925 }));
        sets.push(set({ x: MAX_UD60x18, expected: 135_999146549453176925 }));
        return sets;
    }

    function testLn() external parameterizedTest(lnSets()) GreaterThanOrEqualToOne {
        UD60x18 actual = ln(s.x);
        assertEq(actual, s.expected);
    }
}
