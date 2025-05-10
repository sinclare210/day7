// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleIOU{

    address public owner;

    mapping (address => bool) public registerdFriends;
    address[] public friendList;
    mapping(address => uint256)public balances;
    mapping(address => mapping (address => uint256)) public debts;

    constructor (){
        owner = msg.sender;
        registerdFriends[msg.sender] = true;
        friendList.push(msg.sender);
    }

    modifier onlyOwner () {
        require(owner == msg.sender, "only the owner can call this function");
        _;
    }

    modifier onlyRegistered (){
        require(registerdFriends[msg.sender], "Not registered");
        _;
    }

    function addFriend (address _friend) public onlyOwner {
        require(_friend != address(0), "Not a valid address");
        require(!registerdFriends[_friend], "Registered");
         registerdFriends[_friend] = true;
        friendList.push(_friend);

    }

    function depositIntoWallet () public payable onlyRegistered {
        require (msg.value > 0, "Zero nt allowd");
        require(msg.sender != address(0), "Not a valid address");
        
        balances[msg.sender] += msg.value;
    }

    function recordDebt (address _debtor, uint256 _amount) public onlyRegistered onlyOwner {
        require (_amount > 0, "Zero nt allowd");
        require(_debtor != address(0), "Not a valid address");
        require(registerdFriends[_debtor], "Not registered");
        debts[_debtor][msg.sender] += _amount;
    }

    function payFromWallet (address _creditor, uint256 _amount) public onlyRegistered {
        require (_amount > 0, "Zero nt allowd");
        require(_creditor != address(0), "Not a valid address");
        require(!registerdFriends[_creditor], "Already registered");
        require(debts[msg.sender][_creditor] >= _amount, "debt amount incorrect");
        require(balances[msg.sender] >= _amount, "Insufficient funds");
        balances[msg.sender] -= _amount;
        balances[_creditor] += _amount;
    }


}