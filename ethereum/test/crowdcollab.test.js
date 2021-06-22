const CampaignCreator = artifacts.require("./CampaignCreator.sol");
const CrowdCollab = artifacts.require("./CrowdCollab.sol");


let campaignCreator;
let campaignAddress;
let campaign;

before(async () => {
	campaignCreator = await CampaignCreator.new()
    
	var minContribution = '1000000000000';
	var description = 'test CrowdCollab dApp';
	await campaignCreator.createCampaign(minContribution, description);
   	 
	campaignAddress = await campaignCreator.getDeployedCampaigns.call();
    
	campaign = await CrowdCollab.at(campaignAddress[0]);
});

contract("CrowdCollab test", (accounts) => {
	it('campaign has an address', async () => {
    	assert.ok(campaignAddress);
	});
    
	it('campaign has minimumContribution', async () => {
    	minimumContribution = await campaign.minimumContribution.call(); 	 
    	assert.ok(minimumContribution);
	});
    
	it('has a manager', async () => {
		var managerAddress = await campaign.manager.call();
    	assert.equal(managerAddress, accounts[0]);
	});
    
	it('has a description', async () => {
    	var description = await campaign.campaignDescription.call();
    	assert.equal(description, 'test CrowdCollab dApp');
	});
    
	it('allows supporters with minimum contribution', async () => {
    	var newSupporter = accounts[1];
    	var newContribution = '1000000000001';
    	await campaign.support({from: newSupporter, value: newContribution});
    	var isSupporter = await campaign.supporters.call(newSupporter);
   	 
    	assert.ok(isSupporter);
	});
    
	it('allows multiple supporters to join the campaign', async () => {
    	var contribution = '1000000000001';
    	for (var i=2; i < 6; i++) {
        	await campaign.support({from: accounts[i], value: contribution});
    	};
    	var numberSupporters = await campaign.numberSupporters.call();

        assert.equal(numberSupporters, '5');
    });
   
	it('restricts supporters without minimum contribution', async () => {
    	var nonSupporter = accounts[6];
    	var newContribution = '1000000000000';
    	try {
        	await campaign.support({from: nonSupporter, value: newContribution});
    	} catch (error) {
        	assert(error);
    	}
    	var isSupporter = await campaign.supporters.call(nonSupporter);
    	assert.ok(!isSupporter);
	});
   

	it('allows creation of a request by manager', async () => {
    	var description = 'Hire design team';
    	var amount = '1000000000';
    	var recipient = accounts[9];
   	 
    	await campaign.createRequest(description, amount, recipient,
                            	{ from: accounts[0] });             	 
    	var request = await campaign.requests.call(0);

    	assert(request);
	});
    
	it('restricts creation of request if not manager', async () => {
    	var description = 'IceCream for manager';
    	var amount = '1000000000';
    	var recipient = accounts[9];
   	 
    	try {
        	await campaign.createRequest(description, amount, recipient,
                            	{ from: accounts[1] });
        	assert(false);
    	} catch (error) {
        	assert(error);
    	}
	});
    
	it('allows supporter to vote', async () => {
    	var supporter = accounts[1];
   	 
    	await campaign.approveRequest(0, {from: supporter});
    	var request = await campaign.requests.call(0);
   	 
    	assert.equal(request[4].toNumber(), 1);
	});
    it('restricts supporters from double voting', async () => {
    	var supporter = accounts[1];
   	 
    	try {
        	await campaign.approveRequest(0, {from: supporter});
    	}catch (error) {
        	assert(error);
    	}
           	 
    	var request = await campaign.requests.call(0);
    	assert.equal(request[4].toNumber(), 1);
	});
    
	it('restricts manager to finalize request if not absolute majority ', async () => {
    	var manager = accounts[0];
    	try {
        	await campaign.finalizeRequest(0, {from: manager});
    	}catch (error) {
        	assert(error);
    	}  
   	 
    	var request = await campaign.requests.call(0);

    	assert(!request[3]);
	});   

    it('allows manager to finalize request if majority', async () => {
    for (var i=2; i < 4; i++) {
        await campaign.approveRequest(
            0, {from: accounts[i]} );
    };

    var manager = accounts[0];
    await campaign.finalizeRequest(
        0, {from: manager}
    );        
    var request = await campaign.requests.call(0);
    var requestComplete = request[3];

    assert(requestComplete);
    });

    it('request recipient receives ether', async () => {
	
    var regularAccountBalance =  
	    await web3.eth.getBalance(accounts[8], function(err, result) {
			if (err) {
			  console.log(err)
			} else {
			  console.log('Regular balance: ' + result)
			}
		});
    var requestRecipientBalance = 
	    await web3.eth.getBalance(accounts[9], function(err, result) {
			if (err) {
			  console.log(err)
			} else {
			  console.log('Request recipient balance: ' + result)
			}
		});
    var request = await campaign.requests.call(0);
	var amountToReceive = request[1].toNumber();
	console.log('Ammount to receive: ' + amountToReceive)
    assert.equal(
        amountToReceive + parseInt(regularAccountBalance), parseInt(requestRecipientBalance))
    });
})

