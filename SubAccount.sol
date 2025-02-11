// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SubAccount {
    address owner;
    bool isTradingAllowed;
    uint256 tradeId;
    mapping(address => uint256) public subAccountBalance;
    mapping(uint256 => Trade) public Trades;

    enum OrderType {
        Buy,
        Sell
    }

    struct Trade {
        address token;
        uint256 amount;
        OrderType orderType;
    }

    constructor(address _eoa) {
        require(_eoa != address(0), "owner addr can't be zero");
        owner = _eoa;
    }

    modifier checkPermission() {
        require(isTradingAllowed, "Not allowed to trade");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function getBalance(address _token) public view returns (uint256) {
        return IERC20(_token).balanceOf(owner);
    }

    function changePermission(bool _isTradingAllowed) external onlyOwner {
        isTradingAllowed = _isTradingAllowed;
    }

    function createTrade(
        uint256 amount,
        address tokenAddr,
        OrderType ordertype
    ) external checkPermission onlyOwner {
        require(amount != 0 && tokenAddr != address(0), "Invalid input");
        updateSubAccountBalance(amount, tokenAddr, true);
        Trade storage trade = Trades[tradeId];
        trade.amount = amount;
        trade.orderType = ordertype;
        trade.token = tokenAddr;
    }

    function execTrade(uint256 _tradeId) external checkPermission onlyOwner {
        Trade storage trade = Trades[_tradeId];
        // we have all the details toexecute the trade
        //execution logic
        updateSubAccountBalance(trade.amount, trade.token, false);
    }

    function updateSubAccountBalance(
        uint256 amount,
        address tokenAddr,
        bool isAdd
    ) internal {
        if (isAdd) {
            subAccountBalance[tokenAddr] += amount;
        } else subAccountBalance[tokenAddr] -= amount;
    }
}
