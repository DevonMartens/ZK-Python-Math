import numpy as np

def hadamard_product(vec1, vec2):
    """Computes the Hadamard (element-wise) product of two vectors."""
    return np.multiply(vec1, vec2)

def matrix_vector_multiply(matrix, vector):
    """Multiplies a matrix by a vector."""
    return np.dot(matrix, vector)

def verify_r1cs(A, B, C, w):
    """Verifies the R1CS condition Aw ⊙ Bw - Cw = 0."""
    Aw = matrix_vector_multiply(A, w)
    Bw = matrix_vector_multiply(B, w)
    Cw = matrix_vector_multiply(C, w)

    result = hadamard_product(Aw, Bw) - Cw
    
    # Check if the result is a zero vector (all elements are 0)
    return np.allclose(result, np.zeros(result.shape))

# Example usage:
A = [[1, 2], [3, 4]]
B = [[5, 6], [7, 8]]
C = [[9, 12], [15, 20]]
w = [2, 3]

verification_result = verify_r1cs(A, B, C, w)
print("Verification result:", verification_result)
