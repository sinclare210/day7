// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/SimpleIOU.sol";

contract SimpleIOUTest is Test {
    SimpleIOU public iou;

    function setUp() public {
        iou = new SimpleIOU();
    }

    // Deployment
    function testOwnerIsRegisteredOnDeploy() public {}

    // Friend Management
    function testAddFriendByOwner() public {}
    function testAddFriendFailsIfAlreadyRegistered() public {}
    function testAddFriendFailsIfNotOwner() public {}
    function testAddFriendFailsIfAddressIsZero() public {}

    // Deposits
    function testDepositIntoWalletSucceedsForRegisteredUser() public {}
    function testDepositFailsIfNotRegistered() public {}
    function testDepositFailsWithZeroAmount() public {}

    // Debts
    function testRecordDebtByOwnerToDebtor() public {}
    function testRecordDebtFailsIfNotOwner() public {}
    function testRecordDebtFailsIfDebtorNotRegistered() public {}
    function testRecordDebtFailsIfAmountZero() public {}

    // Payments
    function testPayFromWalletReducesDebtAndBalanceCorrectly() public {}
    function testPayFromWalletFailsIfCreditorNotRegistered() public {}
    function testPayFromWalletFailsIfAmountZero() public {}
    function testPayFromWalletFailsIfDebtTooLow() public {}
    function testPayFromWalletFailsIfInsufficientBalance() public {}

    // Ether Transfer
    function testTransferEtherToFriendSuccess() public {}
    function testTransferEtherFailsIfRecipientNotRegistered() public {}
    function testTransferEtherFailsIfInsufficientBalance() public {}
    function testTransferEtherFailsIfAmountZero() public {}

    // Withdrawals
    function testWithdrawSuccess() public {}
    function testWithdrawFailsIfAmountZero() public {}
    function testWithdrawFailsIfInsufficientBalance() public {}

    // View
    function testCheckBalanceReturnsCorrectAmountForUser() public {}
    function testCheckBalanceFailsIfNotRegistered() public {}
}

