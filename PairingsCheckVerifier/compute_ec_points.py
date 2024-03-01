from py_ecc import bn128

# The base point G1 for alt_bn128 is implicitly (1, 2) in py_ecc's API
# We're using the base field G1 for these operations

def multiply_base_point(scalar):
    # Perform scalar multiplication on the curve
    return bn128.multiply(bn128.G1, scalar)

# Compute 5G1
alpha1 = multiply_base_point(5)
print(f"alpha1 (5G1): {alpha1}")

# For G2 (which involves points in a different group), you need to handle
# it differently, as py_ecc also offers support for operations in the G2 group.
# However, this example focuses on G1 for simplicity.

#
#alpha1 (5G1): (10744596414106452074759370245733544594153395043370666422502510773307029471145, 
# 848677436511517736191562425154572367705380862894644942948681172815252343932)