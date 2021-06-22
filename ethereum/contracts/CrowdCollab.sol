pragma solidity ^0.5.0;

/**
 * @title Crowd fund smart contract, demonstration to solve problem of center crowd fund model
 * @author Duong Van Sang
 * @dev Crowd Colla is smart contract is contract that allow creators and entrepreneurs to get fund
 * from supporters for their project, and also let supporter join in approving their expense items
 */
contract CrowdCollab { 
    /**
     * Request expense detail information
     */
    struct Request {
        string description;
        uint amount;
        address payable recipient;
        bool complete;
        mapping(address=>bool) approvals;
        uint approvalCount; 
    }

    // address of manager, who manages campaign
     address public manager;

    // min contribution value in ETH
    uint public minimumContribution;

    // description about your campaign
    string public campaignDescription;

    // a mapping list of supporter address, to check if address is supporter or not
    mapping(address=>bool) public supporters;

    // current number of supporter of campaign, 
    // when any one contribute money for project, he/she will be come supporter
    uint public numberSupporters;

    // list of expense request for project
    Request[] public requests;

    modifier managerOnly() {
        require(msg.sender == manager);
        _;
    }

    modifier supporterOnly() {
        require(supporters[msg.sender]);
        _;
    }

    /**
     * @dev init campaign 
     * @param creator who is author and manage project
     * @param minContribution minimum money can contribute for project (in ETH)
     * @param description description of campaign, purpose of campaign
     */
    constructor(address creator, uint minContribution, string memory description) public {  
        manager = creator;
        minimumContribution = minContribution;
        campaignDescription = description;
    }

    /**
     * @dev payable of campaign, where supporter send Ethereum to contribute for campaign
     */
    function contribute() public payable {
        require(msg.value > minimumContribution);
        supporters[msg.sender] = true;
        numberSupporters++;
    }

    /**
     * @dev payable of campaign, where supporter send Ethereum to contribute for campaign
     */
    function support() public payable {
        contribute();
    }    

    /**
     * @dev Create a expense request, only manager of campaign are able to do it
     * @param description expense purpose
     * @param amount total money need for expense items
     * @param recipient who, which address will reiceive money when request is approved
     */
    function createRequest(string memory description, uint amount, address payable recipient) 
        public managerOnly {
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
     * @dev Approve expense request from manager, apply for supporter only
     * @param requestId expense request id
     */
    function approveRequest(uint requestId) public supporterOnly {
        Request storage request = requests[requestId];   
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount ++;
    }  

    /**
     * @dev finalize expense request and transfer money to receiver
     * @param requestId expense request id
     */
    function finalizeRequest(uint requestId) public managerOnly {
        Request storage request = requests[requestId];
        require(!request.complete);    
        require(request.approvalCount > (numberSupporters/2));
        request.recipient.transfer(request.amount);
        request.complete = true;
    } 

    /**
     * @dev get summary information about campaign
     */
    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          minimumContribution,
          address(this).balance,
          requests.length,
          numberSupporters,
          manager
        );
    }

    /**
     * @dev get request number
     */
    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}
