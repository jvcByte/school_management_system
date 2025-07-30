// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SMS {
    // State Variables
    address public principal;
    uint256 public schoolFee;

    struct Student {
        address id;
        string name;
        bool exists;
        bool isEnrolled;
        bool isFeePaid;
    }
    mapping(address => Student) public students;

    // Events
    event StudentApplied(address indexed studentId, string name);
    event StudentRegistered(address indexed studentId, string name);
    event SchoolFeePaid(address indexed studentId, uint256 amount);
    event FeeUpdated(uint256 oldFee, uint256 newFee);
    event FundsWithdrawn(uint256 amount);
   
    // Modifiers
    modifier onlyPrincipal() {
        require(msg.sender == principal, "Only principal can perform this action");
        _;
    }

    modifier studentExists(address studentId) {
        require(students[studentId].exists, "Student not found in database");
        _;
    }

    modifier studentEnrolled() {
        require(students[msg.sender].isEnrolled, "Student not enrolled. Contact principal for enrollment");
        _;
    }

    // Constructor
    constructor(uint256 _schoolFee) {
        require(_schoolFee > 0, "School fee must be greater than zero");
        principal = msg.sender;
        schoolFee = _schoolFee;
    }

    // Student applies to the school
    function studentApply(string memory name) public {
        require(bytes(name).length > 0, "Name cannot be empty");
        require(!students[msg.sender].exists, "You have already applied");
        
        students[msg.sender] = Student(msg.sender, name, true, false, false);
        emit StudentApplied(msg.sender, name);
    }

    // Principal registers/enrolls a student
    function registerStudent(address studentId) public onlyPrincipal studentExists(studentId) {
        require(!students[studentId].isEnrolled, "Student is already enrolled");
        
        students[studentId].isEnrolled = true;
        emit StudentRegistered(studentId, students[studentId].name);
    }

    // Student pays school fee
    function paySchoolFee() public payable studentEnrolled {
        require(msg.value == schoolFee, "Incorrect fee amount. Please pay the exact school fee");
        require(!students[msg.sender].isFeePaid, "Fee already paid");
        
        students[msg.sender].isFeePaid = true;
        emit SchoolFeePaid(msg.sender, msg.value);
    }

    // Principal checks if student has paid fee
    function hasStudentPaidFee(address studentId) public view onlyPrincipal studentExists(studentId) returns (bool) {
        return students[studentId].isFeePaid;
    }

    // Student can check their own payment status
    function getMyPaymentStatus() public view returns (bool) {
        require(students[msg.sender].exists, "You are not in the system");
        return students[msg.sender].isFeePaid;
    }

    // Get student details (principal only)
    function getStudentDetails(address studentId) public view onlyPrincipal studentExists(studentId) 
        returns (string memory name, bool isEnrolled, bool isFeePaid) {
        Student memory student = students[studentId];
        return (student.name, student.isEnrolled, student.isFeePaid);
    }

    // Principal can update school fee
    function updateSchoolFee(uint256 newFee) public onlyPrincipal {
        require(newFee > 0, "Fee must be greater than zero");
        require(newFee != schoolFee, "New fee must be different from current fee");
        
        uint256 oldFee = schoolFee;
        schoolFee = newFee;
        emit FeeUpdated(oldFee, newFee);
    }

    // Principal withdraws collected fees
    function withdrawFunds(uint256 amount) public onlyPrincipal {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available");
        require(amount <= contractBalance, "Insufficient contract balance");
        
        // Use call instead of transfer for better gas handling
        (bool success, ) = payable(principal).call{value: amount}("");
        require(success, "Withdrawal failed");
        
        emit FundsWithdrawn(amount);
    }

    // Withdraw all funds
    function withdrawAllFunds() public onlyPrincipal {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available");
        
        (bool success, ) = payable(principal).call{value: contractBalance}("");
        require(success, "Withdrawal failed");
        
        emit FundsWithdrawn(contractBalance);
    }

    // Get contract balance
    function getContractBalance() public view onlyPrincipal returns (uint256) {
        return address(this).balance;
    }

    // Transfer principal role
    function transferPrincipalRole(address newPrincipal) public onlyPrincipal {
        require(newPrincipal != address(0), "Invalid principal address");
        require(newPrincipal != principal, "Already the principal");
        principal = newPrincipal;
    }

    // Fallback functions to handle direct transfers
    receive() external payable {}

    fallback() external payable {
        revert("Function not found.");
    }
}