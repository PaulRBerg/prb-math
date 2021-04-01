// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/// @title PRBMath
/// @author Paul Razvan Berg
/// @notice Smart contract library for mathematical functions that works with int256 numbers considered to have 18
/// decimals. We call this format decimal 58.18 fixed-point numbers, since there can be up to 58 digits in the 58
/// digits in the integer part and up to 18 digits in the fractional part.
library PRBMath {
    /// @dev Half the UNIT number.
    int256 internal constant HALF_UNIT = 5e17;

    /// @dev The maximum value a 58.18 decimal fixed-point number can have.
    int256 internal constant MAX_58x18 = type(int256).max;

    /// @dev The maximum whole value a 58.18 decimal fixed-point number can have.
    int256 internal constant MAX_WHOLE_58x18 = type(int256).max - (type(int256).max % UNIT);

    /// @dev The minimum value a 58.18 decimal fixed-point number can have.
    int256 internal constant MIN_58x18 = type(int256).min;

    /// @dev The minimum whole value a 58.18 decimal fixed-point number can have.
    int256 internal constant MIN_WHOLE_58x18 = type(int256).min - (type(int256).min % UNIT);

    /// @dev Twice the UNI number.
    int256 internal constant TWICE_UNIT = 2e18;

    /// @dev Constant that determines how many decimals can be represented.
    int256 internal constant UNIT = 1e18;

    /// INTERNAL FUNCTIONS ///

    /// @notice Calculate the absolute value of x.
    ///
    /// @dev Requirements:
    /// - x must be higher than min 58.18.
    ///
    /// @param x The number to calculate the absolute for.
    /// @param result The absolute value of x.
    function abs(int256 x) internal pure returns (int256 result) {
        require(x > MIN_58x18);
        return x < 0 ? -x : x;
    }

    /// @notice Calculates arithmetic average of x and y, rounding down.
    /// @param x The first operand as a 58.18 decimal fixed-point number.
    /// @param y The second operand as a 58.18 decimal fixed-point number.
    /// @return result The arithmetic average as a 58.18 decimal fixed-point number.
    function avg(int256 x, int256 y) internal pure returns (int256 result) {
        // Saving gas by wrapping the code in an "unchecked" block. The operations can never overflow.
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
    /// - x must be less than or equal to the maximum whole value allowed by the 58.18 decimal fixed-point format.
    ///
    /// @param x The 58.18 decimal fixed-point number to ceil.
    /// @param result The least integer greater than or equal to x.
    function ceil(int256 x) internal pure returns (int256 result) {
        require(x <= MAX_WHOLE_58x18);
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

    /// @notice Divides two 58.18 decimal fixed-point numbers, returning a new 58.18 decimal fixed-point number.
    /// @dev Works by scaling the numerator first, then dividing by the denominator.
    ///
    /// Requirements:
    /// - x * UNIT must not be higher than MAX_58x18
    ///
    /// Caveats:
    /// - Susceptible to phantom overflow when x * UNIT > MAX_58x18
    ///
    /// @param x The numerator as a 58.18 decimal fixed-point number.
    /// @param y The denominator as a 58.18 decimal fixed-point number.
    /// @param result The quotient as a 58.18 decimal fixed-point number.
    function div(int256 x, int256 y) internal pure returns (int256 result) {
        int256 scaledNumerator = x * UNIT;
        // Saving gas by wrapping the code in an "unchecked" block. Overflows can happen only when the scaled numerator
        // is MIN_58x18 and the denominator is -1. But the scaled numerator can't be MIN_58x18.
        // See https://ethereum.stackexchange.com/questions/96482/can-division-underflow-or-overflow-in-solidity
        unchecked {
            result = scaledNumerator / y;
        }
    }

    function exp(int256 x) internal pure returns (int256 result) {
        x;
        result = 0;
    }

    function exp2(int256 x) internal pure returns (int256 result) {
        x;
        result = 0;
    }

    /// @notice Yields the greatest integer less than or equal to x.
    ///
    /// @dev See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions
    ///
    /// Requirements:
    /// - x must be greater than or equal to the minimum whole value allowed by the 58.18 decimal fixed-point format.
    ///
    /// @param x The 58.18 decimal fixed-point number to floor.
    /// @param result The greatest integer less than or equal to x.
    function floor(int256 x) internal pure returns (int256 result) {
        require(x >= MIN_WHOLE_58x18);
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
    /// @param x The 58.18 decimal fixed-point number to get the fractional part of.
    /// @param result The fractional part of x as a 58.18 decimal fixed-point number.
    function frac(int256 x) internal pure returns (int256 result) {
        result = x % UNIT;
    }

    /// @notice Calculates the natural logarithm of x.
    ///
    /// @dev Based on the insight that ln(x) = log2(x) * ln(2).
    ///
    /// Requirements:
    /// - All from `log2`.
    ///
    /// Caveats:
    /// - All from `log2`.
    /// - This doesn't return exactly 1 for 2.718281828459045235, for that we would need more fine-grained precision.
    ///
    /// @param x The 58.18 decimal fixed-point number for which to calculate the natural logarithm.
    /// @return result The natural logarithm as a 58.18 decimal fixed-point number.
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
    /// - All from `log2`.
    ///
    /// Caveats:
    /// - All from `log2`.
    ///
    /// @param x The 58.18 decimal fixed-point number for which to calculate the common logarithm.
    /// @return result The common logarithm as a 58.18 decimal fixed-point number.
    function log10(int256 x) internal pure returns (int256 result) {
        require(x > 0);
        result = MAX_58x18;

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
            // solhint-disable max-line-length
            case 1000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 57) }
            case 10000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(UNIT, 58) }
            // solhint-enable max-line-length
        }

        if (result == MAX_58x18) {
            int256 log2_10 = 332192809488736234;
            result = div(log2(x), log2_10);
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
    /// @param x The 58.18 decimal fixed-point number for which to calculate the binary logarithm.
    /// @return result The binary logarithm as a 58.18 decimal fixed-point number.
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
        uint256 n = mostSignificantBit(x);
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

    /// @notice Multiplies two 58.18 decimal fixed-point numbers, returning a new 58.18 decimal fixed-point number.
    /// @dev Requirements:
    /// - x * y must not be higher than MAX_58x18 or smaller than MIN_58x18
    /// - x * y +/- HALF_UNIT must not be higher than MAX_58x18 or smaller than MIN_58x18
    ///
    /// Caveats:
    /// - Susceptible to phantom overflow when (x * y > MAX_58x18) OR (x * y < MIN_58x18)
    /// - Susceptible to phantom overflow when (x * y + HALF_UNIT > MAX_58x18) OR (x * y - HALF_UNIT < MIN_58x18)
    ///
    /// @param x The first operand as a 58.18 decimal fixed-point number.
    /// @param y The second operand as a 58.18 decimal fixed-point number.
    /// @param result The product as a 58.18 decimal fixed-point number.
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

    /// @dev See https://github.com/Uniswap/uniswap-v3-core/blob/main/contracts/libraries/FullMath.sol.
    function mulDiv(
        uint256 a,
        uint256 b,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        a;
        b;
        denominator;
        result = 0;
    }

    function sqrt(int256 x) internal pure returns (int256 result) {
        x;
        result = 0;
    }

    /// @notice Returns Euler's number in 58.18 decimal fixed-point representation.
    /// @dev See https://en.wikipedia.org/wiki/E_(mathematical_constant).
    function e() internal pure returns (int256 result) {
        result = 2718281828459045235;
    }

    /// @notice Returns PI in 58.18 decimal fixed-point representation.
    function pi() internal pure returns (int256 result) {
        result = 3141592653589793238;
    }

    /// @notice Returns 1 in 58.18 decimal fixed-point representation.
    function unit() internal pure returns (int256 result) {
        result = UNIT;
    }

    /// PRIVATE FUNCTIONS ///
    /// @notice Finds the zero-based index of the first one in the binary representation of x.
    /// @dev See the "Find First Set" article on Wikipedia https://en.wikipedia.org/wiki/Find_first_set
    /// @param x The 58.18 decimal fixed-point number for which to find the index of the most significant bit.
    /// @return msb The index of the most significant bit.
    function mostSignificantBit(int256 x) private pure returns (uint256 msb) {
        x /= UNIT;
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
}
