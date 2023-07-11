// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract ERC4907 is ERC721{
    struct UserInfo{
        address user;
        uint64 expires;
    }
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    mapping(uint=>UserInfo) private _users;

    constructor() ERC721("RentableNFT","RNFT"){}
    function setUser(uint tokenId, address user, uint expires) public {
        require(_isApprovedOrOwner(msg.sender, tokenId),"caller is not owner");
        require(userOf(tokenId)==address(0),"User already assigned");
        require(expires>block.timestamp,"expiry should be in future");
        UserInfo storage info = _users[tokenId];
        info.user = user;
        info.expires = expires;
    }
}