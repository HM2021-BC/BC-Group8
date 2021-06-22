var CampaignCreator = artifacts.require("./CampaignCreator");

module.exports = function(deployer) {
  deployer.deploy(CampaignCreator);
};
