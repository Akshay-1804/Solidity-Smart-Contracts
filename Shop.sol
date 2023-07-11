// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Shop{
    struct Product{
        string name;
        uint price;
        uint stock;
    }

    mapping (string=>Product) public products;
    address payable owner;

    constructor(){
        owner = payable(msg.sender);
    }

    function addProduct(string memory name, uint price, uint stock) public {
        require(msg.sender == owner,"Only owner can add product");
        products[name] = Product(name,price,stock);
    }

    function updatePrice(string memory name, uint price) public{
        require(msg.sender == owner,"Only owner can update the price");
        require(products[name].price>0,"Price should be greater than zero");
        products[name].price = price;
    }

    function updateStock(string memory name, uint stock) public{
        require(msg.sender==owner,"Only owner can update stock");
        products[name].stock = stock;
    }

    function purchase(string memory name, uint quantity) public payable{
        require(products[name].stock>=quantity,"Stock not available");
        require(msg.value == products[name].price * quantity,"Incorrect amount paid");
        products[name].stock -= quantity;
    }

    function getProduct(string memory name) public view returns(string memory, uint, uint){
        return (products[name].name,products[name].price,products[name].stock); 
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner,"only owner can give access");
        owner = user;
    }

    function removeAccess(address payable user) public{
        require(msg.sender == owner,"only owner can remove access");
        require(user != owner,"can not remove self access");
        owner = payable (msg.sender);

    }
}