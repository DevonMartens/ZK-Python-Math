# Step 1: Pick a Private Key
# The private key is simply a randomly chosen number from the range [1,n−1], where n is the order of the curve.
# The order of the curve is the number of points on the curve. 
# The private key is a secret number that only the owner knows. In this example, we will use the private key
import os
import hashlib
import ecdsa

# secp256k1 curve parameters
n = ecdsa.SECP256k1.order

# Pick a random private key
private_key = ecdsa.util.randrange(n)
print(f"Private Key: {private_key}")

# Step 2: Generate the Public Key
# The public key is generated by performing elliptic curve point multiplication: 
# PublicKey = PrivateKey × G, where 
# G is the base point of the curve.
G = ecdsa.SECP256k1.generator
public_key = private_key * G
print(f"Public Key: ({public_key.x()}, {public_key.y()})")

# Step 3: Hash the Message
# Choose a message  m, hash it using SHA-256, and treat the hash as a 256-bit number h.
m = "This is a test message."
h = hashlib.sha256(m.encode()).hexdigest()
h_int = int(h, 16)
print(f"Hash of message (h): {h_int}")

# Step 4: Sign the Message
# @TODO
# 1. Choose a random number (nonce) k from the range [1,n−1].
# 2. Compute the point P = k × G. The x-coordinate of P is the r value. R = P.x mod n.
#  If R = 0, go back to step 1.
# 3. Compute the s value. s = (k^−1) * (h + r * private_key) mod n.
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

print(f"Signature: (r: {r}, s: {s})")

# Step 5: Verify the Signature
# @TODO - (r,s) with the public key, hash of the message h, and the public key PubKey, check if:
# 1. Calculate u.1 =  h * s^−1 mod n and u.2 = r * s^−1 mod n.
# 2. Compute the point P = u.1 * G + u.2 * PubKey.
# 3. The signature is valid if P.x mod n = r.
# If P is the point at infinity, the signature is invalid.
u1 = (h_int * ecdsa.numbertheory.inverse_mod(s, n)) % n
u2 = (r * ecdsa.numbertheory.inverse_mod(s, n)) % n
P = u1 * G + u2 * public_key

if P.x() % n == r:
    print("Signature is valid.")
else:
    print("Signature is invalid.")
