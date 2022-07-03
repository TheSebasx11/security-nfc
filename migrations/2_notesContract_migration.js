const NotesContracts = artifacts.require("NotesContracts");


module.exports = function (deployer) {
    deployer.deploy(NotesContracts);
};