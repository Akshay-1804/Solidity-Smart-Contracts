// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.4.0/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract IdentityNFT is ERC721{
    struct Identity{
        string email;
        bool isverified;
        uint timestamp;
    }
    mapping (uint=>Identity) public Identities;
    event IdentityVerified(uint indexed tokenId,string email,uint timestamp);
    constructor()ERC721("IdentityNFT","IDNFT"){}
    function mintIdentiy(uint _tokenId, string calldata _email)external{
        require(!_exists(_tokenId),"Token Id already exists");
        Identity memory newIdentity = Identity(_email,false,block.timestamp);
        _safeMint(msg.sender, _tokenId);
        Identities[_tokenId] = newIdentity;
    }
    function verifyIdentity(uint _tokenId)external{
        require (_isApprovedOrOwner(msg.sender, _tokenId),"caller is not owner");
        Identity storage identity = Identities[_tokenId];
        if(!identity.isverified){
            identity.isverified = true;
            emit IdentityVerified(_tokenId, identity.email, block.timestamp);
        }
    }
}