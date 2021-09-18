pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol"; // This will maintain ownership
import "./HousingAuction.sol";

// Wouldn't there need to be a mint?

contract HousingMarket is ERC721Full, Ownable {

    constructor() 
    // Still need to understand calling functions & mappings better into child contract
    ERC721Full("HousingMarket", "REFT") public {} // Vars called on: (string memory name, string memory symbol)
    Ownable(owner) public {} // Vars called on: (address private owner, function isOwner*?)

    using Counters for Counters.Counter; // counter 
    Counters.Counter token_ids;
    
    address payable foundation_address = msg.sender;
    
    mapping(uint => HousingAuction) public auctions;
    
    modifier landRegistered(uint token_id) {
        require(_exists(token_id));
        _;
    }
    
    function createAuction(uint token_id) public onlyOwner {
        auctions[token_id] = new HousingAuction();
    }

    function registerLand(string memory uri) public onlyOwner {
        token_ids.increment();
        uint token_id = token_ids.current();
        
        _mint(foundation_address, token_id);
        
        _setTokenURI(token_id, uri);
        
        createAuction(token_id);
        
    }

    function endAuction(uint token_id) public onlyOwner landRegistered(token_id) {
        HousingAuction auction = auctions[token_id]; 
        
        auction.auctionEnd();
        
        safeTransferFrom(owner(), auction.highestBidder(), token_id);
    }

    function auctionEnded(uint token_id) public view returns(bool) {
        HousingAuction auction = auctions[token_id]; 
        return auction.ended();
    }

    function highestBid(uint token_id) public view landRegistered(token_id) returns(uint) {
        HousingAuction auction = auctions[token_id];
        return auction.highestBid();
    }

    function pendingReturn(uint token_id, address sender) public view landRegistered(token_id) returns(uint) {
        HousingAuction auction = auctions[token_id]; // Looking up the auction of interest brought into the function
        return auction.pendingReturn(sender); // Here we call the function that we looked up
    }

    function bid(uint token_id) public payable landRegistered(token_id) {
        HousingAuction auction = auctions[token_id];
        auction.bid.value(msg.value)(msg.sender);
    }

}
