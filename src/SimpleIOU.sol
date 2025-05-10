// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleIOU{

    address public owner;

    mapping (address => bool) public registerdFriends;
    address[] public friendList;
    mapping(address => uint256)public balances;



}