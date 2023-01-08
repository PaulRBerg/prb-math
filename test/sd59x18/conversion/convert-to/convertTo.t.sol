// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18_Test } from "../../SD59x18.t.sol";

contract ConvertTo_Test is SD59x18_Test {
    function test_RevertWhen_LessThanMinPermitted() external {
        int256 x = SD59x18.unwrap(MIN_SCALED_SD59x18) - 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_ConvertUnderflow.selector, x));
        toSD59x18(x);
    }

    modifier GreaterThanMinPermitted() {
        _;
    }

    function test_RevertWhen_GreaterThanMaxPermitted() external GreaterThanMinPermitted {
        int256 x = SD59x18.unwrap(MAX_SCALED_SD59x18) + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_ConvertOverflow.selector, x));
        toSD59x18(x);
    }

    modifier LessThanOrEqualToMaxPermitted() {
        _;
    }

    function convertTo_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SCALED_SD59x18, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: -3.1415e42, expected: -3.1415e60 }));
        sets.push(set({ x: -2.7182e38, expected: -2.7182e56 }));
        sets.push(set({ x: -1e24, expected: -1e42 }));
        sets.push(set({ x: -5e18, expected: -5e36 }));
        sets.push(set({ x: -1e18, expected: -1e36 }));
        sets.push(set({ x: -0.000000000000001729e18, expected: -1729e18 }));
        sets.push(set({ x: -0.000000000000000002e18, expected: -2e18 }));
        sets.push(set({ x: -0.000000000000000001e18, expected: -1e18 }));
        sets.push(set({ x: 0.000000000000000001e18, expected: 1e18 }));
        sets.push(set({ x: 0.000000000000000002e18, expected: 2e18 }));
        sets.push(set({ x: 0.000000000000001729e18, expected: 1729e18 }));
        sets.push(set({ x: 1e18, expected: 1e36 }));
        sets.push(set({ x: 5e18, expected: 5e36 }));
        sets.push(set({ x: 2.7182e38, expected: 2.7182e56 }));
        sets.push(set({ x: 3.1415e42, expected: 3.1415e60 }));
        sets.push(set({ x: MAX_SCALED_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function test_ConvertTo() external parameterizedTest(convertTo_Sets()) GreaterThanMinPermitted LessThanOrEqualToMaxPermitted {
        SD59x18 x = toSD59x18(SD59x18.unwrap(s.x));
        assertEq(x, s.expected);
    }
}
