// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/ECPairingVerifier.sol"; // Adjust the path as necessary

contract ECPairingVerifierTest is Test {
    ECPairingVerifier verifier;

    function setUp() public {
        verifier = new ECPairingVerifier();
    }

  function testComputeX1() public {
    // Example test for computeX1 with fixed inputs
    uint256 x1 = 1;
    uint256 x2 = 2;
    uint256 x3 = 3;
    
    // Update these expected values to match the computed X1 values from the Python script
    uint256[2] memory expected = [
        uint256(4503322228978077916651710446042370109107355802721800704639343137502100212473),
        uint256(6132642251294427119375180147349983541569387941788025780665104001559216576968)
    ];

    uint256[2] memory result = verifier.computeX1(x1, x2, x3);
    assertEq(result[0], expected[0], "X coordinate does not match");
    assertEq(result[1], expected[1], "Y coordinate does not match");
}


   function testVerifyComputation() public {

    // Updated test for verifyComputation with corrected inputs
    uint256[2] memory A1 = [uint256(4503322228978077916651710446042370109107355802721800704639343137502100212473), uint256(6132642251294427119375180147349983541569387941788025780665104001559216576968)];
    uint256 x1 = 1;
    uint256 x2 = 2;
    uint256 x3 = 3;
    bool expected = true; // Adjust this based on the actual expected outcome

    // Corrected call to match the updated function signature
 //   bool result = verifier.verifyComputation(A1, x1, x2, x3);
bytes memory result = verifier.verifyComputation(A1, x1, x2, x3);
console.logBytes(result);
   // assertEq(result, expected, "Verification failed");
}


    // Fuzz testing for computeX1
    function testFuzzComputeX1(uint256 x1, uint256 x2, uint256 x3) public {
        // To prevent excessively large values, you might want to limit the size of inputs
        // Forge already limits these values but using bound for explicit range can be more readable
        vm.assume(x1 > 0 && x1 <= 1000);
        vm.assume(x2 > 0 && x2 <= 1000);
        vm.assume(x3 > 0 && x3 <= 1000);

        // Call computeX1 with fuzzed inputs and assert some property that should always hold
        // For example, that the output is not the zero point, if applicable
        uint256[2] memory result = verifier.computeX1(x1, x2, x3);
        assertTrue(result[0] != 0 || result[1] != 0, "Resulting point is unexpectedly zero");
    }
}
