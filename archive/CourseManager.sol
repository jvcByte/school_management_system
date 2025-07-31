// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Storage.sol";
import "./AccessControl.sol";

contract CourseManager {
    Storage private _storage;
    SchoolAccessControl private _accessControl;
    uint public courseCount;

    constructor(address _storageAddress, address _accessControlAddress) {
        _storage = Storage(_storageAddress);
        _accessControl = SchoolAccessControl(_accessControlAddress);
    }

    function createCourse(
        string memory _name,
        address _teacherAddress
    ) public {
        require(_accessControl.hasRole(_accessControl.MANAGER_ROLE(), msg.sender), "Caller is not a manager");
        
        courseCount++;
        uint courseId = courseCount;

        _storage.createCourse(courseId, _name, _teacherAddress);
    }

    function enrollStudentInCourse(
        uint _courseId,
        address _studentAddress
    ) public {
        require(_accessControl.hasRole(_accessControl.MANAGER_ROLE(), msg.sender), "Caller is not a manager");
        _storage.enrollStudent(_courseId, _studentAddress);
    }
}
