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

    constructor() 
    // Variables that need to be initialized
    ERC721Full("french_house", "FRNC") public {} 

    using Counters for Counters.Counter;
    Counters.Counter token_ids;
    // Features of the house 
    struct House {
        string name; // Basically the address 'e.g. 1600 Washington Avenue'
        uint yearBuilt;
        uint appraisal_value;
        uint initial_value; // What we say the starting price will be
        string homeBuilder; 
        uint bedrooms;
        uint bathrooms;
        uint square_feet;
    }

  // project_overlord can be thought of as a broker with a specific collection of houses/NFTs that we'd add based on this code
  mapping(uint => House) public project_overlord;

  // Declare an event
  event HouseforSale(uint token_id, uint appraisal_value, string report_uri, uint bedrooms, uint bathrooms, uint square_feet);
  
  // This will later be used in an emit to display what'd we'd like to show on chain 
  // For example, say we only wanted to add the information from above on chain when we're selling the house and putting it up for auction:
  function registerHouse(address owner, string memory name, uint yearBuilt, uint appraisal_value, string memory homeBuilder, uint initial_value, string memory token_uri, uint bedrooms, uint bathrooms, uint square_feet, uint breakIns) public returns(uint) {
        token_ids.increment(); // adding another token_id on the chain since we're adding a house to the market/auction 
        uint token_id = token_ids.current();

        _mint(owner, token_id); // This is from ERC721Full.sol. However, take note that it's from ERC721Enumerable.sol, a parent contract of ERC721Full.sol
        // To set the token_uri after the contract is deployed: ipfs://whatever_the_CIDV1_is_from_cid.ipfs.io
        _setTokenURI(token_id, token_uri);

        project_overlord[token_id] = House(name, yearBuilt, appraisal_value, initial_value, homeBuilder, bedrooms, bathrooms, square_feet, breakIns);
  
      return token_id;     
   }
   
  function newAppraisal(uint token_id, uint new_value, string memory report_uri, uint bedrooms, uint bathrooms, uint square_feet) public returns(uint) {
    project_overlord[token_id].appraisal_value += 1; // Push fixed mistake into GitHub (adding appraisal_value instead of setting all further additions as new_value)
    
    emit HouseforSale(token_id, new_value, report_uri, bedrooms, bathrooms, square_feet);
    
    return project_overlord[token_id].appraisal_value; 
  }
}