// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Storage.sol";
import "./AccessControl.sol";

contract TeacherManager {
    Storage private _storage;
    SchoolAccessControl private _accessControl;

    constructor(address _storageAddress, address _accessControlAddress) {
        _storage = Storage(_storageAddress);
        _accessControl = SchoolAccessControl(_accessControlAddress);
    }

    function registerTeacher(
        address _teacherAddress,
        string memory _name,
        uint8 _age,
        Storage.Gender _gender,
        Storage.Subject _subject
    ) public {
        require(_accessControl.hasRole(_accessControl.PRINCIPAL_ROLE(), msg.sender), "Caller is not the principal");
        _storage.createTeacher(_teacherAddress, _name, _age, _gender, _subject);
    }

    function updateTeacherStatus(address _teacherAddress, Storage.Status _newStatus) public {
        require(_accessControl.hasRole(_accessControl.PRINCIPAL_ROLE(), msg.sender), "Caller is not the principal");
        _storage.updateTeacherStatus(_teacherAddress, _newStatus);
    }
}
