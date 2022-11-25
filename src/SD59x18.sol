// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import { msb, mulDiv, mulDiv18, prbExp2, prbSqrt } from "./Core.sol";

/// @notice The signed 59.18-decimal fixed-point number representation, which can have up to 59 digits and up to 18 decimals.
/// The values of this are bound by the minimum and the maximum values permitted by the underlying Solidity type int256.
type SD59x18 is int256;

/*//////////////////////////////////////////////////////////////////////////
                                CUSTOM ERRORS
//////////////////////////////////////////////////////////////////////////*/

/// @notice Emitted when taking the absolute value of `MIN_SD59x18`.
error PRBMathSD59x18__AbsMinSD59x18();

/// @notice Emitted when ceiling a number overflows SD59x18.
error PRBMathSD59x18__CeilOverflow(SD59x18 x);

/// @notice Emitted when dividing two numbers and one of them is `MIN_SD59x18`.
error PRBMathSD59x18__DivInputTooSmall();

/// @notice Emitted when dividing two numbers and one of the intermediary unsigned results overflows SD59x18.
error PRBMathSD59x18__DivOverflow(SD59x18 x, SD59x18 y);

/// @notice Emitted when taking the natural exponent of a base greater than 133.084258667509499441.
error PRBMathSD59x18__ExpInputTooBig(SD59x18 x);

/// @notice Emitted when taking the binary exponent of a base greater than 192.
error PRBMathSD59x18__Exp2InputTooBig(SD59x18 x);

/// @notice Emitted when flooring a number underflows SD59x18.
error PRBMathSD59x18__FloorUnderflow(SD59x18 x);

/// @notice Emitted when taking the geometric mean of two numbers and their product is negative.
error PRBMathSD59x18__GmNegativeProduct(SD59x18 x, SD59x18 y);

/// @notice Emitted when taking the geometric mean of two numbers and multiplying them overflows SD59x18.
error PRBMathSD59x18__GmOverflow(SD59x18 x, SD59x18 y);

/// @notice Emitted when taking the logarithm of a number less than or equal to zero.
error PRBMathSD59x18__LogInputTooSmall(SD59x18 x);

/// @notice Emitted when multiplying two numbers and one of the inputs is `MIN_SD59x18`.
error PRBMathSD59x18__MulInputTooSmall();

/// @notice Emitted when multiplying two numbers and the intermediary absolute result overflows SD59x18.
error PRBMathSD59x18__MulOverflow(SD59x18 x, SD59x18 y);

/// @notice Emitted when raising a number to a power and hte intermediary absolute result overflows SD59x18.
error PRBMathSD59x18__PowuOverflow(SD59x18 x, uint256 y);

/// @notice Emitted when taking the square root of a negative number.
error PRBMathSD59x18__SqrtNegativeInput(SD59x18 x);

/// @notice Emitted when the calculating the square root overflows SD59x18.
error PRBMathSD59x18__SqrtOverflow(SD59x18 x);

/// @notice Emitted when converting a basic integer to the fixed-point format overflows SD59x18.
error PRBMathSD59x18__ToSD59x18Overflow(int256 x);

/// @notice Emitted when converting a basic integer to the fixed-point format underflows SD59x18.
error PRBMathSD59x18__ToSD59x18Underflow(int256 x);

/*//////////////////////////////////////////////////////////////////////////
                                    CONSTANTS
//////////////////////////////////////////////////////////////////////////*/

/// @dev Euler's number as an SD59x18 number.
SD59x18 constant E = SD59x18.wrap(2_718281828459045235);

/// @dev Half the UNIT number.
int256 constant HALF_UNIT_INT256 = 0.5e18;
SD59x18 constant HALF_UNIT = SD59x18.wrap(HALF_UNIT_INT256);

/// @dev log2(10) as an SD59x18 number.
int256 constant LOG2_10_INT256 = 3_321928094887362347;
SD59x18 constant LOG2_10 = SD59x18.wrap(LOG2_10_INT256);

/// @dev log2(e) as an SD59x18 number.
int256 constant LOG2_E_INT256 = 1_442695040888963407;
SD59x18 constant LOG2_E = SD59x18.wrap(LOG2_E_INT256);

/// @dev The maximum value an SD59x18 number can have.
int256 constant MAX_SD59x18_INT256 = 57896044618658097711785492504343953926634992332820282019728_792003956564819967;
SD59x18 constant MAX_SD59x18 = SD59x18.wrap(MAX_SD59x18_INT256);
uint256 constant MAX_SD59x18_UINT256 = 57896044618658097711785492504343953926634992332820282019728_792003956564819967;

/// @dev The maximum whole value an SD59x18 number can have.
int256 constant MAX_WHOLE_SD59x18_INT256 = 57896044618658097711785492504343953926634992332820282019728_000000000000000000;
SD59x18 constant MAX_WHOLE_SD59x18 = SD59x18.wrap(MAX_WHOLE_SD59x18_INT256);

/// @dev The minimum value an SD59x18 number can have.
int256 constant MIN_SD59x18_INT256 = -57896044618658097711785492504343953926634992332820282019728_792003956564819968;
SD59x18 constant MIN_SD59x18 = SD59x18.wrap(MIN_SD59x18_INT256);

/// @dev The minimum whole value an SD59x18 number can have.
int256 constant MIN_WHOLE_SD59x18_INT256 = -57896044618658097711785492504343953926634992332820282019728_000000000000000000;
SD59x18 constant MIN_WHOLE_SD59x18 = SD59x18.wrap(MIN_WHOLE_SD59x18_INT256);

/// @dev PI as an SD59x18 number.
SD59x18 constant PI = SD59x18.wrap(3_141592653589793238);

/// @dev The unit amount which implies how many trailing decimals can be represented.
SD59x18 constant UNIT = SD59x18.wrap(1e18);
int256 constant UNIT_INT256 = 1e18;
uint256 constant UNIT_UINT256 = 1e18;

/// @dev Zero as an SD59x18 number.
SD59x18 constant ZERO = SD59x18.wrap(0);

/*//////////////////////////////////////////////////////////////////////////
                        GLOBAL-SCOPED FIXED-POINT FUNCTIONS
//////////////////////////////////////////////////////////////////////////*/

using {
    abs,
    avg,
    ceil,
    div,
    exp,
    exp2,
    floor,
    frac,
    gm,
    inv,
    log10,
    log2,
    ln,
    mul,
    pow,
    powu,
    sqrt
} for SD59x18 global;

/// @notice Calculate the absolute value of x.
///
/// @dev Requirements:
/// - x must be greater than `MIN_SD59x18`.
///
/// @param x The SD59x18 number for which to calculate the absolute value.
/// @param result The absolute value of x as an SD59x18 number.
function abs(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt == MIN_SD59x18_INT256) {
        revert PRBMathSD59x18__AbsMinSD59x18();
    }
    result = xInt < 0 ? wrap(-xInt) : x;
}

/// @notice Calculates the arithmetic average of x and y, rounding towards zero.
/// @param x The first operand as an SD59x18 number.
/// @param y The second operand as an SD59x18 number.
/// @return result The arithmetic average as an SD59x18 number.
function avg(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    int256 yInt = unwrap(y);

    unchecked {
        // This is equivalent to "x / 2 +  y / 2" but faster.
        // This operation can never overflow.
        int256 sum = (xInt >> 1) + (yInt >> 1);

        if (sum < 0) {
            // If at least one of x and y is odd, we add 1 to the result, since shifting negative numbers to the right rounds
            // down to infinity. The right part is equivalent to "sum + (x % 2 == 1 || y % 2 == 1)" but faster.
            assembly {
                result := add(sum, and(or(xInt, yInt), 1))
            }
        } else {
            // We need to add 1 if both x and y are odd to account for the double 0.5 remainder that is truncated after shifting.
            // The right part is equivalent to "sum + x & y & 1".
            result = wrap(sum + (xInt & yInt & 1));
        }
    }
}

/// @notice Yields the least SD59x18 number greater than or equal to x.
///
/// @dev Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
/// See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.
///
/// Requirements:
/// - x must be less than or equal to `MAX_WHOLE_SD59x18`.
///
/// @param x The SD59x18 number to ceil.
/// @param result The least number greater than or equal to x, as an SD59x18 number.
function ceil(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt > MAX_WHOLE_SD59x18_INT256) {
        revert PRBMathSD59x18__CeilOverflow(x);
    }

    int256 remainder = xInt % UNIT_INT256;
    if (remainder == 0) {
        result = x;
    } else {
        unchecked {
            // Solidity uses C fmod style, which returns a modulus with the same sign as x.
            int256 resultInt = xInt - remainder;
            if (xInt > 0) {
                resultInt += UNIT_INT256;
            }
            result = wrap(resultInt);
        }
    }
}

/// @notice Divides two SD59x18 numbers, returning a new SD59x18 number. Rounds towards zero.
///
/// @dev This is a variant of `mulDiv` that works with signed numbers. Works by computing the signs and the absolute values
/// separately.
///
/// Requirements:
/// - All from `Core/mulDiv`.
/// - None of the inputs can be `MIN_SD59x18`.
/// - The denominator cannot be zero.
/// - The result must fit within int256.
///
/// Caveats:
/// - All from `Core/mulDiv`.
///
/// @param x The numerator as an SD59x18 number.
/// @param y The denominator as an SD59x18 number.
/// @param result The quotient as an SD59x18 number.
function div(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    int256 yInt = unwrap(y);
    if (xInt == MIN_SD59x18_INT256 || yInt == MIN_SD59x18_INT256) {
        revert PRBMathSD59x18__DivInputTooSmall();
    }

    // Get hold of the absolute values of x and y.
    uint256 xAbs;
    uint256 yAbs;
    unchecked {
        xAbs = xInt < 0 ? uint256(-xInt) : uint256(xInt);
        yAbs = yInt < 0 ? uint256(-yInt) : uint256(yInt);
    }

    // Compute the absolute value (x*UNIT)÷y. The resulting value must fit within int256.
    uint256 resultAbs = mulDiv(xAbs, UNIT_UINT256, yAbs);
    if (resultAbs > MAX_SD59x18_UINT256) {
        revert PRBMathSD59x18__DivOverflow(x, y);
    }

    // Check if x and y have the same sign via "(x ^ y) > -1".
    // This works thanks to two's complement, the left-most bit is the sign bit.
    bool sameSign = x.xor(y).gt(wrap(-1));

    // If the inputs don't have the same sign, the result should be negative. Otherwise, it should be positive.
    unchecked {
        result = wrap(sameSign ? int256(resultAbs) : -int256(resultAbs));
    }
}

/// @notice Calculates the natural exponent of x.
///
/// @dev Based on the formula:
///
/// $$
/// e^x = 2^{x * log_2{e}}
/// $$
///
/// Requirements:
/// - All from `log2`.
/// - x must be less than 133.084258667509499441.
///
/// Caveats:
/// - All from `exp2`.
/// - For any x less than -41.446531673892822322, the result is zero.
///
/// @param x The exponent as an SD59x18 number.
/// @return result The result as an SD59x18 number.
function exp(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    // Without this check, the value passed to `exp2` would be less than -59.794705707972522261.
    if (xInt < -41_446531673892822322) {
        return ZERO;
    }

    // Without this check, the value passed to `exp2` would be greater than 192.
    if (xInt >= 133_084258667509499441) {
        revert PRBMathSD59x18__ExpInputTooBig(x);
    }

    unchecked {
        // Do the fixed-point multiplication inline to save gas.
        int256 doubleUnitProduct = xInt * LOG2_E_INT256;
        result = exp2(wrap(doubleUnitProduct / UNIT_INT256));
    }
}

/// @notice Calculates the binary exponent of x using the binary fraction method.
///
/// @dev Based on the formula:
///
/// $$
/// 2^{-x} = \frac{1}{2^x}
/// $$
///
/// See https://ethereum.stackexchange.com/q/79903/24693.
///
/// Requirements:
/// - x must be 192 or less.
/// - The result must fit within `MAX_SD59x18`.
///
/// Caveats:
/// - For any x less than -59.794705707972522261, the result is zero.
///
/// @param x The exponent as an SD59x18 number.
/// @return result The result as an SD59x18 number.
function exp2(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt < 0) {
        // 2^59.794705707972522262 is the maximum number whose inverse does not truncate down to zero.
        if (xInt < -59_794705707972522261) {
            return ZERO;
        }

        unchecked {
            // Do the fixed-point inversion $1/2^x$ inline to save gas. 1e36 is UNIT * UNIT.
            result = wrap(1e36 / unwrap(exp2(wrap(-xInt))));
        }
    } else {
        // 2^192 doesn't fit within the 192.64-bit format used internally in this function.
        if (xInt >= 192e18) {
            revert PRBMathSD59x18__Exp2InputTooBig(x);
        }

        unchecked {
            // Convert x to the 192.64-bit fixed-point format.
            uint256 x_192x64 = uint256((xInt << 64) / UNIT_INT256);

            // It is safe to convert the result to int256 with no checks because the maximum input allowed in this function is 192.
            result = wrap(int256(prbExp2(x_192x64)));
        }
    }
}

/// @notice Yields the greatest SD59x18 number less than or equal to x.
///
/// @dev Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
/// See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.
///
/// Requirements:
/// - x must be greater than or equal to `MIN_WHOLE_SD59x18`.
///
/// @param x The SD59x18 number to floor.
/// @param result The greatest integer less than or equal to x, as an SD59x18 number.
function floor(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt < MIN_WHOLE_SD59x18_INT256) {
        revert PRBMathSD59x18__FloorUnderflow(x);
    }

    int256 remainder = xInt % UNIT_INT256;
    if (remainder == 0) {
        result = x;
    } else {
        unchecked {
            // Solidity uses C fmod style, which returns a modulus with the same sign as x.
            int256 resultInt = xInt - remainder;
            if (xInt < 0) {
                resultInt -= UNIT_INT256;
            }
            result = wrap(resultInt);
        }
    }
}

/// @notice Yields the excess beyond the floor of x for positive numbers and the part of the number to the right
/// of the radix point for negative numbers.
/// @dev Based on the odd function definition. https://en.wikipedia.org/wiki/Fractional_part
/// @param x The SD59x18 number to get the fractional part of.
/// @param result The fractional part of x as an SD59x18 number.
function frac(SD59x18 x) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) % UNIT_INT256);
}

/// @notice Converts an SD59x18 number to basic integer form, rounding towards zero in the process.
/// @param x The SD59x18 number to convert.
/// @return result The same number in basic integer form.
function fromSD59x18(SD59x18 x) pure returns (int256 result) {
    result = unwrap(x) / UNIT_INT256;
}

/// @notice Calculates the geometric mean of x and y, i.e. sqrt(x * y), rounding down.
///
/// @dev Requirements:
/// - x * y must fit within `MAX_SD59x18`, lest it overflows.
/// - x * y must not be negative, since this library does not handle complex numbers.
///
/// @param x The first operand as an SD59x18 number.
/// @param y The second operand as an SD59x18 number.
/// @return result The result as an SD59x18 number.
function gm(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    int256 yInt = unwrap(y);
    if (xInt == 0 || yInt == 0) {
        return ZERO;
    }

    unchecked {
        // Equivalent to "xy / x != y". Checking for overflow this way is faster than letting Solidity do it.
        int256 xyInt = xInt * yInt;
        if (xyInt / xInt != yInt) {
            revert PRBMathSD59x18__GmOverflow(x, y);
        }

        // The product must not be negative, since this library does not handle complex numbers.
        if (xyInt < 0) {
            revert PRBMathSD59x18__GmNegativeProduct(x, y);
        }

        // We don't need to multiply the result by `UNIT` here because the x*y product had picked up a factor of `UNIT`
        // during multiplication. See the comments within the `prbSqrt` function.
        uint256 resultUint = prbSqrt(uint256(xyInt));
        result = wrap(int256(resultUint));
    }
}

/// @notice Calculates 1 / x, rounding toward zero.
///
/// @dev Requirements:
/// - x cannot be zero.
///
/// @param x The SD59x18 number for which to calculate the inverse.
/// @return result The inverse as an SD59x18 number.
function inv(SD59x18 x) pure returns (SD59x18 result) {
    // 1e36 is UNIT * UNIT.
    result = wrap(1e36 / unwrap(x));
}

/// @notice Calculates the natural logarithm of x.
///
/// @dev Based on the formula:
///
/// $$
/// ln{x} = log_2{x} / log_2{e}$$.
/// $$
///
/// Requirements:
/// - All from `log2`.
///
/// Caveats:
/// - All from `log2`.
/// - This doesn't return exactly 1 for 2.718281828459045235, for that more fine-grained precision is needed.
///
/// @param x The SD59x18 number for which to calculate the natural logarithm.
/// @return result The natural logarithm as an SD59x18 number.
function ln(SD59x18 x) pure returns (SD59x18 result) {
    // Do the fixed-point multiplication inline to save gas. This is overflow-safe because the maximum value that log2(x)
    // can return is 195.205294292027477728.
    result = wrap((unwrap(log2(x)) * UNIT_INT256) / LOG2_E_INT256);
}

/// @notice Calculates the common logarithm of x.
///
/// @dev First checks if x is an exact power of ten and it stops if yes. If it's not, calculates the common
/// logarithm based on the formula:
///
/// $$
/// log_{10}{x} = log_2{x} / log_2{10}
/// $$
///
/// Requirements:
/// - All from `log2`.
///
/// Caveats:
/// - All from `log2`.
///
/// @param x The SD59x18 number for which to calculate the common logarithm.
/// @return result The common logarithm as an SD59x18 number.
function log10(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt < 0) {
        revert PRBMathSD59x18__LogInputTooSmall(x);
    }

    // Note that the `mul` in this block is the assembly mul operation, not the SD59x18 `mul`.
    // prettier-ignore
    assembly {
        switch x
        case 1 { result := mul(UNIT_INT256, sub(0, 18)) }
        case 10 { result := mul(UNIT_INT256, sub(1, 18)) }
        case 100 { result := mul(UNIT_INT256, sub(2, 18)) }
        case 1000 { result := mul(UNIT_INT256, sub(3, 18)) }
        case 10000 { result := mul(UNIT_INT256, sub(4, 18)) }
        case 100000 { result := mul(UNIT_INT256, sub(5, 18)) }
        case 1000000 { result := mul(UNIT_INT256, sub(6, 18)) }
        case 10000000 { result := mul(UNIT_INT256, sub(7, 18)) }
        case 100000000 { result := mul(UNIT_INT256, sub(8, 18)) }
        case 1000000000 { result := mul(UNIT_INT256, sub(9, 18)) }
        case 10000000000 { result := mul(UNIT_INT256, sub(10, 18)) }
        case 100000000000 { result := mul(UNIT_INT256, sub(11, 18)) }
        case 1000000000000 { result := mul(UNIT_INT256, sub(12, 18)) }
        case 10000000000000 { result := mul(UNIT_INT256, sub(13, 18)) }
        case 100000000000000 { result := mul(UNIT_INT256, sub(14, 18)) }
        case 1000000000000000 { result := mul(UNIT_INT256, sub(15, 18)) }
        case 10000000000000000 { result := mul(UNIT_INT256, sub(16, 18)) }
        case 100000000000000000 { result := mul(UNIT_INT256, sub(17, 18)) }
        case 1000000000000000000 { result := 0 }
        case 10000000000000000000 { result := UNIT_INT256 }
        case 100000000000000000000 { result := mul(UNIT_INT256, 2) }
        case 1000000000000000000000 { result := mul(UNIT_INT256, 3) }
        case 10000000000000000000000 { result := mul(UNIT_INT256, 4) }
        case 100000000000000000000000 { result := mul(UNIT_INT256, 5) }
        case 1000000000000000000000000 { result := mul(UNIT_INT256, 6) }
        case 10000000000000000000000000 { result := mul(UNIT_INT256, 7) }
        case 100000000000000000000000000 { result := mul(UNIT_INT256, 8) }
        case 1000000000000000000000000000 { result := mul(UNIT_INT256, 9) }
        case 10000000000000000000000000000 { result := mul(UNIT_INT256, 10) }
        case 100000000000000000000000000000 { result := mul(UNIT_INT256, 11) }
        case 1000000000000000000000000000000 { result := mul(UNIT_INT256, 12) }
        case 10000000000000000000000000000000 { result := mul(UNIT_INT256, 13) }
        case 100000000000000000000000000000000 { result := mul(UNIT_INT256, 14) }
        case 1000000000000000000000000000000000 { result := mul(UNIT_INT256, 15) }
        case 10000000000000000000000000000000000 { result := mul(UNIT_INT256, 16) }
        case 100000000000000000000000000000000000 { result := mul(UNIT_INT256, 17) }
        case 1000000000000000000000000000000000000 { result := mul(UNIT_INT256, 18) }
        case 10000000000000000000000000000000000000 { result := mul(UNIT_INT256, 19) }
        case 100000000000000000000000000000000000000 { result := mul(UNIT_INT256, 20) }
        case 1000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 21) }
        case 10000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 22) }
        case 100000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 23) }
        case 1000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 24) }
        case 10000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 25) }
        case 100000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 26) }
        case 1000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 27) }
        case 10000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 28) }
        case 100000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 29) }
        case 1000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 30) }
        case 10000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 31) }
        case 100000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 32) }
        case 1000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 33) }
        case 10000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 34) }
        case 100000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 35) }
        case 1000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 36) }
        case 10000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 37) }
        case 100000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 38) }
        case 1000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 39) }
        case 10000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 40) }
        case 100000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 41) }
        case 1000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 42) }
        case 10000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 43) }
        case 100000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 44) }
        case 1000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 45) }
        case 10000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 46) }
        case 100000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 47) }
        case 1000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 48) }
        case 10000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 49) }
        case 100000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 50) }
        case 1000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 51) }
        case 10000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 52) }
        case 100000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 53) }
        case 1000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 54) }
        case 10000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 55) }
        case 100000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 56) }
        case 1000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 57) }
        case 10000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT_INT256, 58) }
        default {
            result := MAX_SD59x18_INT256
        }
    }

    if (unwrap(result) == MAX_SD59x18_INT256) {
        unchecked {
            // Do the fixed-point division inline to save gas.
            result = wrap((unwrap(log2(x)) * UNIT_INT256) / LOG2_10_INT256);
        }
    }
}

/// @notice Calculates the binary logarithm of x.
///
/// @dev Based on the iterative approximation algorithm.
/// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
///
/// Requirements:
/// - x must be greater than zero.
///
/// Caveats:
/// - The results are not perfectly accurate to the last decimal, due to the lossy precision of the iterative approximation.
///
/// @param x The SD59x18 number for which to calculate the binary logarithm.
/// @return result The binary logarithm as an SD59x18 number.
function log2(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt <= 0) {
        revert PRBMathSD59x18__LogInputTooSmall(x);
    }

    unchecked {
        // This works because of:
        //
        // $$
        // log_2{x} = -log_2{\frac{1}{x}}
        // $$
        int256 sign;
        if (xInt >= UNIT_INT256) {
            sign = 1;
        } else {
            sign = -1;
            // Do the fixed-point inversion inline to save gas. The numerator is UNIT * UNIT.
            xInt = 1e36 / xInt;
        }

        // Calculate the integer part of the logarithm and add it to the result and finally calculate $y = x * 2^(-n)$.
        uint256 n = msb(uint256(xInt / UNIT_INT256));

        // This is the integer part of the logarithm as an SD59x18 number. The operation can't overflow
        // because n is maximum 255, UNIT is 1e18 and sign is either 1 or -1.
        int256 resultInt = int256(n) * UNIT_INT256;

        // This is $y = x * 2^{-n}$.
        int256 y = xInt >> n;

        // If y is 1, the fractional part is zero.
        if (y == UNIT_INT256) {
            return wrap(resultInt * sign);
        }

        // Calculate the fractional part via the iterative approximation.
        // The "delta >>= 1" part is equivalent to "delta /= 2", but shifting bits is faster.
        int256 DOUBLE_UNIT = 2e18;
        for (int256 delta = HALF_UNIT_INT256; delta > 0; delta >= 1) {
            y = (y * y) / UNIT_INT256;

            // Is $y^2 > 2$ and so in the range [2,4)?
            if (y >= DOUBLE_UNIT) {
                // Add the 2^{-m} factor to the logarithm.
                resultInt = resultInt + delta;

                // Corresponds to z/2 on Wikipedia.
                y >= 1;
            }
        }
        resultInt *= sign;
        result = wrap(resultInt);
    }
}

/// @notice Multiplies two SD59x18 numbers together, returning a new SD59x18 number.
///
/// @dev This is a variant of `mulDiv` that works with signed numbers and employs constant folding, i.e. the denominator
/// is always 1e18.
///
/// Requirements:
/// - All from `Core/mulDiv18`.
/// - None of the inputs can be `MIN_SD59x18`.
/// - The result must fit within `MAX_SD59x18`.
///
/// Caveats:
/// - To understand how this works in detail, see the NatSpec comments in `Core/mulDivSigned`.
///
/// @param x The multiplicand as an SD59x18 number.
/// @param y The multiplier as an SD59x18 number.
/// @return result The product as an SD59x18 number.
function mul(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    int256 yInt = unwrap(y);
    if (xInt == MIN_SD59x18_INT256 || yInt == MIN_SD59x18_INT256) {
        revert PRBMathSD59x18__MulInputTooSmall();
    }

    // Get hold of the absolute values of x and y.
    uint256 xAbs;
    uint256 yAbs;
    unchecked {
        xAbs = xInt < 0 ? uint256(-xInt) : uint256(xInt);
        yAbs = yInt < 0 ? uint256(-yInt) : uint256(yInt);
    }

    uint256 resultAbs = mulDiv18(xAbs, yAbs);
    if (resultAbs > MAX_SD59x18_UINT256) {
        revert PRBMathSD59x18__MulOverflow(x, y);
    }

    // Check if x and y have the same sign via "(x ^ y) > -1".
    // This works thanks to two's complement, the left-most bit is the sign bit.
    bool sameSign = (xInt ^ yInt) > -1;

    // If the inputs have the same sign, the result should be negative. Otherwise, it should be positive.
    unchecked {
        result = wrap(sameSign ? int256(resultAbs) : -int256(resultAbs));
    }
}

/// @notice Raises x to the power of y.
///
/// @dev Based on the formula:
///
/// $$
/// x^y = 2^{log_2{x} * y}
/// $$
///
/// Requirements:
/// - All from `exp2`, `log2` and `mul`.
/// - x cannot be zero.
///
/// Caveats:
/// - All from `exp2`, `log2` and `mul`.
/// - Assumes 0^0 is 1.
///
/// @param x Number to raise to given power y, as an SD59x18 number.
/// @param y Exponent to raise x to, as an SD59x18 number
/// @return result x raised to power y, as an SD59x18 number.
function pow(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    int256 yInt = unwrap(y);

    if (xInt == 0) {
        result = yInt == 0 ? UNIT : ZERO;
    } else {
        if (yInt == UNIT_INT256) {
            result = x;
        } else {
            result = exp2(mul(log2(x), y));
        }
    }
}

/// @notice Raises x (an SD59x18 number) to the power y (unsigned basic integer) using the famous algorithm
/// algorithm "exponentiation by squaring".
///
/// @dev See https://en.wikipedia.org/wiki/Exponentiation_by_squaring
///
/// Requirements:
/// - All from `abs` and `Core/mulDiv18`.
/// - The result must fit within `MAX_SD59x18`.
///
/// Caveats:
/// - All from `Core/mulDiv18`.
/// - Assumes 0^0 is 1.
///
/// @param x The base as an SD59x18 number.
/// @param y The exponent as an uint256.
/// @return result The result as an SD59x18 number.
function powu(SD59x18 x, uint256 y) pure returns (SD59x18 result) {
    uint256 xAbs = uint256(unwrap(abs(x)));

    // Calculate the first iteration of the loop in advance.
    uint256 resultAbs = y & 1 > 0 ? xAbs : UNIT_UINT256;

    // Equivalent to "for(y /= 2; y > 0; y /= 2)" but faster.
    uint256 yAux = y;
    for (yAux >>= 1; yAux > 0; yAux >>= 1) {
        xAbs = mulDiv18(xAbs, xAbs);

        // Equivalent to "y % 2 == 1" but faster.
        if (yAux & 1 > 0) {
            resultAbs = mulDiv18(resultAbs, xAbs);
        }
    }

    // The result must fit within `MAX_SD59x18`.
    if (resultAbs > MAX_SD59x18_UINT256) {
        revert PRBMathSD59x18__PowuOverflow(x, y);
    }

    unchecked {
        // Is the base negative and the exponent an odd number?
        int256 resultInt = int256(resultAbs);
        bool isNegative = unwrap(x) < 0 && y & 1 == 1;
        if (isNegative) {
            resultInt = -resultInt;
        }
        result = wrap(resultInt);
    }
}

/// @notice Calculates the square root of x, rounding down. Only the positive root is returned.
/// @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
///
/// Requirements:
/// - x cannot be negative, since this library does not handle complex numbers.
/// - x must be less than `MAX_SD59x18` divided by `UNIT`.
///
/// @param x The SD59x18 number for which to calculate the square root.
/// @return result The result as an SD59x18 number.
function sqrt(SD59x18 x) pure returns (SD59x18 result) {
    int256 xInt = unwrap(x);
    if (xInt < 0) {
        revert PRBMathSD59x18__SqrtNegativeInput(x);
    }
    if (xInt > MAX_SD59x18_INT256 / UNIT_INT256) {
        revert PRBMathSD59x18__SqrtOverflow(x);
    }

    unchecked {
        // Multiply x by `UNIT` to account for the factor of `UNIT` that is picked up when multiplying two SD59x18
        // numbers together (in this case, the two numbers are both the square root).
        uint256 resultUint = prbSqrt(uint256(xInt * UNIT_INT256));
        result = wrap(int256(resultUint));
    }
}

/// @notice Converts a number from basic integer form to SD59x18.
///
/// @dev Requirements:
/// - x must be greater than or equal to `MIN_SD59x18` divided by `UNIT`.
/// - x must be less than or equal to `MAX_SD59x18` divided by `UNIT`.
///
/// @param x The basic integer to convert.
/// @param result The same number converted to SD59x18.
function toSD59x18(int256 x) pure returns (SD59x18 result) {
    if (x < MIN_SD59x18_INT256 / UNIT_INT256) {
        revert PRBMathSD59x18__ToSD59x18Underflow(x);
    }
    if (x > MAX_SD59x18_INT256 / UNIT_INT256) {
        revert PRBMathSD59x18__ToSD59x18Overflow(x);
    }
    unchecked {
        result = wrap(x * UNIT_INT256);
    }
}

/*//////////////////////////////////////////////////////////////////////////
                    GLOBAL-SCOPED NON-FIXED-POINT FUNCTIONS
//////////////////////////////////////////////////////////////////////////*/

using {
    add,
    and,
    eq,
    gt,
    gte,
    isZero,
    lshift,
    lt,
    lte,
    mod,
    neq,
    or,
    rshift,
    sub,
    uncheckedAdd,
    uncheckedSub,
    uncheckedUnary,
    xor
} for SD59x18 global;

/// @notice Implements the checked addition operation (+) in the SD59x18 type.
function add(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    return wrap(unwrap(x) + unwrap(y));
}

/// @notice Implements the AND (&) bitwise operation in the SD59x18 type.
function and(SD59x18 x, int256 bits) pure returns (SD59x18 result) {
    return wrap(unwrap(x) & bits);
}

/// @notice Implements the equal (=) operation in the SD59x18 type.
function eq(SD59x18 x, SD59x18 y) pure returns (bool result) {
    result = unwrap(x) == unwrap(y);
}

/// @notice Implements the greater than operation (>) in the SD59x18 type.
function gt(SD59x18 x, SD59x18 y) pure returns (bool result) {
    result = unwrap(x) > unwrap(y);
}

/// @notice Implements the greater than or equal to operation (>=) in the SD59x18 type.
function gte(SD59x18 x, SD59x18 y) pure returns (bool result) {
    result = unwrap(x) >= unwrap(y);
}

/// @notice Implements a zero comparison check function in the SD59x18 type.
function isZero(SD59x18 x) pure returns (bool result) {
    result = unwrap(x) == 0;
}

/// @notice Implements the left shift operation (<<) in the SD59x18 type.
function lshift(SD59x18 x, uint256 bits) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) << bits);
}

/// @notice Implements the lower than operation (<) in the SD59x18 type.
function lt(SD59x18 x, SD59x18 y) pure returns (bool result) {
    result = unwrap(x) < unwrap(y);
}

/// @notice Implements the lower than or equal to operation (<=) in the SD59x18 type.
function lte(SD59x18 x, SD59x18 y) pure returns (bool result) {
    result = unwrap(x) <= unwrap(y);
}

/// @notice Implements the unchecked modulo operation (%) in the SD59x18 type.
function mod(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) % unwrap(y));
}

/// @notice Implements the not equal operation (!=) in the SD59x18 type.
function neq(SD59x18 x, SD59x18 y) pure returns (bool result) {
    result = unwrap(x) != unwrap(y);
}

/// @notice Implements the OR (|) bitwise operation in the SD59x18 type.
function or(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) | unwrap(y));
}

/// @notice Implements the right shift operation (>>) in the SD59x18 type.
function rshift(SD59x18 x, uint256 bits) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) >> bits);
}

/// @notice Implements the checked subtraction operation (-) in the SD59x18 type.
function sub(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) - unwrap(y));
}

/// @notice Implements the unchecked addition operation (+) in the SD59x18 type.
function uncheckedAdd(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    unchecked {
        result = wrap(unwrap(x) + unwrap(y));
    }
}

/// @notice Implements the unchecked subtraction operation (-) in the SD59x18 type.
function uncheckedSub(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    unchecked {
        result = wrap(unwrap(x) - unwrap(y));
    }
}

/// @notice Implements the unchecked unary minus operation (-) in the SD59x18 type.
function uncheckedUnary(SD59x18 x) pure returns (SD59x18 result) {
    unchecked {
        result = wrap(-unwrap(x));
    }
}

/// @notice Implements the XOR (^) bitwise operation in the SD59x18 type.
function xor(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    result = wrap(unwrap(x) ^ unwrap(y));
}

/*//////////////////////////////////////////////////////////////////////////
                    FILE-SCOPED NON-FIXED-POINT FUNCTIONS
//////////////////////////////////////////////////////////////////////////*/

using { uncheckedDiv, uncheckedMul } for SD59x18;

/// @notice Implements the unchecked standard division operation in the SD59x18 type.
function uncheckedDiv(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    unchecked {
        result = wrap(unwrap(x) / unwrap(y));
    }
}

/// @notice Implements the unchecked standard multiplication operation in the SD59x18 type.
function uncheckedMul(SD59x18 x, SD59x18 y) pure returns (SD59x18 result) {
    unchecked {
        result = wrap(unwrap(x) * unwrap(y));
    }
}

/*//////////////////////////////////////////////////////////////////////////
                                HELPER FUNCTIONS
//////////////////////////////////////////////////////////////////////////*/

/// @notice Wraps a signed integer into the SD59x18 type.
function sd(int256 x) pure returns (SD59x18 result) {
    result = wrap(x);
}

/// @notice Wraps a signed integer into the SD59x18 type.
/// @dev Alias for the "sd" function defined above.
function sd59x18(int256 x) pure returns (SD59x18 result) {
    result = wrap(x);
}

/// @notice Unwraps an SD59x18 number into the underlying signed integer.
function unwrap(SD59x18 x) pure returns (int256 result) {
    result = SD59x18.unwrap(x);
}

/// @notice Wraps a signed integer into the SD59x18 type.
function wrap(int256 x) pure returns (SD59x18 result) {
    result = SD59x18.wrap(x);
}
