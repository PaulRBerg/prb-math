// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_WHOLE_SD59x18,
    MAX_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__Exp2InputTooBig,
    SD59x18,
    ZERO,
    exp2
} from "~/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__Exp2Test is SD59x18__BaseTest {
    SD59x18 internal constant MIN_PERMITTED = SD59x18.wrap(-59_794705707972522261);
    SD59x18 internal constant MAX_PERMITTED = SD59x18.wrap(192e18);

    function testExp2__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = exp2(x);
        SD59x18 expected = sd(1e18);
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function lessThanMinSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: ZERO }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: ZERO }));
        sets.push(set({ x: MIN_PERMITTED.sub(sd(1)), expected: ZERO }));
        return sets;
    }

    function testExp2__LessThanMinPermitted() external parameterizedTest(lessThanMinSets()) NotZero {
        SD59x18 actual = exp2(s.x);
        assertEq(actual, s.expected);
    }

    modifier GreaterThanOrEqualToMinPermitted() {
        _;
    }

    function greaterThanOrEqualToMinSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_PERMITTED, expected: 1 }));
        sets.push(set({ x: -33.333333e18, expected: 92398923 }));
        sets.push(set({ x: -20.82e18, expected: 540201132438 }));
        sets.push(set({ x: -16e18, expected: 152587890625e2 }));
        sets.push(set({ x: -11.89215e18, expected: 263091088065207 }));
        sets.push(set({ x: -4e18, expected: 625e14 }));
        sets.push(set({ x: NEGATIVE_PI, expected: 113314732296760873 }));
        sets.push(set({ x: -3e18, expected: 125e15 }));
        sets.push(set({ x: NEGATIVE_E, expected: 151955223257912965 }));
        sets.push(set({ x: -2e18, expected: 25e16 }));
        sets.push(set({ x: -1e18, expected: 5e17 }));
        sets.push(set({ x: -1e3, expected: 999999999999999307 }));
        sets.push(set({ x: -1, expected: 1e18 }));
        return sets;
    }

    function testExp2__Negative()
        external
        parameterizedTest(greaterThanOrEqualToMinSets())
        NotZero
        GreaterThanOrEqualToMinPermitted
    {
        SD59x18 actual = exp2(s.x);
        assertEq(actual, s.expected);
    }

    function greaterThanOrEqualSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MAX_PERMITTED }));
        sets.push(set({ x: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18 }));
        return sets;
    }

    function testExp2__GreaterThanOrEqualToMaxPermitted()
        external
        parameterizedTest(greaterThanOrEqualSets())
        NotZero
        GreaterThanOrEqualToMinPermitted
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__Exp2InputTooBig.selector, s.x));
        exp2(s.x);
    }

    modifier LessThanMaxPermitted() {
        _;
    }

    function lessThanMaxSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1, expected: 1e18 }));
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
        sets.push(
            set({ x: 152.9065e18, expected: 10701459987152828635116598811554803403437267307_663014047009710338 })
        );
        sets.push(
            set({
                x: MAX_PERMITTED.sub(sd(1)),
                expected: 6277101735386680759401282518710514696272_033118492751795945e18
            })
        );
        return sets;
    }

    function testExp2()
        external
        parameterizedTest(lessThanMaxSets())
        NotZero
        GreaterThanOrEqualToMinPermitted
        LessThanMaxPermitted
    {
        SD59x18 actual = exp2(s.x);
        assertEq(actual, s.expected);
    }
}
