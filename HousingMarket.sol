pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol"; // This will maintain ownership
import "./HousingAuction.sol";

// Wouldn't there need to be a mint?

contract HousingMarket is ERC721Full, Ownable {

    constructor() ERC721Full("RealEstateMarket", "REIT") public {}
    // Gives the properties available
    using Counters for Counters.Counter;
    Counters.Counter token_ids;
    // Owner 
    address payable owner_address = msg.sender;

    mapping(uint => HousingAuction) public auctions;

    modifier houseRegistered(uint token_id) {
        require(_exists(token_id));
        _;
    }
    // This function will give us a perpetual creation of auctions when our protocol(project_overlord) puts a home up for sale.
    function createAuction(uint token_id) public onlyOwner { // This information will be on chain.
        auctions[token_id] = new HousingAuction(owner_address);
    }

    function registerLand(string memory uri) public payable onlyOwner { // Owner signature could apply here 
        token_ids.increment();
        uint token_id = token_ids.current();
        _mint(owner_address, token_id);
        _setTokenURI(token_id, uri);
        createAuction(token_id);
    }
    // Makes a call to the auction contract, instructing the contract to end the auction.
    function endAuction(uint token_id) public onlyOwner houseRegistered(token_id) {
        HousingAuction auction = auctions[token_id];
        auction.auctionEnd();
        safeTransferFrom(owner(), auction.highestBidder(), token_id); // Previous owner sending property to the new owner
    }

    function auctionEnded(uint token_id) public view returns(bool) {
        HousingAuction auction = auctions[token_id];
        return auction.ended();
    }

    function highestBid(uint token_id) public view houseRegistered(token_id) returns(uint) {
        HousingAuction auction = auctions[token_id];
        return auction.highestBid();
    }

    function pendingReturn(uint token_id, address sender) public view houseRegistered(token_id) returns(uint) {
        HousingAuction auction = auctions[token_id];
        return auction.pendingReturn(sender);
    }
    // houseRegistered(token_id) will enable the function to see if the bid is for a valid house that's been registered.
    function bid(uint token_id) public payable houseRegistered(token_id) {
        HousingAuction auction = auctions[token_id];
        auction.bid.value(msg.value)(msg.sender);
    }

}
