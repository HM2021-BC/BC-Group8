pragma solidity ^0.5.0;
import './CrowdCollab.sol';

/**
 * Creates new instances of CrowdCollab contracts
 * Holds every campaign address of a deployment
 */
contract CampaignCreator {
    address[] public campaigns;

    /**
     *Creates instance of a CrowdCollab contract
     */
    function createCampaign(uint minContribution, string memory description) public {
        address newCampaign = address (new CrowdCollab(
            msg.sender,
            minContribution,
            description
        ));
        campaigns.push(newCampaign);
    }

    /**
     * Gets array of addresses (campaigns)
     */
    function getDeployedCampaigns() public view returns(address[] memory) {
        return campaigns;
    }
}