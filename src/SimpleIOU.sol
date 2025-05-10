// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleIOU {
    address public owner;

    mapping(address => bool) public registeredFriends;
    address[] public friendList;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public debts;

    // --- Custom Errors ---
    error NotOwner();
    error NotRegistered();
    error AlreadyRegistered();
    error InvalidAddress();
    error AmountZero();
    error NotEnoughBalance();
    error DebtTooLow();
    error TransferFailed();

    constructor() {
        owner = msg.sender;
        registeredFriends[msg.sender] = true;
        friendList.push(msg.sender);
    }

    // --- Modifiers ---
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlyRegistered() {
        if (!registeredFriends[msg.sender]) revert NotRegistered();
        _;
    }

    // --- Core Functions ---

    function addFriend(address _friend) public onlyOwner {
        if (_friend == address(0)) revert InvalidAddress();
        if (registeredFriends[_friend]) revert AlreadyRegistered();

        registeredFriends[_friend] = true;
        friendList.push(_friend);
    }

    function depositIntoWallet() public payable onlyRegistered {
        if (msg.value == 0) revert AmountZero();
        balances[msg.sender] += msg.value;
    }

    function recordDebt(address _debtor, uint256 _amount) public onlyRegistered onlyOwner {
        if (_debtor == address(0)) revert InvalidAddress();
        if (!registeredFriends[_debtor]) revert NotRegistered();
        if (_amount == 0) revert AmountZero();

        debts[_debtor][msg.sender] += _amount;
    }

    function payFromWallet(address _creditor, uint256 _amount) public onlyRegistered {
        if (_creditor == address(0)) revert InvalidAddress();
        if (!registeredFriends[_creditor]) revert NotRegistered();
        if (_amount == 0) revert AmountZero();
        if (debts[msg.sender][_creditor] < _amount) revert DebtTooLow();
        if (balances[msg.sender] < _amount) revert NotEnoughBalance();

        balances[msg.sender] -= _amount;
        balances[_creditor] += _amount;
        debts[msg.sender][_creditor] -= _amount;
    }

    function transferEther(address payable _to, uint256 _amount) public onlyRegistered {
        if (_to == address(0)) revert InvalidAddress();
        if (!registeredFriends[_to]) revert NotRegistered();
        if (_amount == 0) revert AmountZero();
        if (balances[msg.sender] < _amount) revert NotEnoughBalance();

        balances[msg.sender] -= _amount;
        (bool success, ) = _to.call{value: _amount}("");
        if (!success) revert TransferFailed();
    }

    function withdraw(uint256 _amount) public onlyRegistered {
        if (_amount == 0) revert AmountZero();
        if (balances[msg.sender] < _amount) revert NotEnoughBalance();

        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        if (!success) revert TransferFailed();
    }

    function checkBalance() public view onlyRegistered returns (uint256) {
        return balances[msg.sender];
    }
}
