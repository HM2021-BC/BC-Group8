// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.0;

// this contract allows supply chain parties to track shipment of products 
contract Logistics {
    
    address Owner;
    
    ////////// DEFENTION //////////
    
    struct Shipment {
        // order data
        address order_id;
        
        // shipment data
        string shippment_status;
        string current_location;
        string delivery_location;
        uint shipment_date;
        
        address reciever; 
        address customer;
        
    }
    
     
    constructor() public{
        Owner = msg.sender;
    }
    
     ////////// MODIFIERS //////////
     
    modifier onlyOwner() {
        require(Owner == msg.sender, 
        "Permission denied! This function is restricted to the contracts' owner.");
        _;
    }
    
    ////////// MAPPING PART //////////
    
    mapping(address => Shipment) shippmentMapping;
    
    
    ////////// EVENTS //////////
    event SendShipment(address _order_id, string _current_location, string _delivery_location,  address _reciever);
    
    
    ////////// FUNCTIONS //////////
    function sendShipment(address _order_id, string memory _current_location, string memory _delivery_location,  address _reciever) public returns(address) {
        address shipment_id = address(uint160(uint(sha256(abi.encodePacked(msg.sender, block.timestamp)))));
        
        shippmentMapping[shipment_id].order_id = _order_id;
        
        shippmentMapping[shipment_id].shippment_status = "On Hold";
        shippmentMapping[shipment_id].current_location = _current_location;
        shippmentMapping[shipment_id].delivery_location = _delivery_location;
        
        shippmentMapping[shipment_id].shipment_date = block.timestamp;
        shippmentMapping[shipment_id].reciever = _reciever;
        shippmentMapping[shipment_id].customer = msg.sender;
        
        return shipment_id;
    }
    
    // updates the locations of the shipment with the given id
    function updateLocation(address shippment_id, string memory _location) public onlyOwner returns(bool) {
        shippmentMapping[shippment_id].current_location = _location;
        return true;
    } 
    
    // updates the status of the shipment wit hthe given id
    function updateStatus(address shippment_id, string memory _status) public onlyOwner returns(bool) {
        shippmentMapping[shippment_id].shippment_status = _status;
        return true;
    } 
    
    // returns the status of the shippment with given id
    function getStatus(address shippment_id) public view returns(string memory) {
        return shippmentMapping[shippment_id].shippment_status;
    }
    
    // returns the current location of the shipment with the given id
    function getCurrentLocation(address shippment_id) public view returns(string memory) {
        return shippmentMapping[shippment_id].current_location;
    }
    
    
}