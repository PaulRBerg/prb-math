// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { uUNIT } from "src/ud60x18/Constants.sol";
import { MAX_POW10_EXPONENT, convert } from "src/ud60x18/Conversions.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { Base_Test } from "../../../Base.t.sol";

contract ConvertDecimals_Fuzz_Test is Base_Test {
    /// @dev A whole number scaled to `decimals` (0 through 18) converts to the same UD60x18 value as {convert(uint256)}.
    function testFuzz_ConvertTo_AtMost18Decimals(uint256 whole, uint8 decimals) external pure {
        decimals = uint8(bound(decimals, 0, 18));
        whole = bound(whole, 0, type(uint256).max / uUNIT);

        uint256 tenDecimals = 10 ** uint256(decimals);
        if (whole != 0 && tenDecimals > type(uint256).max / whole) {
            whole = type(uint256).max / tenDecimals;
        }
        uint256 raw = whole * tenDecimals;

        assertEq(convert(raw, decimals), convert(whole), "UD60x18 convert to decimals");
    }

    /// @dev Going to more than 18 decimals and back drops the digits below the UD60x18 resolution.
    function testFuzz_ConvertTo_Above18Decimals_RoundTrip(uint256 raw, uint8 extra) external pure {
        extra = uint8(bound(extra, 1, MAX_POW10_EXPONENT));
        uint8 decimals = 18 + extra;
        uint256 scale = 10 ** uint256(extra);

        UD60x18 converted = convert(raw, decimals);
        assertEq(converted.unwrap(), raw / scale, "scaled down");
        assertEq(convert(converted, decimals), (raw / scale) * scale, "round trip drops remainder");
    }

    /// @dev Going from UD60x18 to at most 18 decimals and back is the original value with the truncated digits restored as zero.
    function testFuzz_ConvertFrom_AtMost18Decimals_RoundTrip(uint256 magnitude, uint8 decimals) external pure {
        decimals = uint8(bound(decimals, 0, 18));
        UD60x18 x = UD60x18.wrap(magnitude);
        uint256 scale = 10 ** uint256(18 - decimals);

        uint256 raw = convert(x, decimals);
        assertEq(raw, magnitude / scale, "scaled down");
        assertEq(convert(raw, decimals).unwrap(), (magnitude / scale) * scale, "round trip");
    }

    /// @dev A UD60x18 value that fits at the finer scale converts back unchanged.
    function testFuzz_ConvertFrom_Above18Decimals_RoundTrip(uint256 whole, uint8 extra) external pure {
        extra = uint8(bound(extra, 1, MAX_POW10_EXPONENT));
        uint256 scale = 10 ** uint256(extra);
        whole = bound(whole, 0, type(uint256).max / scale);
        uint8 decimals = 18 + extra;

        UD60x18 x = UD60x18.wrap(whole);
        uint256 raw = convert(x, decimals);
        assertEq(raw, whole * scale, "scaled up");
        assertEq(convert(raw, decimals), x, "round trip");
    }
}
