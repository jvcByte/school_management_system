// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPointingContract {
    function addPoints(address _userAddress) external;
    function getPoints(address _userAddress) external view returns (uint256);
}

contract PointingContract {
    
    mapping(address => uint256) points;

    function addPoints(address _userAddress) public {

        points[_userAddress] += 1;
    }

    function getPoints(address _userAddress) public view returns (uint256) {
        return points[_userAddress];
    }
}