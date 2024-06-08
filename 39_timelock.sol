// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 时间锁，可以将合约中的某些功能锁定一段时间
/*
时间锁主要有三个功能：
创建交易，并加入到时间锁队列。
在交易的锁定期满后，执行交易。
后悔了，取消时间锁队列中的某些交易。

项目方一般会把时间锁合约设为重要合约的管理员，例如金库合约，再通过时间锁操作他们。
时间锁合约的管理员一般为项目的多签钱包，保证去中心化。
*/

contract TimeLock {
    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint executeTime);
    event NewAdmin(address indexed newAdmin);

    address public admin; // 管理员地址
    uint public delay; // 交易所定时间（秒）
    uint public constant GRACE_PROID = 7 days; //交易有效期,过期自动失效
    mapping (bytes32 => bool) public queuedTransactions; // 记录所有在时间锁队列中的交易

    modifier onlyOwner() {
        require(msg.sender == admin,"caller not admin");
        _;
    }
    modifier onlyTimelock() {
        require(msg.sender == address(this),"caller not Timelock");
        _;
    }

    constructor(uint _delay) {
        delay = _delay;
        admin = msg.sender;
    }

    function changeAdmin(address newAdmin) public onlyTimelock {
        admin = newAdmin;
        emit NewAdmin(newAdmin);
    }
    function queueTransaction(address target,uint256 value,string memory signature,bytes memory data,uint256 executeTime) public onlyOwner returns(bytes32) {
        require(executeTime >= getBlockTimestamp() + delay,"Estimated execution block must satisfy delay");
        bytes32 txHash = getTxHash(target,value,signature,data,executeTime);
        queuedTransactions[txHash] = true;
        emit QueueTransaction(txHash, target, value, signature, data, executeTime);
        return txHash;
    }
    function cancelTransaction(address target,uint256 value,string memory signature,bytes memory data,uint256 executeTime) public onlyOwner {
        bytes32 txHash = getTxHash(target,value,signature,data,executeTime);
        require(queuedTransactions[txHash],"Transaction hasn't been queued");
        queuedTransactions[txHash] = false;
        emit CancelTransaction(txHash, target, value, signature, data, executeTime);
    }
    function executeTransaction(address target,uint256 value,string memory signature,bytes memory data,uint256 executeTime) public payable onlyOwner returns(bytes memory) {
        bytes32 txHash = getTxHash(target,value,signature,data,executeTime);
        require(queuedTransactions[txHash],"Transaction hasn't been queued");
        require(getBlockTimestamp() >= executeTime,"Transaction hasn't surpassed time lock.");
        require(getBlockTimestamp() <= executeTime + GRACE_PROID,"Transaction is stale.");
        queuedTransactions[txHash] = false;

        bytes memory callData;
        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))),data);
        }

        (bool success, bytes memory returnData) = target.call{value:value}(callData);
        require(success, "Timelock::executeTransaction: Transaction execution reverted.");

        emit ExecuteTransaction(txHash, target, value, signature, data, executeTime);
        return returnData;
    }
    function getBlockTimestamp() public view returns (uint) {
        return block.timestamp;
    }
    function getTxHash(
        address target,
        uint value,
        string memory signature,
        bytes memory data,
        uint executeTime
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(target, value, signature, data, executeTime));
    }

}