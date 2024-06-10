// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract MultisigWallet {
    receive() external payable { }
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

    event ExecutionSuccess(bytes32 txHash);
    event ExecutionFailure(bytes32 txHash);

    address[] public owners;
    mapping (address => bool) public isOwner;
    uint256 public ownerCount;
    uint256 public threshold;
    uint256 public nonce;

    constructor(address[] memory owners_, uint256 threshold_) {
        _setupOwners(owners_,threshold_);
    }

    function _setupOwners(address[] memory _owners, uint256 _threshold) internal {
        require(threshold == 0, "WTF5000");
        require(_threshold <= _owners.length, "WTF5001");
        require(_threshold >= 1, "ETF5002");
        for(uint256 i = 0; i<_owners.length;i++) {
            address owner = _owners[i];
            require(owner != address(0) && owner != address(this),"WTF5003");
            owners.push(owner);
            isOwner[owner] = true;
        }
        ownerCount = _owners.length;
        threshold = _threshold;
    }

    function execTransaction(
        address to,
        uint256 value,
        bytes memory data,
        bytes memory signatures
    ) public payable virtual returns(bool success) {
        bytes32 txHash = encodeTransactionData(to,value,data,nonce,block.chainid);
        nonce++;
        checkSignature(txHash,signatures);
        (success,) = to.call{value:value}(data);
        require(success,"WTF5004");
        if (success) emit ExecutionSuccess(txHash);
        else emit ExecutionFailure(txHash);
    }

    function checkSignature(bytes32 dataHash, bytes memory signatures) public view {
        uint256 _threshold = threshold;
        require(_threshold > 0,"WTF5005");
        require(signatures.length >= _threshold * 65,"WTF5006");
        
        address lastOwner = address(0);
        address currentOwner;
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 i;
        for(i = 0; i < _threshold; i++){
            (v, r, s) = signatureSplit(signatures, i);
            currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)),v, r, s);
            require(currentOwner > lastOwner && isOwner[currentOwner], "WTF5007");
            lastOwner = currentOwner;
        }
    }

    function signatureSplit(bytes memory signatures, uint256 pos)
    internal 
    pure 
    returns(
        uint8 v,
        bytes32 r,
        bytes32 s
    ) {
        assembly {
        let signaturePos := mul(0x41, pos)
        r := mload(add(signatures, add(signaturePos, 0x20)))
        s := mload(add(signatures, add(signaturePos, 0x40)))
        v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
    }
    }

    function encodeTransactionData(
        address to,
        uint256 value,
        bytes memory data,
        uint256 _nonce,
        uint256 chainid
    ) public pure returns(bytes32) {
        bytes32 safeTxHash = 
        keccak256(
                abi.encode(
                    to,
                    value,
                    keccak256(data),
                    _nonce,
                    chainid
                )
        );
        return safeTxHash;
    }
}