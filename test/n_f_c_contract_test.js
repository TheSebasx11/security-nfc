const NFCContractTest = artifacts.require("NFCContractTest");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("NFCContractTest", function (/* accounts */) {
  it("should assert true", async function () {
    await NFCContractTest.deployed();
    return assert.isTrue(true);
  });
});
