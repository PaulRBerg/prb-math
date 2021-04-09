// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./PRBMathCommon.sol";

library PRBMathUD60x18 {
    /// @dev Half the UNIT number.
    uint256 internal constant HALF_UNIT = 5e17;

    /// @dev The maximum value an unsigned 60.18-decimal fixed-point number can have.
    uint256 internal constant MAX_60x18 = type(uint256).max;

    /// @dev The maximum whole value an unsigned 60.18-decimal fixed-point number can have.
    uint256 internal constant MAX_WHOLE_60x18 = type(uint256).max - (type(uint256).max % UNIT);

    /// @dev Twice the UNI number.
    uint256 internal constant TWICE_UNIT = 2e18;

    /// @dev Constant that determines how many decimals can be represented.
    uint256 internal constant UNIT = 1e18;

    /// @dev Largest power of two divisor of UNIT.
    uint256 internal constant UNIT_LPOTD = 262144;

    /// @dev UNIT inverted mod MAX_60x18.
    uint256 internal constant UNIT_INVERSE = 78156646155174841979727994598816262306175212592076161876661508869554232690281;

    /// @notice Divides two 60.18-decimal fixed-point numbers, returning a new 60.18-decimal fixed-point number.
    ///
    /// @dev Scales the numerator first, then divides by the denominator.
    ///
    /// Requirements:
    /// - y cannot be zero.
    ///
    /// @param x The numerator as an unsigned 60.18-decimal fixed-point number.
    /// @param y The denominator as an unsigned 60.18-decimal fixed-point number.
    /// @param result The quotient as an unsigned 60.18-decimal fixed-point number.
    function div(uint256 x, uint256 y) internal pure returns (uint256 result) {
        result = PRBMathCommon.mulDiv(x, UNIT, y);
    }

    /// @notice Multiplies two unsigned 60.18-decimal fixed-point numbers, returning a new unsigned 60.18-decimal
    /// fixed-point number.
    ///
    /// @dev Implements a variant of "mulDiv" with constant folding because the denominator is always UNIT.
    ///
    /// Requirements:
    /// - The product must fit within MAX_60x18.
    ///
    /// Caveats:
    /// - Read the comments in the PRBMathCommon.mulDiv function to understand the hieroglyphs below.
    /// - Rounds instead of truncating, e.g. 6.6e-19 would be truncated to 0 instead of being rounded to 1e-18.
    ///
    /// @param x The multiplicand as an unsigned 60.18-decimal fixed-point number.
    /// @param y The multiplier as an unsigned 60.18-decimal fixed-point number.
    /// @param result The product as an unsigned 60.18-decimal fixed-point number.
    function mul(uint256 x, uint256 y) internal pure returns (uint256 result) {
        uint256 prod0;
        uint256 prod1;
        assembly {
            let mm := mulmod(x, y, not(0))
            prod0 := mul(x, y)
            prod1 := sub(sub(mm, prod0), lt(mm, prod0))
        }

        if (prod1 == 0) {
            unchecked {
                result = prod0 / UNIT;
                return result;
            }
        }

        require(UNIT > prod1);

        assembly {
            let remainder := mulmod(x, y, UNIT)
            result := mul(
                or(
                    div(sub(prod0, remainder), UNIT_LPOTD),
                    mul(sub(prod1, gt(remainder, prod0)), add(div(sub(0, UNIT_LPOTD), UNIT_LPOTD), 1))
                ),
                UNIT_INVERSE
            )
        }
    }
}
