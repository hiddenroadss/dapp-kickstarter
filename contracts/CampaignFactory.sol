pragma solidity 0.8.6;

import './Campaign.sol';

contract CampaignFactory {
    address[]  campaigns;
    
    function getCampaigns() public view returns(address[] memory) {
        return campaigns;
    }
    
    function createCampaign(uint256 minimum_) public {
        Campaign newCampaign = new Campaign(minimum_, msg.sender);
        address campaignAddress = address(newCampaign);
        campaigns.push(campaignAddress);
    }
}
