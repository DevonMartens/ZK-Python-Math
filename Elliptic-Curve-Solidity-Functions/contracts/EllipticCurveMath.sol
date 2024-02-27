// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;


// Import the elliptic curve library for solidity
import "elliptic-curve-solidity/contracts/EllipticCurve.sol";


/// @title EllipticCurveSolidityContract  - A contract for elliptic curve operations and rational number verification
/// @notice This contract demonstrates operations on elliptic curves and a zero-knowledge proof method for rational number addition
contract EllipticCurveSolidityContract {


    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    // The order of the elliptic curve, a prime number defining the finite field size
    uint256 order = 21888242871839275222246405745257275088548364400416034343698204186575808495783;
    // A generator point on the elliptic curve
    ECPoint G = ECPoint(1, 2);


    /// @notice Adds two points on the elliptic curve
    /// @param P The first point to add
    /// @param Q The second point to add
    /// @return R The result of the addition
    /// @dev This function calls a the "Elliptic Curve Addition Contract" precompiled at address 0x06 for efficient point addition
    function add(ECPoint memory P, ECPoint memory Q) public view returns (ECPoint memory R) {
        // We use the staticcall function to call a hypothetical precompiled contract at address 0x06
        (bool success, bytes memory data) = address(0x06).staticcall(abi.encode(P.x, P.y, Q.x, Q.y));
        if(!success){
            revert("ECAdditionFailed");
        }
        (R.x, R.y) = abi.decode(data, (uint256, uint256));
    }

    /// @notice Performs matrix multiplication where the matrix operates on elliptic curve points
    /// @param matrix A flat array representing the matrix
    /// @param n The dimension of the matrix (n x n)
    /// @param s The array of elliptic curve points to be multiplied
    /// @param o The expected output array of elliptic curve points
    /// @return verified True if the operation results match the expected output, false otherwise
    /// @dev Validates dimensions before performing matrix multiplication in the context of elliptic curve operations
    function matmul(uint256[] calldata matrix, uint256 n, ECPoint[] calldata s, uint256[] calldata o) public view returns (bool verified) {
        if (matrix.length != n * n || s.length != n || o.length != n) {
            revert("InvalidDimensions");
        }

        // Iterate through each row of the matrix to perform elliptic curve point multiplication and accumulation
        for (uint256 i = 0; i < n; i++) {
            ECPoint memory result = ECPoint(0, 0); // Initialize to the identity element of elliptic curve addition

            // Perform scalar multiplication of each point in s[] by its corresponding matrix value,
            // then add to the cumulative result for this row
            for (uint256 j = 0; j < n; j++) {
                ECPoint memory temp = scalarMul(s[j], matrix[i * n + j]);
                result = add(result, temp);
            }

            if (result.x != o[i]) {

                return false;
            }
        }
        return true;
    }

    /// @notice Performs scalar multiplication of an elliptic curve point
    /// @param p The point to be multiplied
    /// @param scalar The scalar value for multiplication
    /// @return r The resulting elliptic curve point after multiplication
    /// @dev Calls a hypothetical precompiled contract at address 0x07 for efficient scalar multiplication
    function scalarMul(ECPoint memory p, uint256 scalar) public view returns (ECPoint memory r) {
        (bool ok, bytes memory result) = address(7).staticcall(abi.encode(p.x, p.y, scalar));
        if(!ok) {
            revert("MultiplicationFailed");
        }
        (r.x, r.y) = abi.decode(result, (uint256, uint256));
    }

    /// @notice Verifies a claim about the addition of two rational numbers in a zero-knowledge context
    /// @param A The first elliptic curve point representing a rational number
    /// @param B The second elliptic curve point representing a rational number
    /// @param num The numerator of the claimed sum
    /// @param den The denominator of the claimed sum
    /// @return verified True if the claim is verified, false otherwise
    /// @dev This function demonstrates a zero-knowledge proof of knowledge of two numbers that add up to num/den
    function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den) public view returns (bool verified) {
        if(den == 0){
            revert("InvalidDenominatorIsZero");
        } 
        ECPoint memory LHS = add(A, B);
        uint256 rhs = mulmod(num, EllipticCurve.invMod(den, order), order);
        (uint RHSx, uint RHSy) = mul(rhs, G.x, G.y);
        verified = LHS.x == RHSx && LHS.y == RHSy;
        return verified;
    }

    function mul(uint256 scalar, uint256 x1, uint256 y1) internal view returns (uint256 x, uint256 y) {
        (bool ok, bytes memory result) = address(7).staticcall(abi.encode(x1, y1, scalar));
        require(ok, "mul failed");
        (x, y) = abi.decode(result, (uint256, uint256));
    } 
}