// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Dbank{
    mapping (address=>uint) balance;

    function getBalance()public view returns(uint)
    {
        return balance[msg.sender];
    }

    function Deposite() public payable 
    {
        balance[msg.sender]=balance[msg.sender]+msg.value;
    }

    function withdraw(uint _amount) public 
    {
        balance[msg.sender] = balance[msg.sender]-_amount;
        payable (msg.sender).transfer(_amount);
    }

    function Transfer(address _account, uint _amount) public 
    {
        balance[msg.sender] = balance[msg.sender]-_amount;
        balance[_account] = balance[_account]+_amount;
    }
}
