// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { sd } from "src/sd59x18/Casting.sol";
import { E, MIN_SD59x18, MIN_WHOLE_SD59x18, PI, ZERO } from "src/sd59x18/Constants.sol";
import { PRBMath_SD59x18_Exp2_InputTooBig } from "src/sd59x18/Errors.sol";
import { exp2 } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Test } from "../../SD59x18.t.sol";

contract Exp2_Test is SD59x18_Test {
    SD59x18 internal constant MAX_PERMITTED = SD59x18.wrap(192e18 - 1);
    SD59x18 internal constant MIN_PERMITTED = SD59x18.wrap(-59_794705707972522261);

    function test_Exp2_Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = exp2(x);
        SD59x18 expected = sd(1e18);
        assertEq(actual, expected);
    }

    modifier notZero() {
        _;
    }

    function negativeAndLessThanMinPermitted_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: 0 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: 0 }));
        sets.push(set({ x: MIN_PERMITTED.sub(sd(1)), expected: 0 }));
        return sets;
    }

    function test_Exp2_Negative_LessThanMinPermitted() external parameterizedTest(negativeAndLessThanMinPermitted_Sets()) notZero {
        SD59x18 actual = exp2(s.x);
        assertEq(actual, s.expected);
    }

    function negativeAndGreaterThanOrEqualToMinPermitted_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_PERMITTED, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: -33.333333e18, expected: 0.000000000092398923e18 }));
        sets.push(set({ x: -20.82e18, expected: 0.000000540201132438e18 }));
        sets.push(set({ x: -16e18, expected: 0.0000152587890625e18 }));
        sets.push(set({ x: -11.89215e18, expected: 0.000263091088065207e18 }));
        sets.push(set({ x: -4e18, expected: 0.0625e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: 0.113314732296760873e18 }));
        sets.push(set({ x: -3e18, expected: 0.125e18 }));
        sets.push(set({ x: NEGATIVE_E, expected: 0.151955223257912965e18 }));
        sets.push(set({ x: -2e18, expected: 0.25e18 }));
        sets.push(set({ x: -1e18, expected: 0.5e18 }));
        sets.push(set({ x: -0.000000000000001e18, expected: 0.999999999999999307e18 }));
        sets.push(set({ x: -0.000000000000000001e18, expected: 1e18 }));
        return sets;
    }

    function test_Exp2_Negative_GreaterThanOrEqualToMinPermitted()
        external
        parameterizedTest(negativeAndGreaterThanOrEqualToMinPermitted_Sets())
        notZero
    {
        SD59x18 actual = exp2(s.x);
        assertEq(actual, s.expected);
    }

    function test_RevertWhen_Positive_GreaterThanMaxPermitted() external notZero {
        SD59x18 x = MAX_PERMITTED.add(sd(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMath_SD59x18_Exp2_InputTooBig.selector, x));
        exp2(x);
    }

    modifier lessThanMaxPermitted() {
        _;
    }

    function positiveAndLessThanOrEqualToPermitted_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, expected: 1e18 }));
        sets.push(set({ x: 1e3, expected: 1_000000000000000693 }));
        sets.push(set({ x: 0.3212e18, expected: 1_249369313012024883 }));
        sets.push(set({ x: 1e18, expected: 2e18 }));
        sets.push(set({ x: 2e18, expected: 4e18 }));
        sets.push(set({ x: E, expected: 6_580885991017920969 }));
        sets.push(set({ x: 3e18, expected: 8e18 }));
        sets.push(set({ x: PI, expected: 8_824977827076287621 }));
        sets.push(set({ x: 4e18, expected: 16e18 }));
        sets.push(set({ x: 11.89215e18, expected: 3800_964933301542754377 }));
        sets.push(set({ x: 16e18, expected: 65536e18 }));
        sets.push(set({ x: 20.82e18, expected: 1851162_354076939434682641 }));
        sets.push(set({ x: 33.333333e18, expected: 10822636909_120553492168423503 }));
        sets.push(set({ x: 64e18, expected: 18_446744073709551616e18 }));
        sets.push(set({ x: 71.002e18, expected: 2364458806372010440881_644926416580874919 }));
        sets.push(set({ x: 88.7494e18, expected: 520273250104929479163928177_984511174562086061 }));
        sets.push(set({ x: 95e18, expected: 39614081257_132168796771975168e18 }));
        sets.push(set({ x: 127e18, expected: 170141183460469231731_687303715884105728e18 }));
        sets.push(set({ x: 152.9065e18, expected: 10701459987152828635116598811554803403437267307_663014047009710338 }));
        sets.push(set({ x: MAX_PERMITTED, expected: 6277101735386680759401282518710514696272033118492751795945e18 }));
        return sets;
    }

    function test_Exp2_Positive_LessThanOrEqualToPermittedMax()
        external
        parameterizedTest(positiveAndLessThanOrEqualToPermitted_Sets())
        notZero
    {
        SD59x18 actual = exp2(s.x);
        assertEq(actual, s.expected);
    }
}
