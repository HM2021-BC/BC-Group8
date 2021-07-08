// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Reciever {
    address public owner = msg.sender;
    address[] recievedOrders;

    mapping (address => bool) public mappingRecievedOrders;


    modifier restricted() {
        require(
        msg.sender == owner,
        "This function is restricted to the contract's owner"
        );
        _;
    }

    function addRecievedShippment(address shippment_id) public restricted {
        mappingRecievedOrders[shippment_id]=true;
        recievedOrders.push(shippment_id);
    } 

    function isShippmentRecieved(address shippment_id) public view returns(bool) {
        return mappingRecievedOrders[shippment_id];
    }
}