// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateMarketplace {
    
    // Structure to represent a property listing
    struct Property {
        uint id;
        address seller;
        string title;
        string description;
        uint price ;
        bool sold;
    }
    address payable public admin;
    bool public paperWork;

    constructor(){
        admin = payable(msg.sender);
        paperWork = false;
    }
    
    // Mapping to store property listings
    mapping(uint => Property) public properties;
    uint public totalProperties;
    
    // Modifier to check if a property is available for sale
    modifier propertyAvailable(uint _id) {
        require(properties[_id].id != 0, "Property does not exist");
        require(!properties[_id].sold, "Property is already sold");
        _;
    }
    
    // Function to list a property for sale
    function listProperty(string memory _title, string memory _description, uint _price) public {
        uint propertyId = totalProperties + 1;
        require(_price<=1 ether,"Invalid price");
        
        Property memory newProperty = Property(propertyId, msg.sender, _title, _description, _price, false);
        properties[propertyId] = newProperty;
        totalProperties++;
            }
    
    // Function to buy a property
    function buyProperty(uint _id) public payable propertyAvailable(_id) {
        require(msg.value >= properties[_id].price*10^18, "Insufficient funds");
        
        properties[_id].sold = true;
        admin.transfer(msg.value);
    }


    function completeTransaction(uint _id) public payable  {
         require(msg.sender == admin,"Only admin can accress this function");
         require(msg.value >= properties[_id].price*10^18, "Insufficient funds");
        paperWork = true;
        address payable seller = payable(properties[_id].seller);
        // Transfer funds to the seller's account
        seller.transfer(msg.value);
    }

}
