// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 按一定比例分钱

contract PaymentSplit {
    event PayeeAdded(address account, uint256 shares); // 增加受益人事件
    event PaymentReleased(address to, uint256 amount); // 受益人提款事件
    event PaymentReceived(address from, uint256 amount); // 合约收款事件

    uint256 public totalShares;
    uint256 public totalReleased;

    mapping (address => uint256) shares;
    mapping (address => uint256) released;
    address[] public payees;

    constructor(address[] memory _payees, uint256[] memory _shares){
        require(_payees.length == _shares.length,"PaymenSplitter: payees and shares length mismatch");
        require(_payees.length > 0,"PaymentSplitter: no payees");
        for(uint256 i = 0;i<_payees.length;i++){
            addPayee(_payees[i],_shares[i]);
        }
    }

    receive() external payable { 
        emit PaymentReceived(msg.sender, msg.value);
    }

    function release(address payable _account) public {
        require(shares[_account] > 0,"no shares");
        uint256 payment = releaseable(_account);
        require(payment != 0,"PaymentSplitter: account is not due payment");
        totalReleased += payment;
        released[_account] += payment;
        emit PaymentReleased(_account, payment);
    }

    function releaseable(address _account) public view returns(uint256) {
        uint256 totalReceived = address(this).balance + totalReleased;
        return pendingPayment(_account,totalReceived,released[_account]);
    }

    function pendingPayment(address _account,uint256 _totalReceived,uint256 _alreadyReleased) public view returns(uint256) {
        return (_totalReceived * shares[_account]) / totalShares - _alreadyReleased;
    }

    function addPayee(address _account, uint256 _accountShares) private {
        require(_account != address(0),"account is the zero address");
        require(_accountShares != 0,"shares are 0");
        require(shares[_account] == 0,"account alreadt exist");

        payees.push(_account);
        shares[_account] = _accountShares;
        totalShares += _accountShares;
        emit PayeeAdded(_account, _accountShares);
    }
}