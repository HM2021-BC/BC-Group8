var OrderCreator = artifacts.require("./OrderCreator");
var Logistics = artifacts.require("./Logistics");

module.exports = function(deployer) {
  deployer.deploy(OrderCreator);
  deployer.deploy(Logistics);
};
