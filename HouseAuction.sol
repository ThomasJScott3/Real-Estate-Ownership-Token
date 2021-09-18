pragma solidity ^0.5.0;

contract HousingAuction {
    address deployer; // Us, the protocol.
    address payable public beneficiary; // beneficiary would be the purchaser of the NFT/home.

    // Current state of the auction.
    address public highestBidder; // self-explanatory
    uint public highestBid; // self-explanatory

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns; // Will require the same logic for Project3

    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    bool public ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount); // Examples to refer to when we get a higherbid & end the auction.

    // The following is a so-called natspec comment,
    // recognizable by the three slashes.
    // It will be shown when the user is asked to
    // confirm a transaction.

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    constructor(
        address payable _beneficiary
    ) public {
        deployer = msg.sender; // set as the HousingMarket
        beneficiary = _beneficiary; // Side Note: This is good practice when using Solidity * 
    }

    // Bid on the auction with the value sent together with this transaction.
    // The value will only be refunded if the auction is not won.
    function bid(address payable sender) public payable { // Project3 logic would be similar to this, the exact same...
        // If the bid is not higher, send the money back.
        require(
            msg.value > highestBid); // Already have a higher bid

        require(!ended); // auctionEnd has already been called, it's over

        if (highestBid != 0) { // similar
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = sender;
        highestBid = msg.value;
        emit HighestBidIncreased(sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public returns (bool) { 
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
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
    function auctionEnd() public { // similar
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // 1. Conditions
        require(!ended);
        require(msg.sender == deployer); // Not the auction deployer

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        pendingReturns[highestBidder] = pendingReturns[highestBidder] - (highestBid); 
        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}