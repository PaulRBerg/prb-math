// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SD21x18 } from "./ValueType.sol";

/// @notice Thrown when trying to cast an SD21x18 number that doesn't fit in uint128.
error PRBMath_SD21x18_ToUint128_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast an SD21x18 number that doesn't fit in UD60x18.
error PRBMath_SD21x18_ToUD60x18_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast an SD21x18 number that doesn't fit in uint256.
error PRBMath_SD21x18_ToUint256_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast an SD21x18 number that doesn't fit in uint40.
error PRBMath_SD21x18_ToUint40_Overflow(SD21x18 x);

/// @notice Thrown when trying to cast an SD21x18 number that doesn't fit in uint40.
error PRBMath_SD21x18_ToUint40_Underflow(SD21x18 x);
