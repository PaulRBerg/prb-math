// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { PRBTest } from "@prb/test/PRBTest.sol";

import { SD1x18 } from "../SD1x18.sol";
import { SD59x18 } from "../SD59x18.sol";
import { UD2x18 } from "../UD2x18.sol";
import { UD60x18 } from "../UD60x18.sol";

contract Assertions is PRBTest {
    /*//////////////////////////////////////////////////////////////////////////
                                       SD1X18
    //////////////////////////////////////////////////////////////////////////*/
    function assertEq(SD1x18 a, SD1x18 b) internal {
        assertEq(SD1x18.unwrap(a), SD1x18.unwrap(b));
    }

    function assertEq(SD1x18 a, int64 b) internal {
        assertEq(SD1x18.unwrap(a), b);
    }

    function assertEq(int64 a, SD1x18 b) internal {
        assertEq(a, SD1x18.unwrap(b));
    }

    function assertEq(SD1x18[] memory a, SD1x18[] memory b) internal {
        int256[] memory castedA;
        int256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    function assertEq(SD1x18[] memory a, int64[] memory b) internal {
        int256[] memory castedA;
        int256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    function assertEq(int64[] memory a, SD1x18[] memory b) internal {
        int256[] memory castedA;
        int256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                       SD59X18
    //////////////////////////////////////////////////////////////////////////*/

    function assertEq(SD59x18 a, SD59x18 b) internal {
        assertEq(SD59x18.unwrap(a), SD59x18.unwrap(b));
    }

    function assertEq(SD59x18 a, int256 b) internal {
        assertEq(SD59x18.unwrap(a), b);
    }

    function assertEq(int256 a, SD59x18 b) internal {
        assertEq(a, SD59x18.unwrap(b));
    }

    function assertEq(SD59x18[] memory a, SD59x18[] memory b) internal {
        int256[] memory castedA;
        int256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    function assertEq(SD59x18[] memory a, int256[] memory b) internal {
        int256[] memory castedA;
        assembly {
            castedA := a
        }
        assertEq(castedA, b);
    }

    function assertEq(int256[] memory a, SD59x18[] memory b) internal {
        int256[] memory castedB;
        assembly {
            castedB := b
        }
        assertEq(a, b);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                       UD2X18
    //////////////////////////////////////////////////////////////////////////*/

    function assertEq(UD2x18 a, UD2x18 b) internal {
        assertEq(UD2x18.unwrap(a), UD2x18.unwrap(b));
    }

    function assertEq(UD2x18 a, uint64 b) internal {
        assertEq(UD2x18.unwrap(a), uint256(b));
    }

    function assertEq(uint64 a, UD2x18 b) internal {
        assertEq(uint256(a), UD2x18.unwrap(b));
    }

    function assertEq(UD2x18[] memory a, UD2x18[] memory b) internal {
        uint256[] memory castedA;
        uint256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    function assertEq(UD2x18[] memory a, uint64[] memory b) internal {
        uint256[] memory castedA;
        uint256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    function assertEq(uint64[] memory a, UD2x18[] memory b) internal {
        uint256[] memory castedA;
        uint256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                       UD60X18
    //////////////////////////////////////////////////////////////////////////*/

    function assertEq(UD60x18 a, UD60x18 b) internal {
        assertEq(UD60x18.unwrap(a), UD60x18.unwrap(b));
    }

    function assertEq(UD60x18 a, uint256 b) internal {
        assertEq(UD60x18.unwrap(a), b);
    }

    function assertEq(uint256 a, UD60x18 b) internal {
        assertEq(a, UD60x18.unwrap(b));
    }

    function assertEq(UD60x18[] memory a, UD60x18[] memory b) internal {
        uint256[] memory castedA;
        uint256[] memory castedB;
        assembly {
            castedA := a
            castedB := b
        }
        assertEq(castedA, castedB);
    }

    function assertEq(UD60x18[] memory a, uint256[] memory b) internal {
        uint256[] memory castedA;
        assembly {
            castedA := a
        }
        assertEq(castedA, b);
    }

    function assertEq(uint256[] memory a, SD59x18[] memory b) internal {
        uint256[] memory castedB;
        assembly {
            castedB := b
        }
        assertEq(a, b);
    }
}
