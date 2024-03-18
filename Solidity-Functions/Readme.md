# Rational Number Addition and Matrix Multiplication In Solidity 

## Overview


## We will review each function below

### Add

```solidity 
  function add(ECPoint memory P, ECPoint memory Q) public view returns (ECPoint memory R)
```

The add function within your Solidity contract is designed to perform the addition of two points (P and Q) on an elliptic curve and return the result as a new point R. This operation is fundamental to elliptic curve cryptography (ECC), which underlies many cryptographic systems, including those used in blockchain technologies. Here's a detailed explanation of how this function works:

1. We preform a static call to the `0x06` Elliptic Curve Addition Contract precompiled contract.

`(bool success, bytes memory data) = address(0x06).staticcall(abi.encode(P.x, P.y, Q.x, Q.y));`


`(bool success, bytes memory data) =:` 

This part declares two variables on the left side of the assignment. 
`success` is a boolean variable that will be true if the call was successful (i.e., didn't revert) and false otherwise. 
`data` is a variable of type bytes memory that will hold any data returned by the call if it was successful.

`address(0x06).staticcall(...):` 

* This performs a low-level call to the contract at the specified address (0x06). 

* The staticcall is a type of Ethereum Virtual Machine (EVM) call that executes the target address's code in the context of the current contract without allowing any modifications to the state (i.e., it's "read-only"). 

* It's used here presumably to interact with a precompiled contract at address 0x06, which provides certain cryptographic or computational functions optimized by the Ethereum network. 

```
Note that the actual Ethereum precompiled contracts are located at addresses starting from 0x01 to 0x09.
```

`abi.encode(P.x, P.y, Q.x, Q.y):` 

This encodes the arguments to be passed to the function call. abi.encode takes a list of Solidity variables and serializes them into a single bytes array according to the Ethereum ABI (Application Binary Interface) specification. 

Here, it encodes the x and y components of two ECPoint structs, P and Q, which represent points on an elliptic curve. 
This encoded data is passed as the input data to the staticcall.


2. Error Handling: If the call to the precompiled contract fails (which could happen for various reasons, such as invalid input data or issues within the precompiled contract itself), the operation reverts with a custom error ECAdditionFailed(). 
    This error handling ensures that the function caller is informed of the failure in a clear and concise manner.

3. Decoding the Result: (R.x, R.y) = abi.decode(data, (uint256, uint256)) - If the call succeeds, the returned data (data) is decoded from a bytes array back into two uint256 values, which represent the x and y coordinates of the resulting elliptic curve point R. 

This decoding is necessary because the Ethereum ABI encoding is used to pack the return values into the bytes array format.

#### Summary
The add function provides a way to perform elliptic curve point addition within a Solidity contract by leveraging a hypothetical precompiled contract designed for this purpose. It encapsulates the complexities of ECC operations, making them accessible through a simple and straightforward interface. This approach allows for efficient and secure implementation of cryptographic operations critical to many decentralized applications.

### matmul 

```solidity
     function matmul(uint256[] calldata matrix, uint256 n, ECPoint[] calldata s, uint256[] calldata o) public view returns (bool verified) {
```

The matmul function is a sophisticated example of integrating elliptic curve cryptography (ECC) operations within a Solidity contract to perform matrix multiplication. This function specifically operates on matrices where the elements are not traditional numbers but elliptic curve points, showcasing an advanced application in cryptographic protocols or mathematical computations on blockchain platforms. Here's an explanation of the function's components and its operational logic:

1. Input Validation: The function begins by ensuring the dimensions of the input matrix and arrays match the expected sizes for an n×n matrix multiplication. If the dimensions are incorrect, it reverts with InvalidDimensions, preventing further execution with invalid data.
    ```solidity
         if (matrix.length != n * n || s.length != n || o.length != n) {
            revert InvalidDimensions();
        }
    ```

2. Matrix Multiplication:

The function iterates over each row of the matrix (outer loop indexed by i) and initializes an ECPoint named result to the identity element of elliptic curve addition. 

This point effectively acts as a "zero" in the context of elliptic curve point addition.

For each element in the row (inner loop indexed by j), it performs scalar multiplication of the elliptic curve point s[j] by the scalar value matrix[i * n + j]. This operation is akin to multiplying a matrix element by a vector element in traditional matrix multiplication, but in this context, the "multiplication" is performed as scalar multiplication on an elliptic curve point.

The resulting point from each scalar multiplication is then added to the result point using the add function. This addition accumulates the results of scalar multiplications for each row, analogous to summing the products in a row-by-vector multiplication.

3. Verification: 

After computing the result for each row, the function compares the computed elliptic curve point (result) to the expected output point (o[i]). 
It checks both the x and y coordinates for equality. If any computed point does not match the expected point, the function immediately returns false.

Successful Verification: If all computed points match their corresponding expected points, the function completes its iterations and returns true, indicating the matrix multiplication operated on the elliptic curve points as expected and produced the anticipated output.

### scalarMul

    ```solidity 
    function scalarMul(ECPoint memory p, uint256 scalar) public view returns (ECPoint memory r) {
    ```

This function takes in an elliptic curve `p` and a scalar.


Then it initates a static call to the precompiled addresses 7. Passing in the x-axis and the y-axis of the points after encoding them.

This function will revert if this line does not return ok.



    ```solidity
    (bool ok, bytes memory result) = address(7).staticcall(abi.encode(p.x, p.y, scalar));
    ```


The result is then decoded. Meaning the bytes array that is returned is then decoded back into two uint256's `x` and `y` and assigns them to the struct.

    ```solidity
    (r.x, r.y) = abi.decode(result, (uint256, uint256));
    ```


### Summary 

This function essentially delegates the computation of an elliptic curve scalar multiplication to an external entity the precompiled contract at address(7), handles potential errors gracefully, and decodes the result back into a struct. This pattern is useful when the computation is too complex or gas-intensive to implement directly in Solidity, or when leveraging precompiled contracts provided by the Ethereum platform for specific cryptographic operations.

### rationalAdd

is designed to verify a specific cryptographic operation involving elliptic curve points. It checks whether the sum of two points `A` and `B`  on an elliptic curve is equal to another point calculated by multiplying a generator point `G` by a fraction `numerator/denominator` all operations considered under a finite field defined by `order`.

    ```solidity
    function rationalAdd(ECPoint calldata A, ECPoint calldata B, uint256 num, uint256 den) public view returns (bool verified) 
    ```

Function Declaration: The function `rationalAdd` takes two elliptic curve points `A` and `B` (as calldata, which is a way to pass arguments to functions that doesn't copy the data to memory, saving gas when called externally), and two `uint256` integers` num (numerator)` and `den (denominator)`. It is a public view function, meaning it can be called by anyone and does not modify the contract state. It returns a boolean verified.

    ```solidity
    if(den == 0){
        revert InvalidDenominatorIsZero();
    }
    ```

We first check if the denominator is 0 it is not valid if it is so the function will revert.

    ```solidity
    ECPoint memory LHS = add(A, B);
    ```

Left-Hand Side Calculation: Calculates the left-hand side `LHS` of the equation.

This is done by adding points `A` and `B` using the add function (presumably a function defined elsewhere in the contract that performs elliptic curve point addition). The result is stored in memory as `LHS`.


    ```solidity
    uint256 rhs = mulmod(num, EllipticCurve.invMod(den, order), order);
    ```

Right-Hand Side Calculation: Calculates the right-hand side (RHS) of the equation. 

1. First, it computes the "modular inverse" of `den` modulo order using `EllipticCurve.invMod(den, order)`, a function that calculates the multiplicative inverse of `den modul`o order (a prime number defining the size of the finite field). 

2. Then, it multiplies this inverse by `num` and takes the result modulo order using `mulmod`, ensuring the result is within the field defined by order.

    `mulmod`(uint x, uint y, uint k) returns (uint): compute (x * y) % k where the multiplication is performed with arbitrary precision and does not wrap around at 2**256. Assert that k != 0


    ```solidity
    verified = LHS.x == RHSx && LHS.y == RHSy;
    ```

This part checks if the x and y coordinates of the left-hand side (LHS) are equal to those of the right-hand side (RHSx, RHSy). 

If they are equal, the operation verifies the equation `A+B=num/den ⋅G` on the elliptic curve, setting verified to true; otherwise, verified is false.