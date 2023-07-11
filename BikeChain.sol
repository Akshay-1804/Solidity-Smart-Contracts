//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bikechain{
    //setting ownwr of contract
    address payable  owner;

    constructor(){
        owner = payable(msg.sender);
    }

    //Add yourself as renter
    struct Renter {
        address payable walletAddress;
        bool canRent;
        bool active;
        uint balance;
        uint Due;
        uint Start;
        uint End;
    }

    mapping(address=>Renter) public renters;

    function addRenter(address payable walletAddress) public {
            renters[walletAddress].walletAddress=payable(msg.sender);
            renters[walletAddress].canRent = true;
            renters[walletAddress].active= false;
            renters[walletAddress].Start = 0;
            renters[walletAddress].End= 0;
            renters[walletAddress].Due = 0;
            renters[walletAddress].balance = address(this).balance;
        }

//checkout bike 

  function checkOut(address walletAddress)public {
      require(renters[walletAddress].Due==0,"You have previous pending dues please pay it");
      require(renters[walletAddress].canRent==true,"You are not able to rent bike");
      renters[walletAddress].active= true;
      renters[walletAddress].Start=block.timestamp;
      renters[walletAddress].canRent = false;
  } 

//checkin bike

   function checkIn(address walletAddress) public {
       renters[walletAddress].active= false;
       renters[walletAddress].End = block.timestamp;
       renters[walletAddress].canRent =false;
       setDue(walletAddress);
   }

//get duration of renters
function RenterTimespan(uint start,uint end) internal pure returns(uint){
    return end-start;
}

function totalDuration(address walletAddress) public view returns(uint){
    require(renters[walletAddress].active==false,"Please check in the bike first");
//     uint timespan = RenterTimespan(renters[walletAddress].Start, renters[walletAddress].End);
//    uint timespanInMinutes = timespan/60;
//    return timespanInMinutes;
      return 6;
}

function OwnerBal() public view returns(uint) {
    return address(owner).balance;
}

function renterBalance(address walletAddress) public view returns (uint){
    
    return renters[walletAddress].balance;
}

//set due amount

function setDue(address walletAddress) internal{
    uint timespanMinutes = totalDuration(walletAddress);
    uint incrementOfFive = timespanMinutes/5;
    renters[walletAddress].Due = incrementOfFive * 5000000;
}
function canrent(address walletAddress) public view returns(bool){
    require(renters[walletAddress].Due==0,"You have pending Due amount please pay");
    return renters[walletAddress].canRent;
}

function deposit(address walletAddress) payable public{
    renters[walletAddress].balance+=msg.value;
    owner.transfer(msg.value);
}
function makePayment( address walletAddress) payable public{
    require(renters[walletAddress].active==false,"Please check-in the bike first");
    require(renters[walletAddress].Due>0,"You don't have any pending dues");
    require(renters[walletAddress].balance> renters[walletAddress].Due,"You have insufficient funds.");
    renters[walletAddress].balance-=renters[walletAddress].Due;
    renters[walletAddress].canRent = true;
    renters[walletAddress].Due = 0;
    renters[walletAddress].Start = 0;
    renters[walletAddress].End = 0;
    }
}

