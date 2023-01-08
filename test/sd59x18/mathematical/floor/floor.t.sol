// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/SD59x18.sol";
import { SD59x18_Test } from "../../SD59x18.t.sol";

contract Floor_Test is SD59x18_Test {
    function test_Floor_Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = floor(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function test_RevertWhen_Negative_LessThanMinPermitted() external NotZero {
        SD59x18 x = MIN_WHOLE_SD59x18.sub(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_FloorUnderflow.selector, x));
        floor(x);
    }

    function negativeAndGreaterThanOrEqualToMinPermitted_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: -1e24, expected: -1e24 }));
        sets.push(set({ x: -4.2e18, expected: -5e18 }));
        sets.push(set({ x: -2e18, expected: -2e18 }));
        sets.push(set({ x: -1.125e18, expected: -2e18 }));
        sets.push(set({ x: -1e18, expected: -1e18 }));
        sets.push(set({ x: -0.5e18, expected: -1e18 }));
        sets.push(set({ x: -0.1e18, expected: -1e18 }));
        return sets;
    }

    function test_Floor_Negative_GreaterThanOrEqualToMinPermitted()
        external
        parameterizedTest(negativeAndGreaterThanOrEqualToMinPermitted_Sets())
        NotZero
    {
        SD59x18 actual = floor(s.x);
        assertEq(actual, s.expected);
    }

    function positive_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0 }));
        sets.push(set({ x: 0.5e18, expected: 0 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 3e18 }));
        sets.push(set({ x: 4.2e18, expected: 4e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18, expected: MAX_WHOLE_SD59x18 }));
        return sets;
    }

    function test_Floor_Positive() external parameterizedTest(positive_Sets()) NotZero {
        SD59x18 actual = floor(s.x);
        assertEq(actual, s.expected);
    }
}
