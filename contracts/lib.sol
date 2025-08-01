// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MathLibrary {

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        require(a + b >= a, "MathLibrary: addition overflow");
        return a + b;
    }

    function subtract(uint256 a, uint256 b) external pure returns (uint256) {
        require(b <= a, "MathLibrary: subtraction overflow");
        return a - b;
    }

    function multiply(uint256 a, uint256 b) external pure returns (uint256) {
        require(a == 0 || b == 0 || a * b / a == b, "MathLibrary: multiplication overflow");
        return a * b;
    }

    function divide(uint256 a, uint256 b) external pure returns (uint256) {
        require(b > 0, "MathLibrary: division by zero");
        return a / b;
    }
}

library StringLibrary {

    function isStringEmpty (string memory _string) external pure returns(string memory) {
        if (byte(_string).length == 0){

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
        }
    }
}