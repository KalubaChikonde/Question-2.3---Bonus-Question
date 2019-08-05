pragma solidity >=0.4.17 <0.6.0;


contract CoShoe {
    //define struct Shoe that represents a shoe
    struct Shoe {
        address payable owner;  //the address of owner of the shoe
        string name;
        string image;
        bool sold;

    }
    uint256 price = 5*(10**17);
    uint256 ShoesSold = 0;   
    uint256 supply = 100;
    Shoe[] public shoes; //initialise array
    
    constructor() public {
        //mint 100 shoes
        for (uint i=1;i<=supply;i++) {
        //add each shoe to array
        shoes.push(Shoe(msg.sender,"","",false)); 
    
        }
    }

    //gets number of shoes in shoes array
    function getNumberOfShoes() public view returns(uint) {
        return shoes.length;
    }
      // function  to buy a shoe gievn name and image
    function buyShoe(string memory _name,string memory _image)public payable returns(uint) {
        require(price == msg.value, 'Price is not sufficient or too much'); 
        require(ShoesSold <= supply,'Sorry! All shoes are sold out!'); //check that there is still pair of shoes left has not been sold

         uint256 soldShoe = ShoesSold+1; //sell shoe that
         require(shoes[soldShoe].sold == false, "That shoe has alraedy been purchased");
         //transfer ownership of the shoe
        shoes[soldShoe].owner = msg.sender;
        shoes[soldShoe].name = _name;
        shoes[soldShoe].image = _image;
        shoes[soldShoe].sold = true;
        ShoesSold = ShoesSold + 1 ;  //update shoes sold
        return ShoesSold;
    }

    function checkPurchases() external view returns(bool[] memory) {
        bool[] memory Buy ;  //array of booleans to store purchases
            // loop through the buyer addresses
        for (uint256 i = 0; i < shoes.length; i++){
        // check whether the msg.sender is among the buyer addresses
         if (shoes[i].owner == msg.sender){
            // if yes, make it true
            Buy[i] = true;
         } 
        }
        return Buy;

  }
    
}