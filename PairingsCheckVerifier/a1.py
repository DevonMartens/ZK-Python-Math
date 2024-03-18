from py_ecc.bn128 import G1, multiply

# Scalars
x1 = 1
x2 = 2
x3 = 3

# Total scalar is the sum of x1, x2, and x3
total_scalar = x1 + x2 + x3

# Calculate A1 as 6 times the G1 (since x1 + x2 + x3 = 6)
A1 = multiply(G1, total_scalar)

print(f"A1: {A1}")
