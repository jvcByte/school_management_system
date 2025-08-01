// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lib.sol";

interface ICalculator1 {
    function add(uint256 a, uint256 b) external returns (uint256);
    function subtract(uint256 a, uint256 b) external pure returns (uint256);
}

contract Calculator1 {

    using MathLibrary for uint256;

    uint256 public result;

    function add(uint256 a, uint256 b) public {
        result = a.add(b);
    }

    function subtract(uint256 a, uint256 b) public pure returns (uint256) {
        require(b <= a, "Subtraction underflow");
        return a.subtract(b);
    }
}