const NFCContracts = artifacts.require("NFCContracts");


module.exports = function (deployer) {
    deployer.deploy(NFCContracts);
};