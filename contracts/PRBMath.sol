// SPDX-License-Identifier: MIT
// solhint-disable code-complexity, func-name-mixedcase
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/// @title PRBMath
/// @author Paul Razvan Berg
/// @notice Smart contract library for mathematical functions. It operates with int256 numbers
/// considered to have 18 decimals, which are called 59.18 decimal numbers.
library PRBMath {
    /// @notice Number of bits that fit in the UNIT number.
    int256 public constant BITS_IN_UNIT = 59;

    /// @notice Half the UNIT number.
    int256 public constant HALF_UNIT = 5e17;

    /// @notice Twice the UNI number.
    int256 public constant TWICE_UNIT = 2e18;

    /// @notice 2 raised to the power of 1.
    int256 public constant TWO_POW_1 = 2**1;

    /// @notice 2 raised to the power of 2.
    int256 public constant TWO_POW_2 = 2**2;

    /// @notice 2 raised to the power of 4.
    int256 public constant TWO_POW_4 = 2**4;

    /// @notice 2 raised to the power of 8.
    int256 public constant TWO_POW_8 = 2**8;

    /// @notice 2 raised to the power of 16.
    int256 public constant TWO_POW_16 = 2**16;

    /// @notice 2 raised to the power of 32.
    int256 public constant TWO_POW_32 = 2**32;

    /// @notice 2 raised to the power of 63.
    int256 public constant TWO_POW_63 = 2**63;

    /// @notice 2 raised to the power of 64.
    int256 public constant TWO_POW_64 = 2**64;

    /// @notice 2 raised to the power of 128.
    int256 public constant TWO_POW_128 = 2**128;

    /// @notice Constant that determines how many decimals can be represented.
    int256 public constant UNIT = 1e18;

    /// @notice Finds the zero-based index of the first zero in the binary representation of the given number.
    /// @dev See the "Find First Set" article on Wikipedia https://en.wikipedia.org/wiki/Find_first_set
    /// @param x The number for which to find the most significant bit.
    /// @param msb The most significant bit.
    function mostSignificantBit(int256 x) internal pure returns (int256 msb) {
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

    /// @notice Calculates the binary logarithm of an unsigned 59.18 decimal number.
    ///
    /// @dev Implementation based on the iterative approximation algorithm.
    /// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
    ///
    /// Requirements:
    /// - `x` must be higher than zero.
    ///
    /// @param x The signed 59.18 decimal number for which to calculate the binary logarithm.
    /// @return logarithm The binary logarithm as a signed 59.18 decimal number.
    function log2(int256 x) internal pure returns (int256 logarithm) {
        require(x > 0);

        // Calculate the integer part by subtracting the number of bits in the UNIT number.
        int256 n = mostSignificantBit(x) - BITS_IN_UNIT;
        logarithm = n * UNIT;

        // Calculate y = x * 2^(-n).
        int256 y = x >> uint256(n);

        // If y = 1, there is no fractional part to compute.
        if (y == UNIT) {
            return logarithm;
        }

        // Calculate the fractional part via the iterative approximation.
        int256 delta;
        for (delta = HALF_UNIT; delta > 0; delta >>= 1) {
            y = (y * y) / UNIT;

            // Is y^2 > 2 and so in the range [2,4)?
            if (y >= TWICE_UNIT) {
                // Add the 2^(-m) factor to the logarithm.
                logarithm += delta;

                // Corresponds to z/2 on Wikipedia.
                y >>= 1;
            }
        }
    }
}
