//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;


contract tokenVoting{

    address owner;
    uint256 private totalSupply;

    address[] contenders;

    string public name;
    string public symbol;
    uint public decimal = 1e18;

     address[] votePoll;
    //  bool voteStarting;
     mapping(address => bool) voteStarting;

    mapping(address => uint256) private balanceOf;
    mapping(address => uint8) private voteCount;
   // mapping(address => mapping(address => mapping(address => bool))) private vote;
    mapping(address => bool) private voted;


    event transfer_(address indexed from, address indexed to, uint amount);
    event registration(address indexed _cont1, address indexed _cont2, address indexed _cont3);
    event voteOrder(address indexed post1, address indexed postt2, address indexed post3);

    constructor(string memory _name, string memory _symbol, uint amount) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        mint(amount);
        
    }

    modifier onlyOwner() {
        msg.sender == owner;
        _;
    }
    
    function mint(uint amount) public {
        require(msg.sender == owner, "Access Denied");
        totalSupply += amount;
        balanceOf[owner] += amount;
    }

    function _totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function _balanceOf(address who) public view returns(uint256){
         return balanceOf[who];
    }

    function transfer(address _to, uint amount)public {
        _transfer(msg.sender, _to, amount);


    }

    function _transfer(address from, address to, uint amount) internal {
        require(balanceOf[from] >= amount, "insufficient token");
        require(to != address(0), "transferr to address(0)");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        emit transfer_(from, to, amount);
    }

    function _withdraw() public {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable{}
    fallback() external payable{}


////////////////////////////////////////////////////////////////////


    function registerContenders(address _cont1, address _cont2, address _cont3) public {
        require(msg.sender != _cont1 && msg.sender != _cont2 && msg.sender != _cont3, "Registered address can not be Admin");
        // balanceOf[msg.sender] -= 6;
        balanceOf[msg.sender] += 6;
         require(_cont1 != _cont2, "Address already registered");
         require(_cont2 != _cont3, "Address already registered");
         require(_cont1 != _cont3, "Address already registered");
         votePoll.push(_cont1);
         votePoll.push(_cont2);
         votePoll.push(_cont3);
         emit registration(_cont1, _cont2, _cont3);

    }


    function viewContenders() public view returns(address[] memory){
        return votePoll;
    }


    function startVote() public onlyOwner{
        voteStarting[msg.sender] = true;
    }

    function Voting(address post1, address post2, address post3) public {
        require(voteStarting[msg.sender] == true, "Poll not ready");
        require(voted[msg.sender] == false, "Already voted");
        require(balanceOf[msg.sender] > 0, "insufficient funds");


        balanceOf[msg.sender] -= 3;

        voteCount[post1] += 3;
        voteCount[post2] += 2;
        voteCount[post3] += 1;

        voted[msg.sender] = true;
        
        emit voteOrder(post1, post2, post3);
    }

    function endVote() public onlyOwner{
        voteStarting[msg.sender] = false;
    }


    function getAllVote(address _contender) public view returns(uint){
        require(voteStarting[msg.sender] == false, "Voting Ongoing");
        return voteCount[_contender];
        
    }
}