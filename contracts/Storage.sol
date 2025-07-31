// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage {
    address public owner;

    enum Status { active, inactive, graduated }
    enum Gender { male, female, other }
    enum Subject { math, science, english, history, geography }

    struct Student {
        string name;
        uint8 age;
        uint8 grade;
        Gender gender;
        Status status;
        mapping(uint => string) gradesByCourse;
    }

    struct Teacher {
        string name;
        uint8 age;
        Gender gender;
        Subject subject;
        Status status;
    }

    struct Course {
        string name;
        address teacher;
        mapping(address => bool) enrolledStudents;
    }

    mapping(address => Student) public students;
    mapping(address => Teacher) public teachers;
    mapping(uint => Course) public courses;

    mapping(address => bool) public authorizedContracts;

    address[] public studentAddresses;
    mapping(address => bool) public isStudentRegistered;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedContracts[msg.sender], "Contract not authorized");
        _;
    }

    function authorizeContract(address _contractAddress) public onlyOwner {
        authorizedContracts[_contractAddress] = true;
    }

    function unauthorizeContract(address _contractAddress) public onlyOwner {
        authorizedContracts[_contractAddress] = false;
    }

    // --- Setter Functions ---

    function createStudent(
        address _studentAddress,
        string memory _name,
        uint8 _age,
        uint8 _grade,
        Gender _gender
    ) public onlyAuthorized {
        require(!isStudentRegistered[_studentAddress], "Student already exists");

        Student storage s = students[_studentAddress];
        s.name = _name;
        s.age = _age;
        s.grade = _grade;
        s.gender = _gender;
        s.status = Status.active;

        studentAddresses.push(_studentAddress);
        isStudentRegistered[_studentAddress] = true;
    }

    function updateStudentGrade(
        address _studentAddress,
        uint _courseId,
        string memory _grade
    ) public onlyAuthorized {
        students[_studentAddress].gradesByCourse[_courseId] = _grade;
    }

    function createTeacher(
        address _teacherAddress,
        string memory _name,
        uint8 _age,
        Gender _gender,
        Subject _subject
    ) public onlyAuthorized {
        teachers[_teacherAddress] = Teacher(_name, _age, _gender, _subject, Status.active);
    }

    function createCourse(
        uint _courseId,
        string memory _name,
        address _teacherAddress
    ) public onlyAuthorized {
        Course storage c = courses[_courseId];
        c.name = _name;
        c.teacher = _teacherAddress;
    }

    function enrollStudent(uint _courseId, address _studentAddress) public onlyAuthorized {
        courses[_courseId].enrolledStudents[_studentAddress] = true;
    }

    // Getter functions for nested mappings
    function isStudentEnrolled(uint _courseId, address _studentAddress) public view returns (bool) {
        return courses[_courseId].enrolledStudents[_studentAddress];
    }

    function getStudentGrade(address _studentAddress, uint _courseId) public view returns (string memory) {
        return students[_studentAddress].gradesByCourse[_courseId];
    }

    function updateStudentStatus(address _studentAddress, Status _newStatus) public onlyAuthorized {
        students[_studentAddress].status = _newStatus;
    }

    function updateTeacherStatus(address _teacherAddress, Status _newStatus) public onlyAuthorized {
        teachers[_teacherAddress].status = _newStatus;
    }

    function getStudentAddresses() public view returns (address[] memory) {
        return studentAddresses;
    }
}
