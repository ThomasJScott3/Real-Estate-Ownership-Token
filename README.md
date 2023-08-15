# Project 3: Real Estate Ownership Token

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/NFT.png"></img></p>



Collaborators: Yonathan Eshetu, Marjorie Lawrence & Thomas Scott

[Presentation Link](https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Real%20Estate%20Token%20Presentation.pdf)

Summary: 

The image you see above may appear, to the untrained observer, to simply be a picture of a house. However, it is actually a non-fungible token, or NFT, for short. Although this one is simply a test, future iterations of this token could one day potentially represent title to actual real estate. 

The inspiration for this project came from Thomas’ background in real estate lending. A major part of that background was working with title companies, usually in the context of a secured transaction. That is to say, financing the purchase of an asset; wherein the asset itself is collateral in the event of a default. In such cases, title companies perform the vital work of ensuring that there is a clear chain of title. In order for there to be a clear title, all liens of record have to be cleared. This must be done by the time the new owner closes on the property and the change in ownership is recorded by the county clerk. 

This is where our project comes in: dubbed ‘Operation Overlord’ in honor of the D-Day landings, it was an attempt to digitize a cumbersome process and reduce the financial burden on anyone attempting to purchase real property. The fictitious blurb below was disseminated to classmates as part of the project recruitment process.


Prompt: 

You have just been hired as a software developer at Euclid Title (which was named for the landmark case Euclid v. Ambler Realty Co.), which processes real estate transactions by ensuring that there is ‘clear title’ on properties being bought and sold. This means that there are no liens on the property and that there are no covenants, easements or other restrictions that could disrupt the orderly transfer of real property from one party to another. Your mission, should you choose to accept it, is to spearhead Project Overlord. This is one of Euclid Title’s most guarded development secrets. It involves grafting or otherwise imparting property details to NFTs (non-fungible tokens) and exchanging them through smart contracts as a precursor to replacing traditional title transactions altogether. In addition, such NFTs will be transacted on a TestNet similar to that which has been demonstrated in class.


## Project Code:

This portion is dedicated to contracts that played a role within our project. The goal is to give the reader a rough overview of some key functions and describe some of the features within each file. 


### HouseAuction.sol


<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/Bid.PNG"></img></p>


Function bid: Gives an ability to bid on the auction with the value sent together with this transaction. Also, there’s code within to identify when the highest bid has been increased. (emit that’s tied into the event declared beforehand)
<br>

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/Withdraw.PNG"></img></p>


Function withdraw: For those who were outbid, the contract will send out the amount received based on the sender.

<br>

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/PendingReturn.PNG"></img></p>


Function pendingReturns: Gives the ability to check an address as the input and receive information relating to the amount that the address is supposed to receive back.

<br>

### HousingMarket.sol


<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/CreateAuction.PNG"></img></p>


Function createAuction: Automates the process to offer a listing, compared to the Prototype.sol that required a contract to create an individual listing. With this function, we’re able to deploy our listings from this contract, thus saving time and costs on transaction fees.

<br>

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/EndAuction.PNG"</img></p>


Function endAuction: Putting an end to any offers for the listing; as well as initiating the payment from the highest bidder. This is because the end will signal the transaction to switch the ownership of capital and title.


<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/Bid_Auction.PNG"></img></p>


Function bid: Allows a bid with the ability to check through a modifier, houseRegistered, that will enable the function to see if the bid is for a valid house that's been registered.  

<br>

### PrototypeNFT.sol


<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/newAppraisal.PNG"></img></p>


Function newAppraisal: Allows a new value to be assigned to a property listed through our protocol.

<br>

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/structHouse.PNG"></img></p>


Struct House: Acts as a record with different features of the house added to represent information we’d like potential buyers to have access to. The variables for this were partially adapted from the standard [Uniform Residential Appraisal Report form promulgated by Fannie Mae](https://singlefamily.fanniemae.com/media/12371/display).

<br>

### Testing


<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/testingTool.png"></img></p>


Tools: Testing was conducted using the following test tools - Ganache, Remix and MetaMask.  Specifically, testing was done to ensure that each contract module is vetted for authorization and access control mechanisms. 

<br>

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/testingFunction.PNG"></img></p>


Functions Tested: Contract status when posted on testnet sites where the following steps were taken - token ownership, approve action to transfer and validate token transfer.   

<br>

<p align="center"><img src="https://github.com/ThomasJScott3/Real-Estate-Ownership-Token/blob/main/Images/Reentrancy.PNG"></img></p>


Reentrancy: One feature that this code has is the ability to test a reentrancy attack. Reentrancy works by repeatedly drawing from the balance of a contract using a backdoor. This happens when the contract lacks an update on the accounting within it which updates where users' funds are. Instead of sealing this hole, we decided to leave it open. Our reasoning is that allowing end-users to test our code's security will allow future contributors to better innovate down the line. 

<br>

### Conclusion


In conclusion, this token is a major step towards advancing the state of the art for real estate transactions. One area that was unforeseen at the outset was the ability to host images of the actual house, one of which we also displayed above, on IPFS (interplanetary file system). Not only did this allow our listings to be protected from malicious actors pretending to sell our property, by not allowing a copy of the same image uploaded onto IPFS, but a new hash will be generated when any of our clients make a change to their house and require us to update the pictures with a new version. 
In this vein, the path is now open to address possible issues of title theft. Title theft takes place when a malicious actor [fraudulently transfers a property’s deed from the legal owner to another person](https://www.experian.com/blogs/ask-experian/what-is-home-title-fraud/). The malicious actor can then refinance a mortgage, cash out the legal owner’s equity and walk away with the proceeds. By introducing hashing, we have taken a critical first step in countering this alarming trend and securing real estate transactions with the tremendous power of blockchain.

