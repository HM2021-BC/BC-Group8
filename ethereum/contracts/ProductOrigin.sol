// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.0;

// this contract allows supply chain parties to check the provenance of products
contract ProductOrigin {
    
    ////////// DEFINITION SECTION //////////
    address owner;
    
    struct Producer {
        string name;
        uint phone;
        string city;
        string country;
    }
    
    struct Product {
        address producer;
        string name;
        string location;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    ////////// MODIFIERS SECTION //////////
     modifier onlyOwner() {
        require(owner == msg.sender, 
        "Permission denied! This function is restricted to the contracts' owner.");
        _;
    }
    
    
    modifier onlyNewProducer() {
         require(bytes(producers[msg.sender].name).length == 0,
         "The producer is already registred.");
        _;
    }
    
     modifier onlyRegistredProducer() {
         require(bytes(producers[msg.sender].name).length != 0,
         "The producer is not registred.");
        _;
    }
    
    modifier onlyRegistredProduct(address _product_id) {
        require(products[_product_id].producer != address(0), 
        "Product doesn't exist.");
        _;
    }
    
    modifier onlyNewProduct(address _product_id) {
        require(products[_product_id].producer == address(0),
        "Product already exists.");
        _;
    }
    
    ////////// MAPPING SECTION//////////
    mapping(address => Producer) producers;
    mapping(address => Product) products;
    
    
    ////////// FUNCTIONs SECTION //////////
    // adds a new producer with given details
    function addProducer(
        string memory _name, 
        uint _phone, 
        string memory _city, 
        string memory _country)
        onlyNewProducer()
        public returns (bool) {
            producers[msg.sender].name = _name;
            producers[msg.sender].phone = _phone;
            producers[msg.sender].city = _city;
            producers[msg.sender].country = _country;
            
        return true;
    }
    
    // removes the producer 
    function removeProducer(address _producer) 
    public onlyOwner() onlyRegistredProducer()
    returns(bool) {
        delete producers[_producer];
        return true;
    }
    
    // adds a product
    function addProduct(
        address _product_id,
        string memory _name, 
        string memory _location) 
        public
        onlyNewProduct(_product_id)
        returns(bool)  {
        products[_product_id].producer = msg.sender;  
        products[_product_id].name = _name;
        products[_product_id].location = _location;
        
        return true;
    }
    
    // removes a product
    function removeProduct(address _product_id) 
    public 
    onlyOwner 
    onlyNewProduct(_product_id) 
    returns(bool) {
        delete products[_product_id];
        return true;
    } 
    
    // function to display details of product
    function findProduct(address _product_id) 
    public view returns (
    address,
    string memory, 
    string memory) {
        return (products[_product_id].producer,
        products[_product_id].name, 
        products[_product_id] .location);
    }
    
    // generates a random id
    function generateProductId() public view returns(address) {
        address uuid = address(uint160(uint(sha256(abi.encodePacked(msg.sender, block.timestamp)))));
        return uuid;
    }
}