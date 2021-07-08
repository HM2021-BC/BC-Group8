var Reciever = artifacts.require("./Reciever.sol");

module.exports = function(deployer) {
  deployer.deploy(Reciever);
};
