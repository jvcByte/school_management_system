// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICalculator1} from "./Calculator1.sol";

contract Calculator2 {

    ICalculator1 public calculator1;

    constructor(address _calculator1Address) {
        calculator1 = ICalculator1(_calculator1Address);
    }

    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    function divide(uint256 a, uint256 b) public pure returns (uint256) {
        require(b > 0, "Division by zero");
        return a / b;
    }

    function callAdd(uint256 a, uint256 b) public returns (uint256) {

        return calculator1.add(a, b);
    }
}