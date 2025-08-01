// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lib.sol";

contract Calc {
    using MathLibrary for uint256;

    uint256 public result;

    function add(uint256 a, uint256 b) public {
        result = a.add(b);
    }

}