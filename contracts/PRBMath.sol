// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/// @title PRBMath
/// @author Paul Razvan Berg
/// @notice Smart contract library for mathematical functions that works with int256 numbers considered to have 18
/// decimals. We call this form 59.18 decimal fixed-point numbers, since there can be up to 59 digits in the 59
/// digits in the integer part and up to 18 digits in the fractional part.
library PRBMath {
    /// @dev Half the UNIT number.
    int256 internal constant HALF_UNIT = 5e17;

    /// @dev The maximum value a 59.18 decimal fixed-point number can have.
    int256 internal constant MAX_59x18 = type(int256).max;

    /// @dev The maximum whole value a 59.18 decimal fixed-point number can have.
    int256 internal constant MAX_WHOLE_59x18 = type(int256).max - (type(int256).max % UNIT);

    /// @dev The minimum value a 59.18 decimal fixed-point number can have.
    int256 internal constant MIN_59x18 = type(int256).min;

    /// @dev The minimum whole value a 59.18 decimal fixed-point number can have.
    int256 internal constant MIN_WHOLE_59x18 = type(int256).min - (type(int256).min % UNIT);

    /// @dev Twice the UNI number.
    int256 internal constant TWICE_UNIT = 2e18;

    /// @dev Constant that determines how many decimals can be represented.
    int256 internal constant UNIT = 1e18;

    /// INTERNAL FUNCTIONS ///

    /// @notice Calculate the absolute value of x.
    ///
    /// @dev Requirements:
    /// - x must be higher than min 59.18.
    ///
    /// @param x The number to calculate the absolute for.
    /// @param result The absolute value of x.
    function abs(int256 x) internal pure returns (int256 result) {
        require(x > MIN_59x18);
        return x < 0 ? -x : x;
    }

    /// @notice Calculates arithmetic average of x and y, rounding down.
    /// @param x The first operand as a 59.18 decimal fixed-point number.
    /// @param y The second operand as a 59.18 decimal fixed-point number.
    /// @return result The arithmetic average as a 59.18 decimal fixed-point number.
    function avg(int256 x, int256 y) internal pure returns (int256 result) {
        // The operations can never overflow.
        unchecked {
            // The last operand checks if both x and y are odd and if yes, it adds 1 to the result. We need it
            // because if both numbers are odd, the 0.5 remainder gets truncated twice.
            result = (x >> 1) + (y >> 1) + (x & y & 1);
        }
    }

    /// @notice Yields the least integer greater than or equal to x.
    ///
    /// @dev See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions
    ///
    /// Requirements:
    /// - x must be less than or equal to the maximum whole value allowed by the 59.18 decimal fixed-point format.
    ///
    /// @param x The 59.18 decimal fixed-point number to ceil.
    /// @param result The least integer greater than or equal to x.
    function ceil(int256 x) internal pure returns (int256 result) {
        require(x <= MAX_WHOLE_59x18);
        if (x % UNIT == 0) {
            result = x;
        } else {
            // Solidity uses C fmod style, which returns a value with the same sign as x.
            result = x - (x % UNIT);
            if (x > 0) {
                result += UNIT;
            }
        }
    }

    /// @notice Divides two 59.18 decimal fixed-point numbers, returning a new 59.18 decimal fixed-point number.
    /// @dev Works by scaling the numerator first, then dividing by the denominator.
    ///
    /// Requirements:
    /// - y cannot be zero
    /// - x * UNIT must not be higher than MAX_59x18
    ///
    /// Caveats:
    /// - Susceptible to phantom overflow when x * UNIT > MAX_59x18
    ///
    /// @param x The numerator as a 59.18 decimal fixed-point number.
    /// @param y The denominator as a 59.18 decimal fixed-point number.
    /// @param result The quotient as a 59.18 decimal fixed-point number.
    function div(int256 x, int256 y) internal pure returns (int256 result) {
        int256 scaledNumerator = x * UNIT;
        // Overflows can happen only when the scaled numerator is MIN_59x18 and the denominator is -1, but the scaled
        // numerator ends in 18 zeros so it can't be MIN_59x18.
        // See https://ethereum.stackexchange.com/questions/96482/can-division-underflow-or-overflow-in-solidity
        unchecked {
            result = scaledNumerator / y;
        }
    }

    /// @notice Returns Euler's number in 59.18 decimal fixed-point representation.
    /// @dev See https://en.wikipedia.org/wiki/E_(mathematical_constant).
    function e() internal pure returns (int256 result) {
        result = 2718281828459045235;
    }

    /// @notice Calculates the natural exponent of x.
    ///
    /// @dev Based on the insight that e^x = 2^(x * log2(e)),
    ///
    /// Requirements:
    /// - x must be lower than 88.722839111672999628.
    /// - All from "log2".
    ///
    /// @param x The exponent as a 59.18 decimal fixed-point number.
    /// @return result The result as a 59.18 decimal fixed-point number.
    function exp(int256 x) internal pure returns (uint256 result) {
        // Otherwise the value passed to "exp2" would be higher than 128e18.
        require(x < 88722839111672999628);
        unchecked {
            int256 log2_e = 1442695040888963407;
            result = exp2(mul(x, log2_e));
        }
    }

    /// @notice Calculates the binary exponent of x using the binary fraction method.
    /// @dev See https://ethereum.stackexchange.com/q/79903/24693
    ///
    /// Requirements:
    /// - x must be 128e18 or lower.
    /// - x must be 0 or higher.
    ///
    /// @param x The exponent as a 59.18 decimal fixed-point number.
    /// @return result The result as a 59.18 decimal fixed-point number.
    function exp2(int256 x) internal pure returns (uint256 result) {
        // 2**128 doesn't fit within the 128.128-bit format used internally in this function.
        require(x < 128e18);

        // TODO: remove this check and make the function compatible with negative numbers.
        require(x >= 0);

        // prettier-ignore
        unchecked {
            // Convert x to the 128.128-bit fixed-point format.
            uint256 xb = uint256(x) * 2**128 / uint256(UNIT);

            // Start from 0.5 in the 128.128-bit fixed-point format.
            result = 0x80000000000000000000000000000000;

            // Multiply the result by root(2, 2^-i) when the bit at position i is 1. None of the intermediary results overflows
            // because the initial result is 2^127 and all magic factors are lower than 2^129.
            if (xb & 0x80000000000000000000000000000000 > 0) result = (result * 0x16A09E667F3BCC908B2FB1366EA957D3E) >> 128;
            if (xb & 0x40000000000000000000000000000000 > 0) result = (result * 0x1306FE0A31B7152DE8D5A46305C85EDED) >> 128;
            if (xb & 0x20000000000000000000000000000000 > 0) result = (result * 0x1172B83C7D517ADCDF7C8C50EB14A7920 ) >> 128;
            if (xb & 0x10000000000000000000000000000000 > 0) result = (result * 0x10B5586CF9890F6298B92B71842A98364) >> 128;
            if (xb & 0x8000000000000000000000000000000 > 0) result = (result * 0x1059B0D31585743AE7C548EB68CA417FE) >> 128;
            if (xb & 0x4000000000000000000000000000000 > 0) result = (result * 0x102C9A3E778060EE6F7CACA4F7A29BDE9) >> 128;
            if (xb & 0x2000000000000000000000000000000 > 0) result = (result * 0x10163DA9FB33356D84A66AE336DCDFA40) >> 128;
            if (xb & 0x1000000000000000000000000000000 > 0) result = (result * 0x100B1AFA5ABCBED6129AB13EC11DC9544) >> 128;
            if (xb & 0x800000000000000000000000000000 > 0) result = (result * 0x10058C86DA1C09EA1FF19D294CF2F679C) >> 128;
            if (xb & 0x400000000000000000000000000000 > 0) result = (result * 0x1002C605E2E8CEC506D21BFC89A23A011) >> 128;
            if (xb & 0x200000000000000000000000000000 > 0) result = (result * 0x100162F3904051FA128BCA9C55C31E5E0) >> 128;
            if (xb & 0x100000000000000000000000000000 > 0) result = (result * 0x1000B175EFFDC76BA38E31671CA939726) >> 128;
            if (xb & 0x80000000000000000000000000000 > 0) result = (result * 0x100058BA01FB9F96D6CACD4B180917C3E) >> 128;
            if (xb & 0x40000000000000000000000000000 > 0) result = (result * 0x10002C5CC37DA9491D0985C348C68E7B4) >> 128;
            if (xb & 0x20000000000000000000000000000 > 0) result = (result * 0x1000162E525EE054754457D5995292027) >> 128;
            if (xb & 0x10000000000000000000000000000 > 0) result = (result * 0x10000B17255775C040618BF4A4ADE83FD) >> 128;
            if (xb & 0x8000000000000000000000000000 > 0) result = (result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAC) >> 128;
            if (xb & 0x4000000000000000000000000000 > 0) result = (result * 0x100002C5C89D5EC6CA4D7C8ACC017B7CA) >> 128;
            if (xb & 0x2000000000000000000000000000 > 0) result = (result * 0x10000162E43F4F831060E02D839A9D16D) >> 128;
            if (xb & 0x1000000000000000000000000000 > 0) result = (result * 0x100000B1721BCFC99D9F890EA06911763) >> 128;
            if (xb & 0x800000000000000000000000000 > 0) result = (result * 0x10000058B90CF1E6D97F9CA14DBCC1629) >> 128;
            if (xb & 0x400000000000000000000000000 > 0) result = (result * 0x1000002C5C863B73F016468F6BAC5CA2C) >> 128;
            if (xb & 0x200000000000000000000000000 > 0) result = (result * 0x100000162E430E5A18F6119E3C02282A6) >> 128;
            if (xb & 0x100000000000000000000000000 > 0) result = (result * 0x1000000B1721835514B86E6D96EFD1BFF) >> 128;
            if (xb & 0x80000000000000000000000000 > 0) result = (result * 0x100000058B90C0B48C6BE5DF846C5B2F0) >> 128;
            if (xb & 0x40000000000000000000000000 > 0) result = (result * 0x10000002C5C8601CC6B9E94213C72737B) >> 128;
            if (xb & 0x20000000000000000000000000 > 0) result = (result * 0x1000000162E42FFF037DF38AA2B219F07) >> 128;
            if (xb & 0x10000000000000000000000000 > 0) result = (result * 0x10000000B17217FBA9C739AA5819F44FA) >> 128;
            if (xb & 0x8000000000000000000000000 > 0) result = (result * 0x1000000058B90BFCDEE5ACD3C1CEDC824) >> 128;
            if (xb & 0x4000000000000000000000000 > 0) result = (result * 0x100000002C5C85FE31F35A6A30DA1BE51) >> 128;
            if (xb & 0x2000000000000000000000000 > 0) result = (result * 0x10000000162E42FF0999CE3541B9FFFD0) >> 128;
            if (xb & 0x1000000000000000000000000 > 0) result = (result * 0x100000000B17217F80F4EF5AADDA45554) >> 128;
            if (xb & 0x800000000000000000000000 > 0) result = (result * 0x10000000058B90BFBF8479BD5A81B51AE) >> 128;
            if (xb & 0x400000000000000000000000 > 0) result = (result * 0x1000000002C5C85FDF84BD62AE30A74CD) >> 128;
            if (xb & 0x200000000000000000000000 > 0) result = (result * 0x100000000162E42FEFB2FED257559BDAA) >> 128;
            if (xb & 0x100000000000000000000000 > 0) result = (result * 0x1000000000B17217F7D5A7716BBA4A9AF) >> 128;
            if (xb & 0x80000000000000000000000 > 0) result = (result * 0x100000000058B90BFBE9DDBAC5E109CCF) >> 128;
            if (xb & 0x40000000000000000000000 > 0) result = (result * 0x10000000002C5C85FDF4B15DE6F17EB0E) >> 128;
            if (xb & 0x20000000000000000000000 > 0) result = (result * 0x1000000000162E42FEFA494F1478FDE05) >> 128;
            if (xb & 0x10000000000000000000000 > 0) result = (result * 0x10000000000B17217F7D20CF927C8E94D) >> 128;
            if (xb & 0x8000000000000000000000 > 0) result = (result * 0x1000000000058B90BFBE8F71CB4E4B33E) >> 128;
            if (xb & 0x4000000000000000000000 > 0) result = (result * 0x100000000002C5C85FDF477B662B26946) >> 128;
            if (xb & 0x2000000000000000000000 > 0) result = (result * 0x10000000000162E42FEFA3AE53369388D) >> 128;
            if (xb & 0x1000000000000000000000 > 0) result = (result * 0x100000000000B17217F7D1D351A389D41) >> 128;
            if (xb & 0x800000000000000000000 > 0) result = (result * 0x10000000000058B90BFBE8E8B2D3D4EDF) >> 128;
            if (xb & 0x400000000000000000000 > 0) result = (result * 0x1000000000002C5C85FDF4741BEA6E77F) >> 128;
            if (xb & 0x200000000000000000000 > 0) result = (result * 0x100000000000162E42FEFA39FE95583C3) >> 128;
            if (xb & 0x100000000000000000000 > 0) result = (result * 0x1000000000000B17217F7D1CFB72B45E3) >> 128;
            if (xb & 0x80000000000000000000 > 0) result = (result * 0x100000000000058B90BFBE8E7CC35C3F2) >> 128;
            if (xb & 0x40000000000000000000 > 0) result = (result * 0x10000000000002C5C85FDF473E242EA39) >> 128;
            if (xb & 0x20000000000000000000 > 0) result = (result * 0x1000000000000162E42FEFA39F02B772C) >> 128;
            if (xb & 0x10000000000000000000 > 0) result = (result * 0x10000000000000B17217F7D1CF7D83C1A) >> 128;
            if (xb & 0x8000000000000000000 > 0) result = (result * 0x1000000000000058B90BFBE8E7BDCBE2E) >> 128;
            if (xb & 0x4000000000000000000 > 0) result = (result * 0x100000000000002C5C85FDF473DEA871F) >> 128;
            if (xb & 0x2000000000000000000 > 0) result = (result * 0x10000000000000162E42FEFA39EF44D92) >> 128;
            if (xb & 0x1000000000000000000 > 0) result = (result * 0x100000000000000B17217F7D1CF79E949) >> 128;
            if (xb & 0x800000000000000000 > 0) result = (result * 0x10000000000000058B90BFBE8E7BCE545) >> 128;
            if (xb & 0x400000000000000000 > 0) result = (result * 0x1000000000000002C5C85FDF473DE6ECA) >> 128;
            if (xb & 0x200000000000000000 > 0) result = (result * 0x100000000000000162E42FEFA39EF366F) >> 128;
            if (xb & 0x100000000000000000 > 0) result = (result * 0x1000000000000000B17217F7D1CF79AFA) >> 128;
            if (xb & 0x80000000000000000 > 0) result = (result * 0x100000000000000058B90BFBE8E7BCD6E) >> 128;
            if (xb & 0x40000000000000000 > 0) result = (result * 0x10000000000000002C5C85FDF473DE6B3) >> 128;
            if (xb & 0x20000000000000000 > 0) result = (result * 0x1000000000000000162E42FEFA39EF359) >> 128;
            if (xb & 0x10000000000000000 > 0) result = (result * 0x10000000000000000B17217F7D1CF79AC) >> 128;

            // Multiply the result by the integer part 2^n + 1. We shift by one bit extra because we have already divided
            // by two when we set the result equal to 0.5 above.
            result = result << ((xb >> 128) + 1);

            // Convert the result to the 59.18 decimal fixed-point format.
            result = mulDiv(result, uint256(UNIT), 2**128);
        }
    }

    /// @notice Yields the greatest integer less than or equal to x.
    ///
    /// @dev See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions
    ///
    /// Requirements:
    /// - x must be greater than or equal to the minimum whole value allowed by the 59.18 decimal fixed-point format.
    ///
    /// @param x The 59.18 decimal fixed-point number to floor.
    /// @param result The greatest integer less than or equal to x.
    function floor(int256 x) internal pure returns (int256 result) {
        require(x >= MIN_WHOLE_59x18);
        if (x % UNIT == 0) {
            result = x;
        } else {
            // Solidity uses C fmod style, which returns a value with the same sign as x.
            result = x - (x % UNIT);
            if (x < 0) {
                result -= UNIT;
            }
        }
    }

    /// @notice Yields the excess beyond x's floored value for positive numbers and the part of the number to the right
    /// of the radix point for negative numbers.
    /// @dev Based on the odd function definition. https://en.wikipedia.org/wiki/Fractional_part
    /// @param x The 59.18 decimal fixed-point number to get the fractional part of.
    /// @param result The fractional part of x as a 59.18 decimal fixed-point number.
    function frac(int256 x) internal pure returns (int256 result) {
        result = x % UNIT;
    }

    /// @notice Calculates geometric mean of x and y, i.e. sqrt(x * y), rounding down.
    /// @dev Requirements:
    /// - x * y must be lower than MAX_59.18.
    /// - x * y cannot be negative.
    ///
    /// @param x The first operand as a 59.18 decimal fixed-point number.
    /// @param y The second operand as a 59.18 decimal fixed-point number.
    /// @return result The result as a 59.18 decimal fixed-point number.
    function gm(int256 x, int256 y) internal pure returns (int256 result) {
        int256 xy = x * y;
        require(xy >= 0);

        // We don't need to multiply by the UNIT here because the x*y product had already picked up a factor of UNIT
        // during multiplication. See the comments within the "sqrt" function.
        result = int256(sqrtUint256(uint256(xy)));
    }

    /// @notice Calculates 1 / x, rounding towards zero.
    ///
    /// @dev Requirements:
    /// - x cannot be zero.
    ///
    /// @param x The 59.18 decimal fixed point number for which to calculate the inverse.
    /// @return result The inverse as a 59.18 decimal fixed point number fixed point number
    function inv(int256 x) internal pure returns (int256 result) {
        unchecked {
            result = (UNIT * UNIT) / x;
        }
    }

    /// @notice Calculates the natural logarithm of x.
    ///
    /// @dev Based on the insight that ln(x) = log2(x) * ln(2).
    ///
    /// Requirements:
    /// - All from "log2".
    ///
    /// Caveats:
    /// - All from "log2".
    /// - This doesn't return exactly 1 for 2.718281828459045235, for that we would need more fine-grained precision.
    ///
    /// @param x The 59.18 decimal fixed-point number for which to calculate the natural logarithm.
    /// @return result The natural logarithm as a 59.18 decimal fixed-point number.
    function ln(int256 x) internal pure returns (int256 result) {
        require(x > 0);
        int256 ln_2 = 693147180559945309;
        result = mul(log2(x), ln_2);
    }

    /// @notice Calculates the common logarithm of x.
    ///
    /// @dev First checks if x is an exact power of ten and it stops if yes. If it's not, calculates the common
    /// logarithm based on the insight that log10(x) = log2(x) / log2(10).
    ///
    /// Requirements:
    /// - All from "log2".
    ///
    /// Caveats:
    /// - All from "log2".
    ///
    /// @param x The 59.18 decimal fixed-point number for which to calculate the common logarithm.
    /// @return result The common logarithm as a 59.18 decimal fixed-point number.
    function log10(int256 x) internal pure returns (int256 result) {
        require(x > 0);
        result = MAX_59x18;

        // Note that the "mul" in this block is the assembly mul operation, not our function defined in this contract.
        // prettier-ignore
        assembly {
            switch x
            case 1 { result := mul(UNIT, sub(0, 18)) }
            case 10 { result := mul(UNIT, sub(0, 17)) }
            case 100 { result := mul(UNIT, sub(0, 16)) }
            case 1000 { result := mul(UNIT, sub(0, 15)) }
            case 10000 { result := mul(UNIT, sub(0, 14)) }
            case 100000 { result := mul(UNIT, sub(0, 13)) }
            case 1000000 { result := mul(UNIT, sub(0, 12)) }
            case 10000000 { result := mul(UNIT, sub(0, 11)) }
            case 100000000 { result := mul(UNIT, sub(0, 10)) }
            case 1000000000 { result := mul(UNIT, sub(0, 9)) }
            case 10000000000 { result := mul(UNIT, sub(0, 8)) }
            case 100000000000 { result := mul(UNIT, sub(0, 7)) }
            case 1000000000000 { result := mul(UNIT, sub(0, 6)) }
            case 10000000000000 { result := mul(UNIT, sub(0, 5)) }
            case 100000000000000 { result := mul(UNIT, sub(0, 4)) }
            case 1000000000000000 { result := mul(UNIT, sub(0, 3)) }
            case 10000000000000000 { result := mul(UNIT, sub(0, 2)) }
            case 100000000000000000 { result := mul(UNIT, sub(0, 1)) }
            case 1000000000000000000 { result := 0 }
            case 10000000000000000000 { result := UNIT }
            case 100000000000000000000 { result := mul(UNIT, 2) }
            case 1000000000000000000000 { result := mul(UNIT, 3) }
            case 10000000000000000000000 { result := mul(UNIT, 4) }
            case 100000000000000000000000 { result := mul(UNIT, 5) }
            case 1000000000000000000000000 { result := mul(UNIT, 6) }
            case 10000000000000000000000000 { result := mul(UNIT, 7) }
            case 100000000000000000000000000 { result := mul(UNIT, 8) }
            case 1000000000000000000000000000 { result := mul(UNIT, 9) }
            case 10000000000000000000000000000 { result := mul(UNIT, 10) }
            case 100000000000000000000000000000 { result := mul(UNIT, 11) }
            case 1000000000000000000000000000000 { result := mul(UNIT, 12) }
            case 10000000000000000000000000000000 { result := mul(UNIT, 13) }
            case 100000000000000000000000000000000 { result := mul(UNIT, 14) }
            case 1000000000000000000000000000000000 { result := mul(UNIT, 15) }
            case 10000000000000000000000000000000000 { result := mul(UNIT, 16) }
            case 100000000000000000000000000000000000 { result := mul(UNIT, 17) }
            case 1000000000000000000000000000000000000 { result := mul(UNIT, 18) }
            case 10000000000000000000000000000000000000 { result := mul(UNIT, 19) }
            case 100000000000000000000000000000000000000 { result := mul(UNIT, 20) }
            case 1000000000000000000000000000000000000000 { result := mul(UNIT, 21) }
            case 10000000000000000000000000000000000000000 { result := mul(UNIT, 22) }
            case 100000000000000000000000000000000000000000 { result := mul(UNIT, 23) }
            case 1000000000000000000000000000000000000000000 { result := mul(UNIT, 24) }
            case 10000000000000000000000000000000000000000000 { result := mul(UNIT, 25) }
            case 100000000000000000000000000000000000000000000 { result := mul(UNIT, 26) }
            case 1000000000000000000000000000000000000000000000 { result := mul(UNIT, 27) }
            case 10000000000000000000000000000000000000000000000 { result := mul(UNIT, 28) }
            case 100000000000000000000000000000000000000000000000 { result := mul(UNIT, 29) }
            case 1000000000000000000000000000000000000000000000000 { result := mul(UNIT, 30) }
            case 10000000000000000000000000000000000000000000000000 { result := mul(UNIT, 31) }
            case 100000000000000000000000000000000000000000000000000 { result := mul(UNIT, 32) }
            case 1000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 33) }
            case 10000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 34) }
            case 100000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 35) }
            case 1000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 36) }
            case 10000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 37) }
            case 100000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 38) }
            case 1000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 39) }
            case 10000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 40) }
            case 100000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 41) }
            case 1000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 42) }
            case 10000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 43) }
            case 100000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 44) }
            case 1000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 45) }
            case 10000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 46) }
            case 100000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 47) }
            case 1000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 48) }
            case 10000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 49) }
            case 100000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 50) }
            case 1000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 51) }
            case 10000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 52) }
            case 100000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 53) }
            case 1000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 54) }
            case 10000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 55) }
            case 100000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 56) }
            case 1000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 57) }
            case 10000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 58) }
        }

        if (result == MAX_59x18) {
            int256 log2_10 = 332192809488736234;
            unchecked {
                // Implement the "div" function inline.
                result = (log2(x) * UNIT) / log2_10;
            }
        }
    }

    /// @notice Calculates the binary logarithm of x.
    ///
    /// @dev Based on the iterative approximation algorithm.
    /// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
    ///
    /// Requirements:
    /// - x must be higher than zero.
    ///
    /// Caveats:
    /// - The results are nor perfectly accurate to the last digit, due to the precision of the iterative approximation.
    ///
    /// @param x The 59.18 decimal fixed-point number for which to calculate the binary logarithm.
    /// @return result The binary logarithm as a 59.18 decimal fixed-point number.
    function log2(int256 x) internal pure returns (int256 result) {
        require(x > 0);

        // TODO: explain this
        int256 sign;
        if (x >= UNIT) {
            sign = 1;
        } else {
            sign = -1;
            x = div(UNIT, x);
        }

        // Calculate the integer part n, add it to the result and finally calculate y = x * 2^(-n).
        uint256 quotient = uint256(x / UNIT);
        uint256 n = mostSignificantBit(quotient);
        result = int256(n) * UNIT * sign;
        int256 y = x >> n;

        // If y = 1, the fractional part is zero.
        if (y == UNIT) {
            return result;
        }

        // Calculate the fractional part via the iterative approximation.
        int256 delta;
        for (delta = HALF_UNIT; delta > 0; delta >>= 1) {
            // TODO: replace this with "mul"
            y = (y * y) / UNIT;

            // Is y^2 > 2 and so in the range [2,4)?
            if (y >= TWICE_UNIT) {
                // Add the 2^(-m) factor to the logarithm.
                result += delta * sign;

                // Corresponds to z/2 on Wikipedia.
                y >>= 1;
            }
        }
    }

    /// @notice Multiplies two 59.18 decimal fixed-point numbers, returning a new 59.18 decimal fixed-point number.
    /// @dev Requirements:
    /// - x * y must not be higher than MAX_59x18 or smaller than MIN_59x18
    /// - x * y +/- HALF_UNIT must not be higher than MAX_59x18/ smaller than MIN_59x18
    ///
    /// Caveats:
    /// - Susceptible to phantom overflow when (x * y > MAX_59x18) OR (x * y < MIN_59x18)
    /// - Susceptible to phantom overflow when (x * y + HALF_UNIT > MAX_59x18) OR (x * y - HALF_UNIT < MIN_59x18)
    ///
    /// @param x The first operand as a 59.18 decimal fixed-point number.
    /// @param y The second operand as a 59.18 decimal fixed-point number.
    /// @param result The product as a 59.18 decimal fixed-point number.
    function mul(int256 x, int256 y) internal pure returns (int256 result) {
        int256 doubleScaledProduct = x * y;

        // Before dividing, we add half the UNIT for positive products and subtract half the UNIT for negative products,
        // so that we get rounding instead of truncation. Without this, 6.6e-19 would be truncated to 0 instead of being
        // rounded to 1e-18. See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
        int256 doubleScaledProductWithHalfUnit =
            doubleScaledProduct > 0 ? (doubleScaledProduct + HALF_UNIT) : (doubleScaledProduct - HALF_UNIT);

        unchecked {
            result = doubleScaledProductWithHalfUnit / UNIT;
        }
    }

    /// @notice Returns PI in 59.18 decimal fixed-point representation.
    function pi() internal pure returns (int256 result) {
        result = 3141592653589793238;
    }

    /// @notice Calculates the square root of x, rounding down.
    /// @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
    ///
    /// Requirements:
    /// - x must be zero or higher.
    /// - x must be lower than MAX_59x18 / UNIT.
    ///
    /// @param x The 59.18 decimal fixed-point number for which to calculate the square root.
    /// @return result The result as a 59.18 decimal fixed-point .
    function sqrt(int256 x) internal pure returns (int256 result) {
        require(x >= 0);
        require(x < 57896044618658097711785492504343953926634992332820282019729);
        unchecked {
            // Multiply x by the UNIT to account for the factor of UNIT that is picked up when multiplying two 59.18
            // decimal fixed-point numbers together (in this, both numbers are the square root).
            result = int256(sqrtUint256(uint256(x * UNIT)));
        }
    }

    /// @notice Returns 1 in 59.18 decimal fixed-point representation.
    function unit() internal pure returns (int256 result) {
        result = UNIT;
    }

    /// PRIVATE FUNCTIONS ///

    /// @notice Finds the zero-based index of the first one in the binary representation of x.
    /// @dev See the note on msb in the "Find First Set" Wikipedia article https://en.wikipedia.org/wiki/Find_first_set
    ///
    /// Caveats:
    /// - This function does not assume the 59.18 decimal fixed-point representation.
    ///
    /// @param x The uint256 number for which to find the index of the most significant bit.
    /// @return msb The index of the most significant bit as an uint256.
    function mostSignificantBit(uint256 x) private pure returns (uint256 msb) {
        if (x >= 2**128) {
            x >>= 128;
            msb += 128;
        }
        if (x >= 2**64) {
            x >>= 64;
            msb += 64;
        }
        if (x >= 2**32) {
            x >>= 32;
            msb += 32;
        }
        if (x >= 2**16) {
            x >>= 16;
            msb += 16;
        }
        if (x >= 2**8) {
            x >>= 8;
            msb += 8;
        }
        if (x >= 2**4) {
            x >>= 4;
            msb += 4;
        }
        if (x >= 2**2) {
            x >>= 2;
            msb += 2;
        }
        if (x >= 2**1) {
            // No need to shift x any more.
            msb += 1;
        }
    }

    /// @notice Calculates floor(a×b÷denominator) with full precision.
    /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
    ///
    /// Requirements:
    /// - `denominator` cannot be zero
    /// - result must fit within uint256
    ///
    /// Caveats:
    /// - This function does not assume the 59.18 decimal fixed-point representation.
    ///
    /// @param x The multiplicand as an uint256.
    /// @param y The multiplier as an uint256.
    /// @param denominator The divisor as an uint256.
    /// @return result The result as an uint256.
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) private pure returns (uint256 result) {
        // 512-bit multiply [prod1 prod0] = a * b. Compute the product mod 2**256 and mod 2**256 - 1, then use
        // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
        // variables such that product = prod1 * 2**256 + prod0
        uint256 prod0; // Least significant 256 bits of the product
        uint256 prod1; // Most significant 256 bits of the product
        assembly {
            let mm := mulmod(x, y, not(0))
            prod0 := mul(x, y)
            prod1 := sub(sub(mm, prod0), lt(mm, prod0))
        }

        // Handle non-overflow cases, 256 by 256 division
        if (prod1 == 0) {
            require(denominator > 0);
            assembly {
                result := div(prod0, denominator)
            }
            return result;
        }

        // Make sure the result is less than 2**256. Also prevents denominator == 0.
        require(denominator > prod1);

        ///////////////////////////////////////////////
        // 512 by 256 division.
        ///////////////////////////////////////////////

        // Make division exact by subtracting the remainder from [prod1 prod0]. Compute remainder using mulmod.
        uint256 remainder;
        assembly {
            remainder := mulmod(x, y, denominator)
        }
        // Subtract 256 bit number from 512 bit number
        assembly {
            prod1 := sub(prod1, gt(remainder, prod0))
            prod0 := sub(prod0, remainder)
        }

        // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
        unchecked {
            uint256 lpotd = (type(uint256).max - denominator + 1) & denominator;
            // Divide denominator by power of two
            assembly {
                denominator := div(denominator, lpotd)
            }

            // Divide [prod1 prod0] by the factors of two
            assembly {
                prod0 := div(prod0, lpotd)
            }
            // Shift in bits from prod1 into prod0. For this we need to flip `lpotd` such that it is 2**256 / twos.
            // If `lpotd` is zero, then it becomes one.
            assembly {
                lpotd := add(div(sub(0, lpotd), lpotd), 1)
            }
            prod0 |= prod1 * lpotd;

            // Invert denominator mod 2**256. Now that denominator is an odd number, it has an inverse modulo 2**256 such
            // that denominator * inv = 1 mod 2**256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2**4
            uint256 inverse = (3 * denominator) ^ 2;
            // Now use Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2**8
            inverse *= 2 - denominator * inverse; // inverse mod 2**16
            inverse *= 2 - denominator * inverse; // inverse mod 2**32
            inverse *= 2 - denominator * inverse; // inverse mod 2**64
            inverse *= 2 - denominator * inverse; // inverse mod 2**128
            inverse *= 2 - denominator * inverse; // inverse mod 2**256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2**256. Since the precoditions guarantee that the outcome is
            // less than 2**256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /// @notice Calculates the square root of x, rounding down.
    /// @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
    ///
    /// Caveats:
    /// - This function does not assume the 59.18 decimal fixed-point representation.
    ///
    /// @param x The uint256 number for which to calculate the square root.
    /// @return result The result as an uint256.
    function sqrtUint256(uint256 x) private pure returns (uint256 result) {
        if (x == 0) {
            return 0;
        }

        // Calculate the square root of the perfect square of a power of two that is the closest to x.
        uint256 x_aux = uint256(x);
        uint256 x0 = 1;
        if (x_aux >= 0x100000000000000000000000000000000) {
            x_aux >>= 128;
            x0 <<= 64;
        }
        if (x_aux >= 0x10000000000000000) {
            x_aux >>= 64;
            x0 <<= 32;
        }
        if (x_aux >= 0x100000000) {
            x_aux >>= 32;
            x0 <<= 16;
        }
        if (x_aux >= 0x10000) {
            x_aux >>= 16;
            x0 <<= 8;
        }
        if (x_aux >= 0x100) {
            x_aux >>= 8;
            x0 <<= 4;
        }
        if (x_aux >= 0x10) {
            x_aux >>= 4;
            x0 <<= 2;
        }
        if (x_aux >= 0x8) {
            x0 <<= 1;
        }
        result = x0;

        // The operations can never overflow because the result is max 2^127 when it enters this block.
        unchecked {
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1;
            result = (result + x / result) >> 1; // Seven iterations should be enough
            uint256 roundedDownResult = x / result;
            return result >= roundedDownResult ? roundedDownResult : result;
        }
    }
}
