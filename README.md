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



