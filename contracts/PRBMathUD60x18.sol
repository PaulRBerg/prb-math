// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.8.0;

import "hardhat/console.sol";

library PRBMathUD60x18 {
    uint256 internal constant HALF_UNIT = 5e17;
    uint256 internal constant MAX_60x18 = type(uint256).max;
    uint256 internal constant MAX_WHOLE_60x18 = type(uint256).max - (type(uint256).max % UNIT);
    uint256 internal constant MIN_60x18 = type(uint256).min;
    uint256 internal constant MIN_WHOLE_60x18 = type(uint256).min - (type(uint256).min % UNIT);
    uint256 internal constant UNIT = 1e18;

    function mul(uint256 x, uint256 y) internal pure returns (uint256 result) {
        x;
        y;
        result = 0;
    }
}
