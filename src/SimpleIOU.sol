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


}