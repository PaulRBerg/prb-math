// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, UNIT, EXP_MAX_INPUT } from "src/ud60x18/Constants.sol";
import { PRBMath_UD60x18_ProductLn_InputTooBig } from "src/ud60x18/Errors.sol";
import { productLn } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";
import { console2 } from "node_modules/forge-std/src/console2.sol";

contract ProductLn_Unit_Test is UD60x18_Unit_Test {
    function test_RevertWhen_GtMaxMinusUnit() external {
        UD60x18 x = MAX_UD60x18 - UNIT + UD60x18.wrap(1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_ProductLn_InputTooBig.selector, x));
        productLn(x);
    }

    // Actual values as provided by Wolfram Alpha. Expected values differ slightly due to precision loss.
    //     sets.push(set({ x: 0, expected: 0 }));
    //     sets.push(set({ x: 10, expected: 10 }));
    //     sets.push(set({ x: 0.1e18, expected: 0.091276527160862264e18 }));
    //     sets.push(set({ x: 0.5e18, expected: 0.351733711249195826e18 }));
    //     sets.push(set({ x: 1e18, expected: 0.567143290409783872e18 }));
    //     sets.push(set({ x: 2e18, expected: 0.852605502013725491e18 }));
    //     sets.push(set({ x: E, expected: 0.99999999999999999e18 }));
    //     sets.push(set({ x: PI, expected: 1.073658194796149172e18 }));
    //     sets.push(set({ x: 4e18, expected: 1.202167873197042939e18 }));
    //     sets.push(set({ x: 8e18, expected: 1.605811996320177596e18 }));
    //     sets.push(set({ x: 1 << 64, expected: 2.149604165721149567e18 }));
    //     sets.push(set({ x: EXP_MAX_INPUT, expected: 3.607865991876595583e18 }));
    //     sets.push(set({ x: 1 << 72, expected: 6.576554370186862927e18 }));
    //     sets.push(set({ x: 1e24, expected: 11.383358086140052622e18 }));
    //     sets.push(set({ x: 1 << 80, expected: 11.557875688514566228e18 }));
    //     sets.push(set({ x: 1 << 96, expected: 22.004357172804292983e18}));
    //     sets.push(set({ x: 1 << 112, expected: 32.698619683327803298e18 }));
    //     sets.push(set({ x: 1e36, expected: 37.813856075588763228e18 }));
    //     sets.push(set({ x: 1 << 128, expected: 43.503466806167642614e18 }));
    //     sets.push(set({ x: 1 << 160, expected: 65.278356678784907906e18 }));
    //     sets.push(set({ x: 1 << 192, expected: 87.169868269781877264e18 }));
    //     sets.push(set({ x: 1 << 224, expected: 109.125934196618053331e18 }));
    //     sets.push(set({ x: 1 << 232, expected: 114.621974678990178815e18 }));
    //     sets.push(set({ x: 1 << 240, expected: 120.120297937053547320e18 }));
    //     sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 131.123010654220946391e18 }));
    //     sets.push(set({ x: MAX_UD60x18, expected: 131.123010654220946391e18 }));
    function productLn_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, expected: 0 }));
        sets.push(set({ x: 10, expected: 8 })); // 2 wei off
        sets.push(set({ x: 0.1e18, expected: 0.091276527160862263e18 })); // 1 wei off
        sets.push(set({ x: 0.5e18, expected: 0.351733711249195823e18 })); // 3 wei off
        sets.push(set({ x: 1e18, expected: 0.567143290409783868e18 })); // 4 wei off
        sets.push(set({ x: 2e18, expected: 0.852605502013725488e18 })); // 3 wei off
        sets.push(set({ x: E, expected: 0.999999999999999994e18 })); // 6 wei off
        sets.push(set({ x: PI, expected: 1.073658194796149166e18 })); // 6 wei off
        sets.push(set({ x: 4e18, expected: 1.202167873197042932e18 })); // 7 wei off
        sets.push(set({ x: 8e18, expected: 1.60581199632017759e18 })); // 6 wei off
        sets.push(set({ x: 1 << 64, expected: 2.14960416572114956e18 })); // 7 wei off
        sets.push(set({ x: EXP_MAX_INPUT, expected: 3.607865991876595576e18 })); // 7 wei off
        sets.push(set({ x: 1 << 72, expected: 6.576554370186862919e18 })); // 8 wei off
        sets.push(set({ x: 1e24, expected: 11.383358086140052615e18 })); // 7 wei off
        sets.push(set({ x: 1 << 80, expected: 11.55787568851456622e18 })); // 8 wei off
        sets.push(set({ x: 1 << 96, expected: 22.00435717280429298e18 })); // 3 wei off
        sets.push(set({ x: 1 << 112, expected: 32.698619683327803296e18 })); // 2 wei off
        sets.push(set({ x: 1e36, expected: 37.813856075588763228e18 })); // 0 wei off
        sets.push(set({ x: 1 << 128, expected: 43.503466806167642615e18 })); // -1 wei off
        sets.push(set({ x: 1 << 160, expected: 65.278356678784907912e18 })); // -6 wei off
        sets.push(set({ x: 1 << 192, expected: 87.169868269781877274e18 })); // -10 wei off
        sets.push(set({ x: 1 << 224, expected: 109.125934196618053348e18 })); // -17 wei off
        sets.push(set({ x: 1 << 232, expected: 114.621974678990178834e18 })); // -19 wei off
        sets.push(set({ x: 1 << 240, expected: 120.120297937053547337e18 })); // -17 wei off
        sets.push(set({ x: MAX_WHOLE_UD60x18 - UNIT, expected: 131.123010654220946415e18 })); // -24 wei off
        sets.push(set({ x: MAX_UD60x18 - UNIT, expected: 131.123010654220946415e18 })); // -24 wei off
        return sets;
    }

    function test_ProductLn() external parameterizedTest(productLn_Sets()) {
        UD60x18 actual = productLn(s.x);
        assertEq(actual, s.expected, "UD60x18 productLn");
    }

    function test_ProductLn_Gas() external view {
        UD60x18 x = UD60x18.wrap(1e18);
        uint256 preGas = gasleft();
        productLn(x);
        console2.log("Gas used: productLn ", preGas - gasleft());
    }

    // We limit fuzz values to 2^72 - 1 since the max exponential input is less than this anyways.
    function testFuzz_ProductLn_ErrorBound(uint72 x_) external pure {
        UD60x18 x = UD60x18.wrap(uint256(x_));
        x = x % (EXP_MAX_INPUT + UD60x18.wrap(1)); // limit the input to the max exponential input for comparison
        if (x > MAX_UD60x18 / x.exp()) return; // product of x and e^x must be less than the max UD60x18 value

        // Using the identity: x = W(x * e^x), we can check the internal error bound below for the exp and productLn function
        // roundtrip below the selected input.
        // The error bound is calculated as the absolute difference between the actual value and the expected value,
        // knowing our approximation is less than the actual value for this value range.
        UD60x18 w = x.exp().mul(x);
        console2.log("xex: ", w.unwrap());
        w = productLn(w);

        UD60x18 err = x - w;
        console2.log("x: ", x.unwrap());
        console2.log("w: ", w.unwrap());
        console2.log("err: ", err.unwrap());
        assertLe(err.unwrap(), 17); // Determined by iterative fuzzing with the maximum possible number of fuzz runs (2^32 - 1)
    }
}
