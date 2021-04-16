// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.8.0;

import "../PRBMathCommon.sol";

contract MulDivInvariant {
    function checkMulDiv(
        uint256 x,
        uint256 y,
        uint256 d
    ) external pure {
        require(d > 0);
        uint256 z = PRBMathCommon.mulDiv(x, y, d);
        if (x == 0 || y == 0) {
            assert(z == 0);
            return;
        }

        // recompute x and y via mulDiv of the result of floor(x*y/d), should always be less than original inputs by < d
        uint256 x2 = PRBMathCommon.mulDiv(z, d, y);
        uint256 y2 = PRBMathCommon.mulDiv(z, d, x);
        assert(x2 <= x);
        assert(y2 <= y);

        assert(x - x2 < d);
        assert(y - y2 < d);
    }
}
