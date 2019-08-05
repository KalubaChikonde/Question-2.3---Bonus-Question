pragma solidity >=0.4.17 <0.6.0;

import "./CoToken.sol";

contract CoUpdate {

       //define struct Shoe that represents a shoe
    struct Shoe {
        address payable owner;  //the address of owner of the shoe
        string name;
        string image;
        bool sold;

    }

    uint256 ShoesSold = 0;   
    uint256 supply = 100;
    Shoe[] public shoes; //initialise array
     CoToken token;
     address public Tokenowner;

      constructor(address _address) public {
        //mint 100 shoes
        for (uint i=1;i<=supply;i++) {
        //add each shoe to array
        shoes.push(Shoe(msg.sender,"","",false)); 
    
        }
        token  = CoToken(_address);

    }

     //gets number of shoes in shoes array
    function getNumberOfShoes() public view returns(uint) {
        return shoes.length;
    }
     

      // function  to buy a shoe gievn name and image
    function buyShoe(string memory _name,string memory _image)public payable returns(uint) {
       require(token.balanceOf(msg.sender) > 0, 'Price is not sufficient'); 
        require(ShoesSold <= supply,'Sorry! All shoes are sold out!'); //check that there is still pair of shoes left has not been sold


         //assign CoToken owner
         Tokenowner = token.owner();
         //transfer ownership
         require(token.transferFrom(msg.sender,Tokenowner,1),"There was a problem with Tranfer");
        
        uint256 soldShoe = ShoesSold+1; //sell shoe that
         require(shoes[soldShoe].sold == false, "That shoe has alraedy been purchased");
        shoes[soldShoe].owner = msg.sender;
        shoes[soldShoe].name = _name;
        shoes[soldShoe].image = _image;
        shoes[soldShoe].sold = true;
        ShoesSold = ShoesSold + 1 ;  //update shoes sold
        return ShoesSold;
    }
    

      //function to return an array of bools of an array of all the purchases that are true
    function checkPurchases() external view returns (bool[] memory){
        bool[] memory Buy;
        for (uint256 i = 0; i < shoes.length; i++){
            if (shoes[i].owner == msg.sender){
                    Buy[i] = true;
            }
        }
        return Buy;
    }


}