pragma solidity ^0.5.0;
import "./Logistics.sol";

// this contract allows payment transaction for the recieved shipments 
contract Reciever{
    
    address payable owner;
    address[] recievedShipments;
    Logistics lsc;
    
    constructor(address _a) public {
        lsc = Logistics(_a);
        owner = msg.sender;
    } 
    
     
    modifier onlyOwner() {
        require(owner == msg.sender, 
        "Permission denied! This function is restricted to the contracts' owner.");
        _;
    }
    
    function pay(
        address _shippment_id, 
        address payable _to) 
        public onlyOwner returns(bool){
        if(lsc.isReadyToPay(_shippment_id)) {
            payValue(_to, lsc.getPaymentValue()); 
            return true;
        }
        return false;
    }
    
    function payValue(
        address payable _to, 
        uint _amount) 
        private returns (bool success){
           if(address(this).balance > _amount)  {
               _to.transfer(_amount);
                return true;
           }
        return false;
    }
}