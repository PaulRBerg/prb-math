// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { StdCheats, StdUtils } from "forge-std/Components.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { Assertions as PRBMathAssertions } from "src/test/Assertions.sol";
import { SD59x18 } from "src/SD59x18.sol";
import { UD60x18 } from "src/UD60x18.sol";

/// @title PRBMath__BaseTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across tests.
abstract contract PRBMath__BaseTest is PRBTest, PRBMathAssertions, StdCheats, StdUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                       STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Users {
        address payable alice;
        address payable bob;
        address payable eve;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                  TESTING VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        // Create users for testing. Order matters.
        users = Users({ alice: mkaddr("Alice"), bob: mkaddr("Bob"), eve: mkaddr("Eve") });

        // Make Alice the `msg.sender` and `tx.origin` for all subsequent calls.
        vm.startPrank(users.alice, users.alice);
    }

    /*//////////////////////////////////////////////////////////////////////////
                              CONSTANT HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    function bn(uint256 amount, uint256 decimals) internal pure returns (uint256 result) {
        result = amount * 10**decimals;
    }

    /*//////////////////////////////////////////////////////////////////////////
                            NON-CONSTANT HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Generates an address by hashing the name and labels the address.
    function mkaddr(string memory name) internal returns (address payable addr) {
        addr = payable(address(uint160(uint256(keccak256(abi.encodePacked(name))))));
        vm.label(addr, name);
    }
}
