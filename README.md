# ZK-Python-Math

# Part 1 Homomorphisms

A function that maps to groups together,

### Assignment 1 Compute the discrete logarithm

A logarithm is a mathematical operation that is the inverse of exponentiation. It answers the question: to what exponent must a given base be raised to produce a certain number?

Here we use brute force to find the solution.

**Brute force** programatically involves systematically enumerating through all possible canidates for a solution then checking the solution to see if it satifys the conditions.

E(s) = g^s mod n

Part 1: 

* Input parameters g is the base exponent here.
* s_p the result is of the modular exponent mod n
* the modulus here is the "wrap around point"

Part 2:

* Brute force does as intended and iterates through all possible canidates for s.
    * s is the canidate for the exponent in the loop
    * n is modulus that determines the range for which s must fall in

* Comparing known result (compute g^s) g^s % n = sp then s satifys the result

### Assignment 2: Break the crytography and obtain the secret number

`sympy.ntheory` and `discrete log` imports

* `discrete log` is a function designed to work efficently for a wide range of problems when brute force is impractical due to computational complexity
* the function uses a variety of algorithms unders the hood to optimize the search for 3.
* Including some specialized methods where certain conditions are met (g is the prime root of modulo n)
* We use this to solve g^s mod n

### Assignment 3: Find the bug in the code. The bug is as follows n is not corectly applied over multiplication.

* It's saying `g^a+b mod n` = `g^a * g^b mod n`

### Assignment 4: Covert the above zk proof system where you can prove to a verifier that with an agreed up `g`. Your solution is agreed upon with out revealing a solution

`sympy`is a python library for symbolic mathmatics (demonstrates) encryption by using modular exponentation

`2x + 8y = 7944`
`5x + 3y = 4764`

1. Script then defines x,y as symbols
2. Solves linear equations - sets up the equations above
3. Sets the parameters for the equation - chooses `g=2` `n=101`. N will typically be a large prime number
4. encrypting solutions calulates x_ecrypted and y_encrypted
* Raises to the power of x/y the result to modulo
  
### Assignment 5: 

* Compute 53/192 + 61/511 (mod 1033) in python.

* Extended Elucian Algorithm
   * largest number that can divide 2 integers with out a remainder
   * Bezcut coeffients `ax + by = gcd(a,b)`

* finds modular inverse of an int

**Code Explanation**

1. Computes modular inverse of a which is x
2. Extends Elican Algorithm
3. Calculating modular inverse if denominators (den1/2)
4. Computes teh sum of fractuins num1/nden + num2 / num2
5. Output is the sum if fractions and modulus prime

# Implement ECDSA from scratch

### 1) pick a private key

* The private key is simply a randomly chosen number from the range [1,n−1], where n is the order of the curve.
* The order of the curve is the number of points on the curve.
  `n = ecdsa.SECP256k1.order`
  
* The private key is a secret number that only the owner knows. Generated like this:
     `private_key = ecdsa.util.randrange(n) print(f"Private Key: {private_key}")`
  

2) generate the public key using that private key (not the eth address, the public key)

*  The public key is generated by performing elliptic curve point multiplication: 
* PublicKey = PrivateKey × G, where G is the base point of the curve.
  `G = ecdsa.SECP256k1.generator`
  `public_key = private_key * G`

3) pick message m and hash it to produce h (h can be though of as a 256 bit number

* Choose a message  m, hash it using SHA-256, and treat the hash as a 256-bit number h.
  
   `m = "This is a test message."
   h = hashlib.sha256(m.encode()).hexdigest()`

   m.encode(): This part of the code takes the string m, which represents your message, and encodes it into bytes. The .encode() method converts the string into a bytes object, which is necessary because the hashing function requires a sequence of bytes as input. By default, .encode() uses UTF-8 encoding.
   
   hashlib.sha256(): This function creates a new SHA-256 hash object. SHA-256 is part of the SHA-2 (Secure Hash Algorithm 2) family of cryptographic hash functions designed by the National Security Agency (NSA). A hash function maps data of arbitrary size (in this case, your encoded message) to a fixed size (256 bits for SHA-256). The output of a hash function, often called the hash value or hash code, appears random and changes significantly with even small alterations to the input data. This property makes it ideal for various security applications, such as digital signatures and data integrity verification. The hashlib.sha256() function takes the encoded bytes of the message as input.
   
   .update(): (While not explicitly shown in your line of code, this method would be used if you were hashing data in chunks.) The .update() method can be called on the hash object to feed the data into the object. It's particularly useful when dealing with large data sets or streaming data.
   
   .hexdigest(): This method is called on the hash object returned by hashlib.sha256(). It computes the hash value of the input data (the encoded message) and returns the hash as a string of hexadecimal digits. This hexadecimal representation is a convenient way to work with and display the 256-bit hash value, which is otherwise a sequence of bytes.

   `h_int = int(h, 16)`

   int(h, 16): This is a call to Python's built-in int function, which converts strings or numbers in various bases to an integer. The first argument is the string to be converted, and the second argument is the base of the number system of the string. In this case, 16 specifies that the string h is in base 16, or hexadecimal. The function parses the hexadecimal string and returns its value as a base-10 (decimal) integer.


4) sign m using your private key and a randomly chosen nonce k. produce (r, s, h, PubKey)

   1. Choose a random number (nonce) k from the range [1,n−1].
   2. Compute the point P = k × G. The x-coordinate of P is the r value. R = P.x mod n.
     If R = 0, go back to step 1.
   3. Compute the s value. s = (k^−1) * (h + r * private_key) mod n.


    ```python
    while True:
    k = ecdsa.util.randrange(n)
    P = k * G
    r = P.x() % n
    if r == 0:
        continue
    try:
        s = ecdsa.numbertheory.inverse_mod(k, n) * (h_int + r * private_key) % n
        if s == 0:
            continue
        break
    except Exception as e:
        continue

   print(f"Signature: (r: {r}, s: {s})")```

This block of code is part of an ECDSA (Elliptic Curve Digital Signature Algorithm) signing process. It generates a digital signature for a hash value (h_int) using a private key and specific parameters of the elliptic curve secp256k1. Let's break down this process step by step:

`while True:`
This creates an infinite loop. It's used here because the process of generating a signature involves picking a random nonce k that must meet certain conditions. If those conditions are not met, the loop tries again with a new k.

`k = ecdsa.util.randrange(n)`
A random integer k is selected from the range [1, n-1], where n is the order of the curve. This nonce k is crucial for the security of the ECDSA signature and must be kept secret and used only once.

`P = k * G`
The point P on the elliptic curve is calculated by multiplying the base point G of the curve by the nonce k. This operation is known as point multiplication, an essential operation in elliptic curve cryptography.

`r = P.x() % n`
The x coordinate of point P is taken and then reduced modulo n to get r, one part of the signature. If r happens to be 0, the algorithm must choose a new k and try again, as r = 0 is not a valid outcome for a signature.

`if r == 0: continue`
This checks if r is 0. If so, it continues the loop to pick a new k and calculate a new r, because r must not be 0 in a valid ECDSA signature.

`try: ... except Exception as e: continue`
A try block is used to attempt the calculation of s, the second part of the signature. If any error occurs (which could happen if, for example, calculating the modular inverse fails), the loop will catch the exception and continue by trying a new k.

`s = ecdsa.numbertheory.inverse_mod(k, n) * (h_int + r * private_key) % n`
This line calculates s, the second component of the signature. It first computes the modular inverse of k modulo n. This inverse is then multiplied by the sum of the hash of the message h_int and the product of r and the signer's private key. The result is then reduced modulo n. If s results in 0, a new k is chosen, as s must also not be 0.

`if s == 0: continue`
* Checks if s is 0. If so, it skips the rest of the loop and starts over with a new k, since s = 0 is not allowed.
break
* If r and s are both non-zero and valid, the loop breaks, ending the signature generation process.

`print(f"Signature: (r: {r}, s: {s})")`
Finally, the signature components r and s are printed. Together, (r, s) constitute the ECDSA signature for the hashed message h_int.
This process ensures the generation of a valid ECDSA signature, conforming to the requirements of the elliptic curve digital signature algorithm. It's essential for k to be chosen securely and randomly for each signature to maintain the security of the signed message.

5) verify (r, s, h, PubKey) is valid
* - (r,s) with the public key, hash of the message h, and the public key PubKey, check if:
* 1. Calculate u.1 =  h * s^−1 mod n and u.2 = r * s^−1 mod n.
* 2. Compute the point P = u.1 * G + u.2 * PubKey.
* 3. The signature is valid if P.x mod n = r.
* If P is the point at infinity, the signature is invalid.

   ```python
   u1 = (h_int * ecdsa.numbertheory.inverse_mod(s, n)) % n
   u2 = (r * ecdsa.numbertheory.inverse_mod(s, n)) % n
   P = u1 * G + u2 * public_key
   
   if P.x() % n == r:
       print("Signature is valid.")
   else:
       print("Signature is invalid.")
   ```

The code is part of ECDSA (Elliptic Curve Digital Signature Algorithm) verification process. It takes a signature(r,s), a public key, and the hash of a message 
ℎ int and determines whether the signature is valid.

### Calculation of u1 and u2

*`u1 = (h_{\text{int}} * \text{inverse\_mod}(s, n)) \% n: This calculates u1 which is the product of the message hash ℎint and the modular inverse of 
s modulo n, all reduced modulo n. The modular inverse of s is a number such that 
s⋅s −1 ≡ 1modn.u1 essentially represents a factor that will scale the base point G in the verification process.

* u2 = (r * \text{inverse\_mod}(s, n)) \% n: Similarly, this calculates u2, which is the product of r (part of the signature) and the modular inverse of 
s modulo n, reduced modulo n.u.2 will scale the public key during verification.

### Point Calculation: P

P = u1 * G + u2 * public_key: This line calculates a point P on the elliptic curve by performing two point multiplications and then adding the results. 
u.1 × G scales the base point of the curve by u.1 and u.2 × public_key scales the signer's public key by u.2. The resulting points are then added together to produce a new point P.

### Verification Condition

if P.x() % n == r: his line checks whether the x-coordinate of P when reduced modulo n, equals r. According to the ECDSA verification algorithm, if this condition is true, the signature (r,s) is valid for the given message hash and public key. This step effectively confirms that the signer, who possesses the corresponding private key, has indeed signed the message.

### Outcome
print("Signature is valid."): If the condition is met, the program prints that the signature is valid, indicating that the verification process has succeeded and the signature is authentic and untampered.

else: print("Signature is invalid."): If the condition is not met, the program prints that the signature is invalid, indicating either that the signature does not match the message and public key or that the signature has been tampered with.
 


 l