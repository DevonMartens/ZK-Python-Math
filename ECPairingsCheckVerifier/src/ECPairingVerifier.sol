// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract ECPairingVerifier {


       // A
    uint256 constant aG1_x =
        $aG1_x;
    uint256 constant aG1_y =
        $aG1_y;

    // B
    uint256 constant bG2_x1 =
        $bG2_x1;
    uint256 constant bG2_x2 =
        $bG2_x2;
    uint256 constant bG2_y1 =
        $bG2_y1;
    uint256 constant bG2_y2 =
        $bG2_y2;

    // alpha
    uint256 constant alphaG1_x =
        $alphaG1_x;
    uint256 constant alphaG1_y =
        $alphaG1_y;

    // beta
    uint256 constant betaG2_x1 =
        $betaG2_x1;
    uint256 constant betaG2_x2 =
        $betaG2_x2;
    uint256 constant betaG2_y1 =
        $betaG2_y1;
    uint256 constant betaG2_y2 =
        $betaG2_y2;

    // C
    uint256 constant cG1_x =
        $cG1_x;
    uint256 constant cG1_y =
        $cG1_y;

    // K1 
    uint256 constant k1G1_x =
        $k1G1_x;
    uint256 constant k1G1_y =
        $k1G1_y;

    // K2
    uint256 constant k2G1_x =
        $k2G1_x;
    uint256 constant k2G1_y =
        $k2G1_y;

    // public input
    uint256 one = $one;
    uint256 out = $out;

    uint256 constant G2_x1 =
        10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant G2_x2 =
        11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant G2_y1 =
        8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant G2_y2 =
        4082367875863433681332203403145435568316851327593401208105741076214120093531;

    uint256 constant Q =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    struct G1Point {
        uint256 x;
        uint256 y;
    }

    struct G2Point {
        uint256 x1;
        uint256 x2;
        uint256 y1;
        uint256 y2;
    }

    

    // Example values for the elliptic curve base point G1
    // Replace these with actual values as needed
    uint256 constant g1x = 1;
    uint256 constant g1y = 2;

    // Ethereum precompiled contracts addresses for elliptic curve operations
    address constant precompileAdd = address(0x06);
    address constant precompileMul = address(0x07);
    address constant precompilePairing = address(0x08);

    function computeK(uint256[2] memoryinputs) public view returns (G1Point memory K) {
        // Perform scalar multiplication for each x_i with G1 and sum the results
        G1Point memory k1 =  scalarMul(G1Point(k1G1_x, k1G1_y), input[0]);
        G1Point memory k2 = scalarMul(G1Point(k2G1_x, k2G1_y), input[1]);
        G1Point memory K = add(k1, k2);

        // Sum the results: X1 = x1G1 + x2G1 + x3G1
        uint256[2] memory temp = add(x1G1[0], x1G1[1], x2G1[0], x2G1[1]);
        X1 = add(temp[0], temp[1], x3G1[0], x3G1[1]);
        return X1;
    }

    function add(uint256 x1, uint256 y1, uint256 x2, uint256 y2) internal view returns (uint256[2] memory R) {
        // Call the precompiled contract for EC addition
        (bool success, bytes memory data) = precompileAdd.staticcall(abi.encodePacked(x1, y1, x2, y2));
        require(success, "EC addition failed.");
        (R[0], R[1]) = abi.decode(data, (uint256, uint256));
        return R;
    }

    function scalarMul(G1Point memory, uint256 scalar) internal view returns (uint256[2] memory R) {
        // Call the precompiled contract for EC scalar multiplication
        (bool success, bytes memory data) = precompileMul.staticcall(abi.encodePacked(x, y, scalar));
        require(success, "Scalar multiplication failed.");
        (R[0], R[1]) = abi.decode(data, (uint256, uint256));
        return R;
    }

 
    function negate(G1Point memory p) internal pure returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        if (p.x == 0 && p.y == 0) return G1Point(0, 0);
        return G1Point(p.x, Q - (p.y % Q));
    }



    function verifyComputation(
        G1Point memory A,
        G2Point memory B,
        G1Point memory C,
        uint256[2] memoryinputs
        // uint256[2][2] memory A1,
        // uint256 x1,
        // uint256 x2,
        // uint256 x3
    ) public view 
    returns (bool) {

        // GET NEW POINTT

        G1Point memory K = computek(memoryinputs);

     //   uint256[2] memory X1 = computeX1(x1, x2, x3);

        // Prepare inputs for the pairing check
        bytes memory inputForPairing = prepareInputForPairing(X1, A1);

        // Perform the pairing check
        (bool success, bytes memory output) = precompilePairing.staticcall(inputForPairing);
       require(success && output.length > 0, "Pairing check failed or output invalid.");
       return output[0] != 0;

    }

    function prepareInputForPairing(
        G1Point memory A,
        G2Point memory B,
        G1Point memory C,
        G1Point memory K

    ) internal pure returns (bytes memory) {
        // Encoding G1 and G2 points
           //POINT1

      // -A * B + alpha * beta + C * 1(G2) + K * 1(G2) = 0
        bytes memory point1 = abi.encode(
            A.x,
            negate(A).y,
            B.x2,
            B.x1,
            B.y2,
            B.y1,
            alphaG1_x,
            alphaG1_y,
            betaG2_x2,
            betaG2_x1,
            betaG2_y2,
            betaG2_y1
        );

    //POINT2

        bytes memory point2 = abi.encode(
            C.x, 
            C.y,
            G2_x2,
            G2_x1,
            G2_y2,
            G2_y1,
            K.x,
            K.y,
            G2_x2,
            G2_x1,
            G2_y2,
            G2_y1
        );
        // put in three poin
        return abi.encodePacked(point1, point2);
    }
}