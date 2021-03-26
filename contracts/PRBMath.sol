// SPDX-License-Identifier: MIT
// solhint-disable code-complexity, func-name-mixedcase
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/// @title PRBMath
/// @author Paul Razvan Berg
/// @notice Smart contract library for mathematical functions. It works with int256 numbers considered
/// to have 18 decimals, which are called signed 59.18 decimal numbers.
library PRBMath {
    /// @dev Half the UNIT number.
    int256 internal constant HALF_UNIT = 5e17;

    /// @dev The maximum value a signed 59.18 decimal fixed point number can have.
    int256 internal constant MAX_59x18 = type(int256).max;

    /// @dev The maximum whole value a signed 59.18 decimal fixed point number can have.
    int256 internal constant MAX_WHOLE_59x18 = type(int256).max - (type(int256).max % UNIT);

    /// @dev The minimum value a signed 59.18 decimal fixed point number can have.
    int256 internal constant MIN_59x18 = type(int256).min;

    /// @dev The minimum whole value a signed 59.18 decimal fixed point number can have.
    int256 internal constant MIN_WHOLE_59x18 = type(int256).min - (type(int256).min % UNIT);

    /// @dev Twice the UNI number.
    int256 internal constant TWICE_UNIT = 2e18;

    /// @dev 2 raised to the power of 1.
    uint256 internal constant TWO_POW_1 = 2**1;

    /// @dev 2 raised to the power of 2.
    uint256 internal constant TWO_POW_2 = 2**2;

    /// @dev 2 raised to the power of 4.
    uint256 internal constant TWO_POW_4 = 2**4;

    /// @dev 2 raised to the power of 8.
    uint256 internal constant TWO_POW_8 = 2**8;

    /// @dev 2 raised to the power of 16.
    uint256 internal constant TWO_POW_16 = 2**16;

    /// @dev 2 raised to the power of 32.
    uint256 internal constant TWO_POW_32 = 2**32;

    /// @dev 2 raised to the power of 63.
    uint256 internal constant TWO_POW_63 = 2**63;

    /// @dev 2 raised to the power of 64.
    uint256 internal constant TWO_POW_64 = 2**64;

    /// @dev 2 raised to the power of 128.
    uint256 internal constant TWO_POW_128 = 2**128;

    /// @dev Constant that determines how many decimals can be represented.
    int256 internal constant UNIT = 1e18;

    /// PURE FUNCTIONS ///

    /// @notice Calculate the absolute value of x.
    ///
    /// @dev Based on the following function abs(x) = |x|.
    ///
    /// Requirements:
    /// - `x` must be higher than min 59.18
    ///
    /// @param x The number to calculate the absolute for.
    /// @param result The absolute value of x.
    function abs(int256 x) internal pure returns (int256 result) {
        require(x > MIN_59x18);
        return x < 0 ? -x : x;
    }

    /// @notice Yields the least integer greater than or equal to x.
    ///
    /// @dev Based on the function ceil(x) = x + (UNIT - x % 1e18).
    /// https://en.wikipedia.org/wiki/Floor_and_ceiling_functions
    ///
    /// Requirements:
    /// - `x` must be less than or equal to the maximum whole value permitted by the signed 59.18 decimal format.
    ///
    /// @param x The signed 59.18 decimal number to ceil.
    /// @param result The least integer greater than or equal to x.
    function ceil(int256 x) internal pure returns (int256 result) {
        require(x <= MAX_WHOLE_59x18);
        result = x + (UNIT - (x % UNIT));
    }

    function div(int256 x, int256 y) internal pure returns (int256 result) {
        int256 scaledNumerator = x * UNIT;
        result = scaledNumerator / y;
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
    /// @dev Based on the function floor(x) = x - (x % 1e18).
    /// https://en.wikipedia.org/wiki/Floor_and_ceiling_functions
    ///
    /// Requirements:
    /// - `x` must be greater than or equal to the minimum whole value permitted by the signed 59.18 decimal format.
    ///
    /// @param x The signed 59.18 decimal number to floor.
    /// @param result The greatest integer less than or equal to x.
    function floor(int256 x) internal pure returns (int256 result) {
        require(x >= MIN_WHOLE_59x18);
        result = x - (x % UNIT);
    }

    /// @notice Yields the excess beyond x's floored value.
    ///
    /// @dev Based on the function frac(x) = x - [x]. https://en.wikipedia.org/wiki/Fractional_part
    ///
    /// Requirements:
    /// - Same as the `floor` function.
    ///
    /// @param x The signed 59.18 decimal number to get the fractional part of.
    /// @param result The fractional part of x.
    function frac(int256 x) internal pure returns (int256 result) {
        int256 flooredX = floor(x);
        result = x - flooredX;
    }

    /// @dev See https://stackoverflow.com/a/600306/3873510.
    function isPowerOfTwo(uint256 x) internal pure returns (bool result) {
        require(x > 0);
        result = (x & (x - 1)) == 0;
    }

    function ln(int256 x) internal pure returns (int256 result) {
        x;
        result = 0;
    }

    /// @notice Calculates the binary logarithm of x.
    ///
    /// @dev Based on the iterative approximation algorithm.
    /// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
    ///
    /// Requirements:
    /// - `x` must be higher than zero.
    ///
    /// @param x The signed 59.18 decimal number for which to calculate the binary logarithm.
    /// @return result The binary logarithm as a signed 59.18 decimal number.
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

    /// @notice Finds the zero-based index of the first zero in the binary representation of x.
    /// @dev See the "Find First Set" article on Wikipedia https://en.wikipedia.org/wiki/Find_first_set
    /// @param x The uint256 number for which to find the most significant bit.
    /// @param msb The most significant bit.
    function mostSignificantBit(uint256 x) internal pure returns (uint256 msb) {
        if (x >= TWO_POW_128) {
            x >>= 128;
            msb += 128;
        }
        if (x >= TWO_POW_64) {
            x >>= 64;
            msb += 64;
        }
        if (x >= TWO_POW_32) {
            x >>= 32;
            msb += 32;
        }
        if (x >= TWO_POW_16) {
            x >>= 16;
            msb += 16;
        }
        if (x >= TWO_POW_8) {
            x >>= 8;
            msb += 8;
        }
        if (x >= TWO_POW_4) {
            x >>= 4;
            msb += 4;
        }
        if (x >= TWO_POW_2) {
            x >>= 2;
            msb += 2;
        }
        if (x >= TWO_POW_1) {
            // No need to shift x any more.
            msb += 1;
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

    /// @dev See https://stackoverflow.com/a/1322548/3873510.
    function nextPowerOfTwo(uint256 x) internal pure returns (uint256 npot) {
        require(x > 0);
        npot = x - 1;
        npot |= npot >> 1;
        npot |= npot >> 2;
        npot |= npot >> 4;
        npot |= npot >> 8;
        npot |= npot >> 16;
        npot |= npot >> 32;
        npot |= npot >> 64;
        npot |= npot >> 128;
        npot += 1;
    }

    function sqrt(int256 x) internal pure returns (int256 result) {
        x;
        result = 0;
    }

    /// @notice Returns 1 in 59.18 representation, right padded by decimals zeros.
    function unit() public pure returns (int256 result) {
        result = UNIT;
    }
}
