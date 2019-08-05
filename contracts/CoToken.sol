pragma solidity >=0.4.17 <0.6.0;

//
//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
   //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

//import "installed_contracts/zeppelin/contracts/math/Ownable.sol";



contract CoToken is Ownable,ERC20 {
   
      uint public totalSupply_ = 0;
      uint public buyPrice_;
      uint public sellPrice_;
    
      
    

    function buyPrice(uint256 _tokens) public returns(uint) {
        //1 Ether is 1^18 = 1000000000000000000 Wei.
       uint upperBound = totalSupply_ + _tokens;
           buyPrice_ = ((5*(10**15))*(upperBound)*(upperBound)) + ((2*10**17)*(upperBound)) - poolBalance(); //integral function
      
       return buyPrice_;
    }

      //total ether held by bonding curve
    function poolBalance() public view returns(uint) {
      
      uint poolBalance_ = ((5*(10**15))*(totalSupply_)*(totalSupply_)) + ((2*10**17)*(totalSupply_));
        return poolBalance_;
    }

    function sellPrice(uint256 _tokens) public returns(uint) {
        //1 Ether is 1^18 = 1000000000000000000 Wei.
        uint upperBound = totalSupply_ - _tokens;
               sellPrice_ =  poolBalance() -  ((5*(10**15))*(upperBound)*(upperBound)) - ((2*10**17)*(upperBound)) ;
       return sellPrice_;
    }

    //mint tokens 
    function mint(uint _amount) public payable {
        require(msg.value >= buyPrice(_amount), "You have insufficient funds");  //checks if there are sufficient funds
        _mint(msg.sender,_amount); //mint tokens
         totalSupply_ = totalSupply_ + _amount; //update total supply
          //poolBalance();

    }
      
      //function to burn tokens 
    function burn(uint _amount) onlyOwner public payable {
        //CHECK that there are enough funds to burn
         require(poolBalance() >= sellPrice(_amount),"You have insufficient funds");
         _burn(msg.sender,_amount);
          totalSupply_ =  totalSupply_ - _amount; //decrease total supply
          //poolBalance();
        
    }
     
     //destroys contract 
    function destroy() public onlyOwner { //onlyOwner is custom modifier
        selfdestruct(msg.sender);

    }
}
