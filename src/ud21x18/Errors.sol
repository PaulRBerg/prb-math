// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { UD21x18 } from "./ValueType.sol";

/// @notice Thrown when trying to cast a UD21x18 number that doesn't fit in uint40.
error PRBMath_UD21x18_IntoUint40_Overflow(UD21x18 x);
