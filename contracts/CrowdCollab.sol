pragma solidity ^0.5.0;

/**
 * Represents a Kickstarter campaign
 */
contract CrowdCollab {

    //address of manager who manages campaign
    address public manager;

    //min contribution value in ETH
    uint public minimumContribution;

    //description about your campaign
    string public campaignDescription;

    //a mapping list of supporter address, to check if address is supporter or not
    //only addresses valid in the ethereum protocol. if a new supporter is added, set to true
    mapping(address => bool) public supporters;

    //current number of supporter in campaign,
    //when any one contribute money for project, he/she will become supporter
    //we add +1 to numberSupporters with every new supporter
    uint public numberSupporters;

    /**
     * Expense detail information for a Request
     */
    struct Request {
        string description;    //description or purpose of request
        uint amount;    //requested amount to be spent
        address payable recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint approvalCount;
    }

    //list of every Request created in campaign by manager
    Request[] public requests;

    //Restrict functions to be triggered only by manager
    modifier managerOnly() {
        require(msg.sender == manager);
        _;
    }

    //Restrict functions to be triggered only by supporters
    modifier supporterOnly() {
        require(supporters[msg.sender]);
        _;
    }

    //init state variables
    constructor(address creator, uint minContribution, string memory description) public {
        manager = creator;
        minimumContribution = minContribution;
        campaignDescription = description;
    }

    /**
     * Payable of campaign, where supporter send ETH to contribute for campaign
     * this allows users to support the campaign if they send ETH higher than minimumContribution
     */
    function support() public payable {
        require(msg.value > minimumContribution);
        supporters[msg.sender] = true;
        numberSupporters++;
    }

    /**
     * 
     */
    function createRequest(string memory description, uint amount, address payable recipient) public managerOnly {
        Request memory newRequest = Request({
            description: description,
            amount: amount,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        requests.push(newRequest);
    }

    /**
     *
     */
    function approveRequest(uint requestId) public supporterOnly {
        Request storage request = requests[requestId];
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint requestId) public managerOnly {
        Request storage request = requests[requestId];
        require(!request.complete);
        require(request.approvalCount > (numberSupporters/2) );
        request.recipient.transfer(request.amount);
        request.complete = true;
    }
}