// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { SD59x18 } from "src/sd59x18/ValueType.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { PRBMathAssertions } from "./utils/Assertions.sol";
import { PRBMathUtils } from "./utils/Utils.sol";

/// @title Base_Test
/// @author Paul Razvan Berg
/// @notice Base test contract with common logic needed by all tests.
abstract contract Base_Test is PRBTest, StdCheats, PRBMathAssertions, PRBMathUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                       STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Users {
        address alice;
        address bob;
        address eve;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev The maximum value an uint128 number can have.
    uint128 internal constant MAX_UINT128 = type(uint128).max;

    /// @dev The maximum value an uint40 number can have.
    uint128 internal constant MAX_UINT40 = type(uint40).max;

    /*//////////////////////////////////////////////////////////////////////////
                                     VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   SET-UP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        // Create users for testing.
        users = Users({ alice: makeAddr("Alice"), bob: makeAddr("Bob"), eve: makeAddr("Eve") });

        // Make Alice the `msg.sender` and `tx.origin` for all subsequent calls.
        vm.startPrank({ msgSender: users.alice, txOrigin: users.alice });
    }
}
