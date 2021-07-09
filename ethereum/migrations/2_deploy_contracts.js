var ProductOrigin = artifacts.require("./ProductOrigin.sol");
var Logistics = artifacts.require("./Logistics.sol");
var Reciever = artifacts.require("./Reciever.sol");

module.exports = function(deployer) {
  deployer.deploy(ProductOrigin);
  deployer.deploy(Logistics);
  deployer.deploy(Logistics).then(function() {
    return deployer.deploy(Reciever, Logistics.address);
  })
};
