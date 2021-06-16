 pragma solidity 0.8.0;
import "./SafeMath.sol";

interface CBNsubmitRoute {
       function  addTransaction(address _from, address _to, uint _amount) external; 

    }

contract Bank {
    
    CBNsubmitRoute CBNcontract = CBNsubmitRoute(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    //event SKETCH
    event balanceAdded(uint amount, address depostedto);
   
    mapping(address => uint) balance;
   
    address owner; 
     constructor() {
         owner = msg.sender;
     }
     //(D) Modifier SKETCH
     modifier onlyOwner {
       require(msg.sender == owner, "this is not the owner");
       _; // it means run the code. 
     }       
    
    function deposit() public payable returns(uint){
   balance[msg.sender] += msg.value;  
    //event sktech
    emit balanceAdded(msg.value, msg.sender);
     return balance[msg.sender];
     
}  

function getBalance() public view returns(uint){
   return balance[msg.sender];
}

function withdraw(uint amount) public onlyOwner returns (uint){
 require(balance[msg.sender] >= amount, "Balancee not sufficient");
 balance[msg.sender] -= amount;
 payable(msg.sender).transfer(amount);
  return balance[msg.sender];
   }


// this function sends a specific amount from the sender to the receiver by reducig the sender's balance with an amount amd update the reciever's balance by adding the particular amount reduced from the sender's wallet to it.

function transfer(address recipient, uint amount) public {
    require(balance[msg.sender] >= amount, "balance not sufficient");
    require(msg.sender != recipient, " this is your wallet  you can't send to your self");
    // assert code implementation
   // balance[msg.sender] -= amount;
   // balance[recipient] += amount
   uint previousSenderBalance = balance[msg.sender];
    _transfer(msg.sender, recipient, amount);
      CBNcontract.addTransaction(msg.sender, recipient, amount);
     assert(balance[msg.sender] == previousSenderBalance - amount);
   

     //_transfer(msg.sender, recipient, amount);

}

function _transfer(address from, address to, uint amount) private {
balance[from] -= amount;
balance[to] += amount; 
//CBNcontract.addTransaction(msg.sender, recipient, amount);
}

}