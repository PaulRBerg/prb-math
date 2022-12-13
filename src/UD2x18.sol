// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

/// @notice The unsigned 2.18-decimal fixed-point number representation, which can have up to 2 digits and up to 18 decimals.
/// The values of this are bound by the minimum and the maximum values permitted by the underlying Solidity type uint64.
/// This is useful when end users want to use uint64 to save gas, e.g. with tight variable packing in contract storage.
type UD2x18 is uint64;

/*//////////////////////////////////////////////////////////////////////////
                            CONVERSION FUNCTIONS
//////////////////////////////////////////////////////////////////////////*/

/// @notice Wraps a signed integer into the UD2x18 type.
function ud2x18(uint64 x) pure returns (UD2x18 result) {
    result = UD2x18.wrap(x);
}
