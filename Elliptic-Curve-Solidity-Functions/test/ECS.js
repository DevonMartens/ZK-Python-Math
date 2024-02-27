const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ECS contract", function () {
  let contract;
  beforeEach(async () => {
    const Contract = await ethers.getContractFactory("EllipticCurveSolidityContract");
    contract = await Contract.deploy();
    await contract.deployed();
  });

  describe("add function", function () {
    it("Should add two EC points correctly", async function () {
      // Assuming your curve is over a simple field and these points are valid
      const P = { x: 3, y: 10 }; // Example point 1
      const Q = { x: 9, y: 7 }; // Example point 2

      // Expected result of P + Q, assuming you've manually calculated this for your curve
      const expectedX = 17; // Placeholder value
      const expectedY = 20; // Placeholder value

      const R = await contract.add(P, Q);

      // Assert the expected result
      expect(R.x).to.equal(expectedX);
      expect(R.y).to.equal(expectedY);
    });

    it("Should fail for invalid EC points", async function () {
      // Assuming 0,0 is not a valid point on your curve
      const P = { x: 0, y: 0 };
      const Q = { x: 0, y: 0 };

      await expect(contract.add(P, Q)).to.be.revertedWith("ECAdditionFailed");
    });
  });

  describe("matmul function", function () {
    it("Should verify matrix multiplication correctly", async function () {
      // Example matrix and values for demonstration purposes
      const matrix = [1, 2, 3, 4]; // 2x2 matrix
      const n = 2; // matrix dimension
      const s = [{ x: 3, y: 10 }, { x: 9, y: 7 }]; // Example EC points array
      const o = [{ x: 17, y: 20 }, { x: 5, y: 22 }]; // Expected output EC points array

      const verified = await contract.matmul(matrix, n, s, o);
      expect(verified).to.be.true;
    });

    it("Should revert for invalid dimensions", async function () {
      const matrix = []; // Incorrect size
      const n = 1; // Mismatched dimension
      const s = []; // Empty arrays to trigger dimension validation
      const o = [];

      await expect(contract.matmul(matrix, n, s, o)).to.be.revertedWith("InvalidDimensions");
    });
  });

  describe("rationalAdd function", function () {
    it("Should verify rational addition correctly", async function () {
      // Placeholder values for A and B points
      const A = { x: 3, y: 10 }; // Example valid point
      const B = { x: 9, y: 7 }; // Another example valid point
      const num = 1; // Numerator
      const den = 2; // Denominator

      const verified = await contract.rationalAdd(A, B, num, den);
      expect(verified).to.be.true;
    });

    it("Should revert for zero denominator", async function () {
      const A = { x: 3, y: 10 }; // Example valid point
      const B = { x: 9, y: 7 }; // Another example valid point
      const num = 1;
      const den = 0; // Zero denominator to trigger error

      await expect(contract.rationalAdd(A, B, num, den)).to.be.revertedWith("InvalidDenominatorIsZero");
    });
  });
});
