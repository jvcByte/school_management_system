// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Storage.sol";
import "./AccessControl.sol";

contract StudentManager {
    struct StudentInfo {
        address studentAddress;
        string name;
        uint8 age;
        uint8 grade;
        Storage.Gender gender;
        Storage.Status status;
    }
    Storage private _storage;
    SchoolAccessControl private _accessControl;

    constructor(address _storageAddress, address _accessControlAddress) {
        _storage = Storage(_storageAddress);
        _accessControl = SchoolAccessControl(_accessControlAddress);
    }

    function registerStudent(
        address _studentAddress,
        string memory _name,
        uint8 _age,
        uint8 _grade,
        Storage.Gender _gender
    ) public {
        require(_accessControl.hasRole(_accessControl.MANAGER_ROLE(), msg.sender), "Caller is not a manager");
        _storage.createStudent(_studentAddress, _name, _age, _grade, _gender);
    }

    function updateStudentGrade(
        address _studentAddress,
        uint _courseId,
        string memory _grade
    ) public {
        require(_accessControl.hasRole(_accessControl.MANAGER_ROLE(), msg.sender), "Caller is not a manager");
        _storage.updateStudentGrade(_studentAddress, _courseId, _grade);
    }

    function updateStudentStatus(address _studentAddress, Storage.Status _newStatus) public {
        require(_accessControl.hasRole(_accessControl.MANAGER_ROLE(), msg.sender), "Caller is not a manager");
        _storage.updateStudentStatus(_studentAddress, _newStatus);
    }

    function getAllStudentDetails() public view returns (StudentInfo[] memory) {
        address[] memory addresses = _storage.getStudentAddresses();
        StudentInfo[] memory allStudents = new StudentInfo[](addresses.length);

        for (uint i = 0; i < addresses.length; i++) {
            (string memory name, uint8 age, uint8 grade, Storage.Gender gender, Storage.Status status) = _storage.students(addresses[i]);
            allStudents[i] = StudentInfo(
                addresses[i],
                name,
                age,
                grade,
                gender,
                status
            );
        }

        return allStudents;
    }
}