pragma solidity 0.8.6;


contract Campaign {
    
    struct Request {
        string description;
        uint256 value;
        address payable recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint256 approvalsCount;
    }    
    
    mapping(uint256 => Request) public requests;
    address public manager;
    uint public minimumContribution;
    mapping (address => bool) public approvers;
    uint256 approversCount;
    uint256 requestIndex;
    uint256 requestsCount;
    
    constructor(uint256 minimum_, address manager_)  {
        manager = manager_;
        minimumContribution = minimum_;
    }
    
    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }
    
    function createRequest(string memory description_, uint256 value_, address payable recipient_) public onlyManager {
        Request storage newRequest = requests[requestIndex];
        newRequest.description = description_;
        newRequest.value = value_;
        newRequest.recipient = recipient_;
        newRequest.approvalsCount = 0;
        requestIndex++;
        requestsCount++;
    
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution, 'Your contribution must be higher than minimum');
        
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function approveRequest(uint256 index_) public {
        Request storage request = requests[index_];
        require(!request.complete, 'Request is already completed');
        require(!request.approvals[msg.sender], 'You have already voted on this request');
        
        request.approvals[msg.sender] = true;
        request.approvalsCount++;
    }
    
    function finilizeRequest(uint256 index_) public onlyManager {
        Request storage request = requests[index_];
        require(!request.complete, 'Request is already completed');
        require(request.approvalsCount > approversCount / 2, 'There are not enough votes');
        request.complete = true;
        
        request.recipient.transfer(request.value);
        
    }
}