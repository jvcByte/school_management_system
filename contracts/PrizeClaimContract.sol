// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPointingContract} from "./PointingContract.sol";

contract PrizeClaimContract {
    IPointingContract private pointingContract;
    uint256 public prize;

    constructor(address _pointingContractAddress) payable {
        pointingContract = IPointingContract(_pointingContractAddress);

        prize = msg.value;
    }

    function setPrize() public payable {

        prize += msg.value;
    }

    function claimPrize() public {
        uint256 points = pointingContract.getPoints(msg.sender);
        if (points < 3) {
            revert("Not enough points to claim a prize.");
        }

        bool success = payable(msg.sender).send(prize);
        if (!success) {
            revert("Prize transfer failed.");
        }

        prize = 0;
    }

    function getPoints() public view returns (uint256) {
        return pointingContract.getPoints(msg.sender);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
