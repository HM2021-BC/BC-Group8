// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.0;

// this contract allows supply chain parties to track shipment of products 
contract Logistics {
    
    address owner;
    uint paymentValue;
    
    ////////// DEFENTION //////////
    
    struct Shipment {
        // product data
        address product_id;   
        uint quantity;
        // shipment data
        string shipment_status;
        string current_location;
        string delivery_location;
        uint shipment_date;
        
        address sender; 
    }
    
     
    constructor() public{
        owner = msg.sender;
    }
    
     ////////// MODIFIERS //////////
     
    modifier onlyOwner() {
        require(owner == msg.sender, 
        "Permission denied! This function is restricted to the contracts' owner.");
        _;
    }
    
    modifier onlyShippedShipment(address _shipment_id) {
         require(keccak256(abi.encodePacked((shipmentMapping[_shipment_id].shipment_status))) == 
         keccak256(abi.encodePacked(("Shipped"))), 
        "This shippment is not shipped yet.");
        _;
    }
    
    ////////// MAPPING PART //////////
    
    mapping(address => Shipment) shipmentMapping;
    
    
    ////////// EVENTS //////////
    event SendShipment(address _product_id, string _current_location, string _delivery_location, address _sender);
    event ReceiveShipment(address _shipment_id, address _sender);
    event DeleteShipment(address _shipment_id, address _sender);
    
    ////////// FUNCTIONS //////////
    
    // sends a shipment with the given details
    function sendShipment(
        address _product_id,
        uint _quantitiy,
        string memory _current_location, 
        string memory _delivery_location) 
        public returns(address) {
        address shipment_id = address(uint160(uint(sha256(abi.encodePacked(msg.sender, block.timestamp)))));
        
        shipmentMapping[shipment_id].product_id = _product_id;
        shipmentMapping[shipment_id].quantity = _quantitiy;
        shipmentMapping[shipment_id].shipment_status = "On Hold";
        shipmentMapping[shipment_id].current_location = _current_location;
        shipmentMapping[shipment_id].delivery_location = _delivery_location;
        
        shipmentMapping[shipment_id].shipment_date = block.timestamp;
        shipmentMapping[shipment_id].sender = msg.sender;
        
        emit SendShipment(_product_id, _current_location, _delivery_location, msg.sender);
        
        return shipment_id;
    }
    
    
    // displays the details of shipment: 
    // product id, quantity, shipment status, current location, delievery location, sender
    function getShipment(
        address _shipment_id) 
        public view returns 
        (address, uint, string memory, string memory, string  memory, address) {
            return (shipmentMapping[_shipment_id].product_id,
                shipmentMapping[_shipment_id].quantity, 
                shipmentMapping[_shipment_id].shipment_status,
                shipmentMapping[_shipment_id].current_location,
                shipmentMapping[_shipment_id].delivery_location,
                shipmentMapping[_shipment_id].sender);
        } 
    
    // recieves a shipment if the quantity and the deliviry location are correct
    function receiveShipment(
        address _shipment_id, 
        uint _quantity,
        string memory _location) 
        onlyShippedShipment(_shipment_id) 
        public returns(bool) {
            if(shipmentMapping[_shipment_id].quantity == _quantity && 
            sha256(bytes(shipmentMapping[_shipment_id].delivery_location)) 
            == sha256(bytes(_location))) {
                // change shippment status if true
                shipmentMapping[_shipment_id].shipment_status = "Recieved";
                emit ReceiveShipment(_shipment_id, msg.sender);
            }
            
            return true;
    }
    
    // deletes a shippment with the given shippment id
    function deleteShippment(
        address _shipment_id)
        public
        onlyOwner() 
        returns(bool){
            delete shipmentMapping[_shipment_id];
            emit DeleteShipment(_shipment_id, msg.sender);
            return true;
        }
    
    // updates the locations of the shipment with the given id
    function updateCurrentLocation(
        address shipment_id, 
        string memory _location) 
        public onlyOwner 
        returns(bool) {
            shipmentMapping[shipment_id].current_location = _location;
            return true;
    } 
    
    // updates the status of the shipment wit hthe given id
    function updateStatus(
        address _shipment_id, 
        string memory _status) 
        public onlyOwner() 
        returns(bool) {
            shipmentMapping[_shipment_id].shipment_status = _status;
            return true;
    } 
    
    // returns the status of the shippment with given id
    function getStatus(
        address shipment_id) 
        public view 
        returns(string memory) {
            return shipmentMapping[shipment_id].shipment_status;
    }
    
    // returns the current location of the shipment with the given id
    function getCurrentLocation(
        address _shipment_id) 
        public view 
        returns(string memory) {
            return shipmentMapping[_shipment_id].current_location;
    }
    
    // returns the payment value presented in tokens
    function getPaymentValue() 
    public view returns(uint) {
        return paymentValue;
    } 
    
    // sets number of tokens 
    function setPaymentValue(uint _value) 
    public onlyOwner returns(bool) {
        paymentValue = _value;
        return true;
    }
    
    // returns true if the shippment was received
    function isReadyToPay(address _shipment_id) 
    public view 
    onlyOwner 
    returns(bool) {
        if(sha256(bytes(shipmentMapping[_shipment_id].shipment_status)) ==
            sha256(bytes("Recieved")) &&
            shipmentMapping[_shipment_id].shipment_date < now) {
                return true;
            }
        return false;
    } 
    
}