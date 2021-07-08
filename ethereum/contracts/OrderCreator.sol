// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract OrderCreator {
    
    address Owner;
    address[] public orders;
    
    ////////// DEFENTION //////////
    
    struct Order {
        
        // item data
        uint item_id;
        string item_name;
        uint quantity;
        
        // order data
        string order_status;
        string order_location;
        uint order_date;
        
        address reciever;
        
        bool initialized;
        
    }
    
    constructor() public {
        Owner = msg.sender;
    }
    
    ////////// MAPPING //////////
    
    mapping(address => Order) private orderMapping;
    
    
    ////////// EVENTS //////////
    
    event OrderCreate(uint _item_id, string _item_name, string _order_location, address _reciever);
    
    
    ////////// FUNCTIONS //////////
    
    // creates a new order
    function createOrder(
            uint _item_id, 
            string memory _item_name, 
            string memory _order_location, 
            uint _quantity, 
            address _reciever
        ) public returns(address) {
        address uuid = address(uint160(uint(sha256(abi.encodePacked(msg.sender, block.timestamp)))));
        
        orderMapping[uuid].item_id = _item_id;
        orderMapping[uuid].item_name = _item_name;
        
        orderMapping[uuid].order_status = "On Hold";
        orderMapping[uuid].order_location = _order_location;
        orderMapping[uuid].quantity = _quantity;
        orderMapping[uuid].order_date = block.timestamp;
        orderMapping[uuid].reciever = _reciever;
        
        orders.push(uuid);
        return uuid;
    }
    
     // returns a array of all order ids 
    function getOrderIDs() public view returns(address[] memory) {
        return orders;
    } 
    
    // returns the status of the order with the given uuid
    function getOrderStatus(address order_id) public view returns(string memory) {
        return orderMapping[order_id].order_status;
    } 
    
    // returns the location of the order with the given uuid
    function getOrderLocation(address order_id) public view returns(string memory) {
        return orderMapping[order_id].order_location;
    } 

    function getOrderDate(address order_id) public view returns(uint) {
        return orderMapping[order_id].order_date;
    }
    
    function getRecieverAddress(address order_id) public view returns(address) {
        return orderMapping[order_id].reciever;
    }

    function getNumberOfOrders() public view returns(uint) {
        return orders.length;
    }
    


}  