// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./SubAccount";

contract CreateSubAccount {

    mapping (address EOA => address subAccount) subAccountLists;

    function createSubAccount(bytes32 salt) external {
        SubAccount subAccount = new SubAccount{salt: salt}(msg.sender);
        subAccountLists[msg.sender] = address(subAccount);
    }
}
