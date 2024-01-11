// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SD21x18 } from "./ValueType.sol";

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in SD1x18.
error PRBMath_SD21x18_IntoSD1x18_Overflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in SD1x18.
error PRBMath_SD21x18_IntoSD1x18_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in UD2x18.
error PRBMath_SD21x18_ToUD2x18_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in UD21x18.
error PRBMath_SD21x18_ToUD21x18_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in UD60x18.
error PRBMath_SD21x18_ToUD60x18_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in uint256.
error PRBMath_SD21x18_ToUint256_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in uint128.
error PRBMath_SD21x18_ToUint128_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in uint64.
error PRBMath_SD21x18_ToUint64_Overflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in uint64.
error PRBMath_SD21x18_ToUint64_Underflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in uint40.
error PRBMath_SD21x18_ToUint40_Overflow(SD21x18 x);

/// @notice Thrown when trying to cast a SD21x18 number that doesn't fit in uint40.
error PRBMath_SD21x18_ToUint40_Underflow(SD21x18 x);
