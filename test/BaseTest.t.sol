// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { StdUtils } from "forge-std/StdUtils.sol";

import { SD59x18 } from "src/sd59x18/ValueType.sol";
import { PRBMathAssertions } from "src/test/Assertions.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

/// @title BaseTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across tests.
abstract contract BaseTest is PRBTest, PRBMathAssertions, StdCheats, StdUtils {
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

    function bn(uint256 amount, uint256 decimals) internal pure returns (uint256 result) {
        result = amount * 10 ** decimals;
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
