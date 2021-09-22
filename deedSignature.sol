pragma solidity ^0.5.0;

// This works on Google Chrome, no success with Microsoft Edge.
contract deedSignature {
    function deedHash(address _to, uint _amount, uint _nonce , string memory _ownerSig) public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(_to, _amount, _nonce, _ownerSig));
    }
    
    // Producing a signature
    function receiveSignedHash(bytes32 _messageHash) // Input is the returned value from the function above
        public pure returns (bytes32) // Creating another hash
    {
        return keccak256(abi.encodePacked("Signed hash:", _messageHash));
    }
    
    // Verification of the signature
    function verifier(address _signer, address _to, uint _amount, uint _nonce, string memory _ownerSig, bytes memory _signature) public pure returns (bool)    
    {   // Getting the messageHash from the inputs
        bytes32 deedHash = deedHash(_to, _amount,  _nonce, _ownerSig);
        bytes32 receiveSignedHash = receiveSignedHash(deedHash); // Computing the hash
        
        return safetyCheck(receiveSignedHash, _signature) == _signer; // Checking again for the correct signer, to be safe        
    }
    
    function safetyCheck(bytes32 _receiveSignedHash, bytes memory _signature) public pure returns (address)
    {   // Needed to call ecrecover()
        (bytes32 a, bytes32 b, uint8 c) = splitSignature(_signature);
        return ecrecover(_receiveSignedHash, c, a, b);
    }
    
    function splitSignature(bytes memory _sig) public pure returns (bytes32 a, bytes32 b, uint8 c) 
    {
        require(_sig.length == 65);
        assembly {
            /* Adding the first output.
            Needed to assign these values and == didn't work*/
            a := mload(add(_sig, 32)) // 32 isn't stored, it's telling _sig to skip 32 bytes. Dynamic arrays store the array length.
            // Line 37 adds onto the next 32 bytes 
            b := mload(add(_sig, 64))
            // bytes ran an error
            c := byte(0, mload(add(_sig, 96)))
        }
    }
}