// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.13;

import { PRBMath } from "./PRBMath.sol";

/// @notice The unsigned 60.18-decimal fixed-point number representation. Can have up to 60 digits and up to 18 decimals.
/// The numbers are bound by the minimum and the maximum values permitted by the Solidity type uint256.
type UD60x18 is uint256;

/// CUSTOM ERRORS ///

/// @notice Emitted when adding two numbers overflows UD60x18.
error PRBMathUD60x18__AddOverflow(uint256 x, UD60x18 y);

/// @notice Emitted when ceiling a number overflows UD60x18.
error PRBMathUD60x18__CeilOverflow(UD60x18 x);

/// @notice Emitted when taking the natural exponent of a base greater than 133.084258667509499441.
error PRBMathUD60x18__ExpInputTooBig(UD60x18 x);

/// @notice Emitted when taking the binary exponent of a base greater than 192.
error PRBMathUD60x18__Exp2InputTooBig(UD60x18 x);

/// @notice Emitted when taking the geometric mean of two numbers and multiplying them overflows UD60x18.
error PRBMathUD60x18__GmOverflow(UD60x18 x, UD60x18 y);

/// @notice Emitted when taking the logarithm of a number less than 1.
error PRBMathUD60x18__LogInputTooSmall(UD60x18 x);

/// @notice Emitted when calculating the square root overflows UD60x18.
error PRBMathUD60x18__SqrtOverflow(UD60x18 x);

/// @notice Emitted when subtracting one number from another underflows UD60x18.
error PRBMathUD60x18__SubUnderflow(UD60x18 x, UD60x18 y);

/// @notice Emitted when converting a basic integer to the fixed-point format overflows UD60x18.
error PRBMathUD60x18__ToUD60x18Overflow(uint256 x);

/// CONSTANTS ///

/// @dev Half the SCALE number.
UD60x18 constant HALF_SCALE = UD60x18.wrap(5e17);
uint256 constant HALF_SCALE_UINT = 5e17;

/// @dev log2(10) as an UD60x18 number.
UD60x18 constant LOG2_10 = UD60x18.wrap(3_321928094887362347);
uint256 constant LOG2_10_UINT = 3_321928094887362347;

/// @dev log2(e) as an UD60x18 number.
UD60x18 constant LOG2_E = UD60x18.wrap(1_442695040888963407);
uint256 constant LOG2_E_UINT = 1_442695040888963407;

/// @dev The maximum value an UD60x18 number can have.
UD60x18 constant MAX_UD60x18 = UD60x18.wrap(
    115792089237316195423570985008687907853269984665640564039457_584007913129639935
);
uint256 constant MAX_UD60x18_UINT = 115792089237316195423570985008687907853269984665640564039457_584007913129639935;

/// @dev The maximum whole value an UD60x18 number can have.
UD60x18 constant MAX_WHOLE_UD60x18 = UD60x18.wrap(
    115792089237316195423570985008687907853269984665640564039457_000000000000000000
);
uint256 constant MAX_WHOLE_UD60x18_UINT = 115792089237316195423570985008687907853269984665640564039457_000000000000000000;

/// @dev The unit amount which implies how many trailing decimals can be represented.
UD60x18 constant SCALE = UD60x18.wrap(1e18);
uint256 constant SCALE_UINT = 1e18;

/// @dev Zero as an UD60x18 number.
UD60x18 constant ZERO = UD60x18.wrap(0);

/// GLOBAL-SCOPED FIXED-POINT FUNCTIONS ///

using { avg, ceil, div, exp, exp2, floor, frac, gm, inv, ln, log10, log2, mul, pow, powu, sqrt } for UD60x18 global;

/// @notice Calculates the arithmetic average of x and y, rounding down.
///
/// @dev Based on the formula:
///
/// $$
/// avg(x, y) = (x >> 1) + (y >> 1) + (x & y & 1)
/// $$
//
/// In English, this means:
///
///     1. Shift x one bit to the right.
///     2. Shift y one bit to the left.
///     3. Add 1 if both x and y are odd.
///
/// We need to add 1 if both x and y are odd to account for the double 0.5 remainder that is truncated after shifting.
///
/// @param x The first operand as an UD60x18 number.
/// @param y The second operand as an UD60x18 number.
/// @return result The arithmetic average as an UD60x18 number.
function avg(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    // prettier-ignore
    result = x.rshift(1)
                .uncheckedAdd(y.rshift(1))
                .uncheckedAdd(x.and(UD60x18.unwrap(y)).and(1));
}

/// @notice Yields the least UD60x18 number greater than or equal to x.
///
/// @dev This is optimized for fractional value inputs, because for every whole value there are "1e18 - 1" fractional
/// counterparts. See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.
///
/// Requirements:
/// - x must be less than or equal to `MAX_WHOLE_UD60x18`.
///
/// @param x The UD60x18 number to ceil.
/// @param result The least number greater than or equal to x, as an UD60x18 number.
function ceil(UD60x18 x) pure returns (UD60x18 result) {
    if (x.gt(MAX_WHOLE_UD60x18)) {
        revert PRBMathUD60x18__CeilOverflow(x);
    }
    assembly {
        // Equivalent to "x % SCALE" but faster.
        let remainder := mod(x, SCALE_UINT)

        // Equivalent to "SCALE - remainder" but faster.
        let delta := sub(SCALE_UINT, remainder)

        // Equivalent to "x + delta * (remainder > 0 ? 1 : 0)" but faster.
        result := add(x, mul(delta, gt(remainder, 0)))
    }
}

/// @notice Divides two UD60x18 numbers, returning a new UD60x18 number.
///
/// @dev Uses `mulDiv` to enable overflow-safe multiplication and division.
///
/// Requirements:
/// - The denominator cannot be zero.
///
/// @param x The numerator as an UD60x18 number.
/// @param y The denominator as an UD60x18 number.
/// @param result The quotient as an UD60x18 number.
function div(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    result = UD60x18.wrap(PRBMath.mulDiv(UD60x18.unwrap(x), SCALE_UINT, UD60x18.unwrap(y)));
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
/// @param x The exponent as an UD60x18 number.
/// @return result The result as an UD60x18 number.
function exp(UD60x18 x) pure returns (UD60x18 result) {
    // Without this check, the value passed to `exp2` would be greater than 192.
    if (UD60x18.unwrap(x) >= 133_084258667509499441) {
        revert PRBMathUD60x18__ExpInputTooBig(x);
    }

    // We do the fixed-point multiplication inline rather than via the `mul` function to save gas.
    UD60x18 doubleScaleProduct = x.uncheckedMul(LOG2_E);
    result = exp2(doubleScaleProduct.uncheckedAdd(HALF_SCALE).uncheckedDiv(SCALE));
}

/// @notice Calculates the binary exponent of x using the binary fraction method.
///
/// @dev See https://ethereum.stackexchange.com/q/79903/24693.
///
/// Requirements:
/// - x must be 192 or less.
/// - The result must fit within `MAX_UD60x18`.
///
/// @param x The exponent as an UD60x18 number.
/// @return result The result as an UD60x18 number.
function exp2(UD60x18 x) pure returns (UD60x18 result) {
    // Numbers greater than or equal to 2^192 don't fit within the 192.64-bit format.
    if (UD60x18.unwrap(x) >= 192e18) {
        revert PRBMathUD60x18__Exp2InputTooBig(x);
    }

    // Convert x to the 192.64-bit fixed-point format.
    uint256 x_192x64 = UD60x18.unwrap(x.lshift(64).uncheckedDiv(SCALE));

    // Pass x to the `PRBMath.exp2` function, which uses the 192.64-bit fixed-point number representation.
    result = UD60x18.wrap(PRBMath.exp2(x_192x64));
}

/// @notice Yields the greatest UD60x18 number less than or equal to x.
/// @dev Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
/// See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.
/// @param x The UD60x18 number to floor.
/// @param result The greatest integer less than or equal to x, as an UD60x18 number.
function floor(UD60x18 x) pure returns (UD60x18 result) {
    assembly {
        // Equivalent to "x % SCALE" but faster.
        let remainder := mod(x, SCALE_UINT)

        // Equivalent to "x - remainder * (remainder > 0 ? 1 : 0)" but faster.
        result := sub(x, mul(remainder, gt(remainder, 0)))
    }
}

/// @notice Yields the excess beyond the floor of x.
/// @dev Based on the odd function definition https://en.wikipedia.org/wiki/Fractional_part.
/// @param x The UD60x18 number to get the fractional part of.
/// @param result The fractional part of x as an UD60x18 number.
function frac(UD60x18 x) pure returns (UD60x18 result) {
    assembly {
        result := mod(x, SCALE_UINT)
    }
}

/// @notice Calculates the geometric mean of x and y, i.e. $$sqrt(x * y)$$, rounding down.
///
/// @dev Requirements:
/// - x * y must fit within `MAX_UD60x18`, lest it overflows.
///
/// @param x The first operand as an UD60x18 number.
/// @param y The second operand as an UD60x18 number.
/// @return result The result as an UD60x18 number.
function gm(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    if (x.isZero()) {
        return ZERO;
    }

    // Equivalent to "xy / x != y". Checking for overflow this way is faster than letting Solidity do it.
    UD60x18 xy = x.uncheckedMul(y);
    if (xy.uncheckedDiv(x).neq(y)) {
        revert PRBMathUD60x18__GmOverflow(x, y);
    }

    // We don't need to multiply by `SCALE` here because the x*y product had already picked up a factor of `SCALE`
    // during multiplication. See the comments in the `sqrt` function.
    result = UD60x18.wrap(PRBMath.sqrt(UD60x18.unwrap(xy)));
}

/// @notice Calculates 1 / x, rounding toward zero.
///
/// @dev Requirements:
/// - x cannot be zero.
///
/// @param x The UD60x18 number for which to calculate the inverse.
/// @return result The inverse as an UD60x18 number.
function inv(UD60x18 x) pure returns (UD60x18 result) {
    // 1e36 is SCALE * SCALE.
    result = UD60x18.wrap(1e36).uncheckedDiv(x);
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
/// @param x The UD60x18 number for which to calculate the natural logarithm.
/// @return result The natural logarithm as an UD60x18 number.
function ln(UD60x18 x) pure returns (UD60x18 result) {
    // We do the fixed-point multiplication inline to save gas. This is overflow-safe because the maximum value
    // that `log2` can return is 196.205294292027477728.
    result = log2(x).uncheckedMul(SCALE).uncheckedDiv(LOG2_E);
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
/// @param x The UD60x18 number for which to calculate the common logarithm.
/// @return result The common logarithm as an UD60x18 number.
function log10(UD60x18 x) pure returns (UD60x18 result) {
    if (x.lt(SCALE)) {
        revert PRBMathUD60x18__LogInputTooSmall(x);
    }

    // Note that the `mul` in this assembly block is the assembly multiplication operation, not the UD60x18 `mul`.
    // prettier-ignore
    assembly {
        switch x
        case 1 { result := mul(SCALE_UINT, sub(0, 18)) }
        case 10 { result := mul(SCALE_UINT, sub(1, 18)) }
        case 100 { result := mul(SCALE_UINT, sub(2, 18)) }
        case 1000 { result := mul(SCALE_UINT, sub(3, 18)) }
        case 10000 { result := mul(SCALE_UINT, sub(4, 18)) }
        case 100000 { result := mul(SCALE_UINT, sub(5, 18)) }
        case 1000000 { result := mul(SCALE_UINT, sub(6, 18)) }
        case 10000000 { result := mul(SCALE_UINT, sub(7, 18)) }
        case 100000000 { result := mul(SCALE_UINT, sub(8, 18)) }
        case 1000000000 { result := mul(SCALE_UINT, sub(9, 18)) }
        case 10000000000 { result := mul(SCALE_UINT, sub(10, 18)) }
        case 100000000000 { result := mul(SCALE_UINT, sub(11, 18)) }
        case 1000000000000 { result := mul(SCALE_UINT, sub(12, 18)) }
        case 10000000000000 { result := mul(SCALE_UINT, sub(13, 18)) }
        case 100000000000000 { result := mul(SCALE_UINT, sub(14, 18)) }
        case 1000000000000000 { result := mul(SCALE_UINT, sub(15, 18)) }
        case 10000000000000000 { result := mul(SCALE_UINT, sub(16, 18)) }
        case 100000000000000000 { result := mul(SCALE_UINT, sub(17, 18)) }
        case 1000000000000000000 { result := 0 }
        case 10000000000000000000 { result := SCALE_UINT }
        case 100000000000000000000 { result := mul(SCALE_UINT, 2) }
        case 1000000000000000000000 { result := mul(SCALE_UINT, 3) }
        case 10000000000000000000000 { result := mul(SCALE_UINT, 4) }
        case 100000000000000000000000 { result := mul(SCALE_UINT, 5) }
        case 1000000000000000000000000 { result := mul(SCALE_UINT, 6) }
        case 10000000000000000000000000 { result := mul(SCALE_UINT, 7) }
        case 100000000000000000000000000 { result := mul(SCALE_UINT, 8) }
        case 1000000000000000000000000000 { result := mul(SCALE_UINT, 9) }
        case 10000000000000000000000000000 { result := mul(SCALE_UINT, 10) }
        case 100000000000000000000000000000 { result := mul(SCALE_UINT, 11) }
        case 1000000000000000000000000000000 { result := mul(SCALE_UINT, 12) }
        case 10000000000000000000000000000000 { result := mul(SCALE_UINT, 13) }
        case 100000000000000000000000000000000 { result := mul(SCALE_UINT, 14) }
        case 1000000000000000000000000000000000 { result := mul(SCALE_UINT, 15) }
        case 10000000000000000000000000000000000 { result := mul(SCALE_UINT, 16) }
        case 100000000000000000000000000000000000 { result := mul(SCALE_UINT, 17) }
        case 1000000000000000000000000000000000000 { result := mul(SCALE_UINT, 18) }
        case 10000000000000000000000000000000000000 { result := mul(SCALE_UINT, 19) }
        case 100000000000000000000000000000000000000 { result := mul(SCALE_UINT, 20) }
        case 1000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 21) }
        case 10000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 22) }
        case 100000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 23) }
        case 1000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 24) }
        case 10000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 25) }
        case 100000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 26) }
        case 1000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 27) }
        case 10000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 28) }
        case 100000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 29) }
        case 1000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 30) }
        case 10000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 31) }
        case 100000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 32) }
        case 1000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 33) }
        case 10000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 34) }
        case 100000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 35) }
        case 1000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 36) }
        case 10000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 37) }
        case 100000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 38) }
        case 1000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 39) }
        case 10000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 40) }
        case 100000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 41) }
        case 1000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 42) }
        case 10000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 43) }
        case 100000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 44) }
        case 1000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 45) }
        case 10000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 46) }
        case 100000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 47) }
        case 1000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 48) }
        case 10000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 49) }
        case 100000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 50) }
        case 1000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 51) }
        case 10000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 52) }
        case 100000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 53) }
        case 1000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 54) }
        case 10000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 55) }
        case 100000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 56) }
        case 1000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 57) }
        case 10000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 58) }
        case 100000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE_UINT, 59) }
        default {
            result := MAX_UD60x18_UINT
        }
    }

    if (result.eq(MAX_UD60x18)) {
        // Do the fixed-point division inline to save gas.
        result = log2(x).uncheckedMul(SCALE).uncheckedDiv(LOG2_10);
    }
}

/// @notice Calculates the binary logarithm of x.
///
/// @dev Based on the iterative approximation algorithm.
/// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
///
/// Requirements:
/// - x must be greater than or equal to SCALE, otherwise the result would be negative.
///
/// Caveats:
/// - The results are nor perfectly accurate to the last decimal, due to the lossy precision of the iterative approximation.
///
/// @param x The UD60x18 number for which to calculate the binary logarithm.
/// @return result The binary logarithm as an UD60x18 number.
function log2(UD60x18 x) pure returns (UD60x18 result) {
    if (x.lt(SCALE)) {
        revert PRBMathUD60x18__LogInputTooSmall(x);
    }
    // Calculate the integer part of the logarithm, add it to the result and finally calculate y = x * 2^(-n).
    uint256 n = PRBMath.msb(UD60x18.unwrap(x.uncheckedDiv(SCALE)));

    // This is the integer part of the logarithm as an UD60x18 number. The operation can't overflow because n
    // n is maximum 255 and SCALE is 1e18.
    result = UD60x18.wrap(n).uncheckedMul(SCALE);

    // This is $y = x * 2^{-n}$.
    UD60x18 y = x.rshift(n);

    // If y is 1, the fractional part is zero.
    if (y.eq(SCALE)) {
        return result;
    }

    // Calculate the fractional part via the iterative approximation.
    // The "delta.rshift(1)" part is equivalent to "delta /= 2", but shifting bits is faster.
    UD60x18 DOUBLE_SCALE = UD60x18.wrap(2e18);
    for (UD60x18 delta = HALF_SCALE; delta.gt(ZERO); delta = delta.rshift(1)) {
        y = y.uncheckedMul(y).uncheckedDiv(SCALE);

        // Is y^2 > 2 and so in the range [2,4)?
        if (y.gte(DOUBLE_SCALE)) {
            // Add the 2^{-m} factor to the logarithm.
            result = result.uncheckedAdd(delta);

            // Corresponds to z/2 on Wikipedia.
            y = y.rshift(1);
        }
    }
}

/// @notice Multiplies two UD60x18 numbers together, returning a new UD60x18 number.
/// @dev See the documentation for the `PRBMath.mulDiv18` function.
/// @param x The multiplicand as an UD60x18 number.
/// @param y The multiplier as an UD60x18 number.
/// @return result The product as an UD60x18 number.
function mul(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    result = UD60x18.wrap(PRBMath.mulDiv18(UD60x18.unwrap(x), UD60x18.unwrap(y)));
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
///
/// Caveats:
/// - All from `exp2`, `log2` and `mul`.
/// - Assumes 0^0 is 1.
///
/// @param x Number to raise to given power y, as an UD60x18 number.
/// @param y Exponent to raise x to, as an UD60x18 number.
/// @return result x raised to power y, as an UD60x18 number.
function pow(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    if (x.isZero()) {
        result = y.isZero() ? SCALE : ZERO;
    } else {
        result = exp2(mul(log2(x), y));
    }
}

/// @notice Raises x (an UD60x18 number) to the power y (unsigned basic integer) using the famous algorithm
/// "exponentiation by squaring".
///
/// @dev See https://en.wikipedia.org/wiki/Exponentiation_by_squaring
///
/// Requirements:
/// - The result must fit within `MAX_UD60x18`.
///
/// Caveats:
/// - All from "PRBMath.mulDiv18".
/// - Assumes 0^0 is 1.
///
/// @param x The base as an UD60x18 number.
/// @param y The exponent as an uint256.
/// @return result The result as an UD60x18 number.
function powu(UD60x18 x, uint256 y) pure returns (UD60x18 result) {
    // Calculate the first iteration of the loop in advance.
    result = y & 1 > 0 ? x : SCALE;

    // Equivalent to "for(y /= 2; y > 0; y /= 2)" but faster.
    for (y >>= 1; y > 0; y >>= 1) {
        x = UD60x18.wrap(PRBMath.mulDiv18(UD60x18.unwrap(x), UD60x18.unwrap(x)));

        // Equivalent to "y % 2 == 1" but faster.
        if (y & 1 > 0) {
            result = UD60x18.wrap(PRBMath.mulDiv18(UD60x18.unwrap(result), UD60x18.unwrap(x)));
        }
    }
}

/// @notice Calculates the square root of x, rounding down.
/// @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
///
/// Requirements:
/// - x must be less than `MAX_UD60x18` divided by `SCALE`.
///
/// @param x The UD60x18 number for which to calculate the square root.
/// @return result The result as an UD60x18 number.
function sqrt(UD60x18 x) pure returns (UD60x18 result) {
    if (x.gt(MAX_UD60x18.uncheckedDiv(SCALE))) {
        revert PRBMathUD60x18__SqrtOverflow(x);
    }
    // Multiply x by `SCALE` to account for the factor of `SCALE` that is picked up when multiplying two UD60x18
    // numbers together (in this case, the two numbers are both the square root).
    result = UD60x18.wrap(PRBMath.sqrt(UD60x18.unwrap(x.uncheckedMul(SCALE))));
}

/// GLOBAL-SCOPED NON-FIXED-POINT FUNCTIONS ///

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
    neq,
    rshift,
    sub,
    uncheckedAdd,
    uncheckedSub
} for UD60x18 global;

/// @notice Implements the checked addition operation (+) in the UD60x18 type.
function add(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD60x18.unwrap(x) + UD60x18.unwrap(y));
}

/// @notice Implements the AND (&) bitwise operation in the UD60x18 type.
function and(UD60x18 x, uint256 bits) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD60x18.unwrap(x) & bits);
}

/// @notice Implements the equal operation (==) in the UD60x18 type.
function eq(UD60x18 x, UD60x18 y) pure returns (bool result) {
    result = UD60x18.unwrap(x) == UD60x18.unwrap(y);
}

/// @notice Implements the greater than operation (>) in the UD60x18 type.
function gt(UD60x18 x, UD60x18 y) pure returns (bool result) {
    result = UD60x18.unwrap(x) > UD60x18.unwrap(y);
}

/// @notice Implements the greater than or equal to operation (>=) in the UD60x18 type.
function gte(UD60x18 x, UD60x18 y) pure returns (bool result) {
    result = UD60x18.unwrap(x) >= UD60x18.unwrap(y);
}

/// @notice Implements a zero comparison check function in the UD60x18 type.
function isZero(UD60x18 x) pure returns (bool result) {
    // This wouldn't work if x could be negative.
    result = UD60x18.unwrap(x) > 0 == false;
}

/// @notice Implements the lower than operation (<) in the UD60x18 type.
function lt(UD60x18 x, UD60x18 y) pure returns (bool result) {
    result = UD60x18.unwrap(x) < UD60x18.unwrap(y);
}

/// @notice Implements the lower than or equal to operation (<=) in the UD60x18 type.
function lte(UD60x18 x, UD60x18 y) pure returns (bool result) {
    result = UD60x18.unwrap(x) <= UD60x18.unwrap(y);
}

/// @notice Implements the left shift operation (<<) in the UD60x18 type.
function lshift(UD60x18 x, uint256 bits) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD60x18.unwrap(x) << bits);
}

/// @notice Implements the not equal operation (!=) in the UD60x18 type
function neq(UD60x18 x, UD60x18 y) pure returns (bool result) {
    result = UD60x18.unwrap(x) != UD60x18.unwrap(y);
}

/// @notice Implements the right shift operation (>>) in the UD60x18 type.
function rshift(UD60x18 x, uint256 bits) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD60x18.unwrap(x) >> bits);
}

/// @notice Implements the checked subtraction operation (-) in the UD60x18 type.
function sub(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD60x18.unwrap(x) - UD60x18.unwrap(y));
}

/// @notice Implements the unchecked addition operation (+) in the UD60x18 type.
function uncheckedAdd(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    unchecked {
        result = UD60x18.wrap(UD60x18.unwrap(x) + UD60x18.unwrap(y));
    }
}

/// @notice Implements the unchecked modulo operation (%) in the UD60x18 type.
function uncheckedMod(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    unchecked {
        result = UD60x18.wrap(UD60x18.unwrap(x) % UD60x18.unwrap(y));
    }
}

/// @notice Implements the unchecked subtraction operation (-) in the UD60x18 type.
function uncheckedSub(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    unchecked {
        result = UD60x18.wrap(UD60x18.unwrap(x) - UD60x18.unwrap(y));
    }
}

/// @notice Implements the XOR (^) bitwise operation in the UD60x18 type.
function xor(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD60x18.unwrap(x) ^ UD60x18.unwrap(y));
}

/// HELPER FUNCTIONS ///

/// @notice Returns Euler's number as an UD60x18 number.
/// @dev See https://en.wikipedia.org/wiki/E_(mathematical_constant).
function e() pure returns (UD60x18 result) {
    result = UD60x18.wrap(2_718281828459045235);
}

/// @notice Converts an UD60x18 number to basic integer form, rounding down in the process.
/// @param x The UD60x18 number to convert.
/// @return result The same number in basic integer form.
function fromUD60x18(UD60x18 x) pure returns (uint256 result) {
    result = UD60x18.unwrap(x.uncheckedDiv(SCALE));
}

/// @notice Returns PI as an UD60x18 number.
function pi() pure returns (UD60x18 result) {
    result = UD60x18.wrap(3_141592653589793238);
}

/// @notice Converts a number from basic integer form to UD60x18.
///
/// @dev Requirements:
/// - x must be less than or equal to `MAX_UD60x18` divided by `SCALE`.
///
/// @param x The basic integer to convert.
/// @param result The same number converted to UD60x18.
function toUD60x18(uint256 x) pure returns (UD60x18 result) {
    if (x > MAX_UD60x18_UINT / SCALE_UINT) {
        revert PRBMathUD60x18__ToUD60x18Overflow(x);
    }
    unchecked {
        result = UD60x18.wrap(x * SCALE_UINT);
    }
}

/// FILE-SCOPED FUNCTIONS ///

using { uncheckedDiv, uncheckedMul } for UD60x18;

/// @notice Implements the unchecked standard division operation in the UD60x18 type.
function uncheckedDiv(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    unchecked {
        result = UD60x18.wrap(UD60x18.unwrap(x) / UD60x18.unwrap(y));
    }
}

/// @notice Implements the unchecked standard multiplication operation in the UD60x18 type.
function uncheckedMul(UD60x18 x, UD60x18 y) pure returns (UD60x18 result) {
    unchecked {
        result = UD60x18.wrap(UD60x18.unwrap(x) * UD60x18.unwrap(y));
    }
}
