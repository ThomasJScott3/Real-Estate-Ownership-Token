pragma solidity ^0.5.0;
/*
Steps in order to sell the house as an NFT:

1) Create the NFT with parameters being setup
2) Mint the NFT
3) Put the NFT into an auction contract with time/auction parameters
*/
// import for deedTitle gets added HERE;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract Prototype is ERC721Full {
constructor(string memory name, string memory symbol) public {} // might be able to mint in here but I'm not 100% sure, will look further into this.

    using Counters for Counters.Counter;
    Counters.Counter token_ids;
    
    // We need to get the deed/Title value in here for Proof of Ownership
    struct House {
        string name;
        uint yearBuilt;
        uint appraisal_value;
        uint initial_value;
        string homeBuilder;
        uint bedrooms;
        uint bathrooms;
        uint square_feet;
    }

  mapping(uint => House) public project_overlord; // project_overlord can be thought of as a broker with a specific collection of houses/NFTs that we'd add based on this code

  // event HouseforSale is already posted above so I'm not writing it out again.
  event HouseforSale(uint token_id, uint appraisal_value, string report_uri, uint bedrooms, uint bathrooms, uint square_feet);
    
  // This will later be used in an emit to display what'd we'd like to show on chain 
  // For example, say we only wanted to add the information from above on chain when we're selling the house and putting it up for auction:
  function registerHouse(address owner, string memory name, uint yearBuilt, uint appraisal_value, string memory homeBuilder, uint initial_value, string memory token_uri, uint bedrooms, uint bathrooms, uint square_feet) public returns(uint) {
        token_ids.increment(); // adding another token_id on the chain since we're adding a house to the market/auction (If there's a better way of explaining this, feel free to mention this)
        uint token_id = token_ids.current();

        _mint(owner, token_id); // This is from ERC721Full.sol. However, take note that it's from ERC721Enumerable.sol, a parent contract of ERC721Full.sol
        _setTokenURI(token_id, token_uri);

        project_overlord[token_id] = House(name, yearBuilt, appraisal_value, initial_value, homeBuilder, bedrooms, bathrooms, square_feet);
  
      return token_id;     
   }
   
  function newAppraisal(uint token_id, uint new_value, string memory report_uri, uint bedrooms, uint bathrooms, uint square_feet) public returns(uint) {
    project_overlord[token_id].appraisal_value = new_value;
    
    // PaseError: Expected ',' but got identifier => Translation: No identifier values(uint, string)
    emit HouseforSale(token_id, new_value, report_uri, bedrooms, bathrooms, square_feet);
    
    return project_overlord[token_id].appraisal_value;
  }
}