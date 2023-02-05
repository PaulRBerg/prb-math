// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { SD59x18 } from "src/sd59x18/ValueType.sol";
import { PRBMathAssertions } from "src/test/Assertions.sol";
import { PRBMathUtils } from "src/test/Utils.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

/// @title Base_Test
/// @author Paul Razvan Berg
/// @notice Common contract members needed across tests.
abstract contract Base_Test is PRBTest, StdCheats, PRBMathAssertions, PRBMathUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                       STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Users {
        address payable alice;
        address payable bob;
        address payable eve;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev The maximum value an uint128 number can have.
    uint128 internal constant MAX_UINT128 = type(uint128).max;

    /// @dev The maximum value an uint40 number can have.
    uint128 internal constant MAX_UINT40 = type(uint40).max;

    /*//////////////////////////////////////////////////////////////////////////
                                  TESTING VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   SET-UP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        // Create users for testing.
        users = Users({ alice: mkaddr("Alice"), bob: mkaddr("Bob"), eve: mkaddr("Eve") });

        // Make Alice the `msg.sender` and `tx.origin` for all subsequent calls.
        vm.startPrank({ msgSender: users.alice, txOrigin: users.alice });
    }

    /*//////////////////////////////////////////////////////////////////////////
                              CONSTANT HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Bounds a `uint128` number.
    function boundUint128(uint128 x, uint128 min, uint128 max) internal view returns (uint128 result) {
        result = uint128(bound(uint256(x), uint256(min), uint256(max)));
    }

    /*//////////////////////////////////////////////////////////////////////////
                            NON-CONSTANT HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Generates an address by hashing the name and labels the address.
    function mkaddr(string memory name) internal returns (address payable addr) {
        addr = payable(address(uint160(uint256(keccak256(abi.encodePacked(name))))));
        vm.label({ account: addr, newLabel: name });
    }
}
