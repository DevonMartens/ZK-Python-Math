from py_ecc import bn128

# Function to perform scalar multiplication (similar to your contract's scalarMul)
def scalar_mul(x, y, scalar):
    point = (x, y)
    return bn128.multiply(point, scalar)

# Function to perform point addition (similar to your contract's add function)
def add_points(x1, y1, x2, y2):
    point1 = (x1, y1)
    point2 = (x2, y2)
    return bn128.add(point1, point2)

# Example usage to compute X1 = x1*G + x2*G + x3*G
def compute_x1_example(x1, x2, x3):
    G = bn128.G1  # Generator point
    x1G = scalar_mul(G[0], G[1], x1)
    x2G = scalar_mul(G[0], G[1], x2)
    x3G = scalar_mul(G[0], G[1], x3)

    # Add the points together
    temp = add_points(x1G[0], x1G[1], x2G[0], x2G[1])
    X1 = add_points(temp[0], temp[1], x3G[0], x3G[1])

    return X1

# Replace these with the values you're using in your tests
x1, x2, x3 = 1, 2, 3

# Calculate X1
X1 = compute_x1_example(x1, x2, x3)
print(f"Computed X1: {X1}")
