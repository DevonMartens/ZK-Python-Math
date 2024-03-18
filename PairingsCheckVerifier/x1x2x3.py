from py_ecc import bn128
import random

def generate_valid_point_and_scalars():
    # Generate a random scalar
    scalar = random.randint(1, bn128.curve_order - 1)

    # Compute a point on G1 using the scalar
    point_on_g1 = bn128.multiply(bn128.G1, scalar)

    # Assume x1, x2, and x3 are factors of the scalar used
    x1 = scalar // 3
    x2 = scalar // 3
    x3 = scalar - x1 - x2

    # Verify the computation (for demonstration)
    computed_point = bn128.add(
        bn128.multiply(bn128.G1, x1),
        bn128.add(
            bn128.multiply(bn128.G1, x2),
            bn128.multiply(bn128.G1, x3),
        ),
    )

    assert computed_point == point_on_g1, "Mismatch in computed point and expected point"
    
    # Prepare values for Solidity
    A1 = [point_on_g1[0], point_on_g1[1]]
    return A1, x1, x2, x3

A1, x1, x2, x3 = generate_valid_point_and_scalars()
print("A1:", A1)
print("x1:", x1)
print("x2:", x2)
print("x3:", x3)
