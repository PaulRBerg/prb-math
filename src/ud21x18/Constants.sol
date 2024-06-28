// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { UD21x18 } from "./ValueType.sol";

/// @dev Euler's number as a UD21x18 number.
UD21x18 constant E = UD21x18.wrap(2_718281828459045235);

/// @dev The maximum value a UD21x18 number can have.
uint128 constant uMAX_UD21x18 = 340282366920938463463_374607431768211455;
UD21x18 constant MAX_UD21x18 = UD21x18.wrap(uMAX_UD21x18);

/// @dev PI as a UD21x18 number.
UD21x18 constant PI = UD21x18.wrap(3_141592653589793238);

/// @dev The unit number, which gives the decimal precision of UD21x18.
uint256 constant uUNIT = 1e18;
UD21x18 constant UNIT = UD21x18.wrap(1e18);
