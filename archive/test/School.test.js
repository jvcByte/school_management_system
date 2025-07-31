const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("School Management System", function () {
    let storage, accessControl, studentManager, teacherManager, courseManager;
    let owner, principal, manager, student1, teacher1;

    beforeEach(async function () {
        [owner, principal, manager, student1, teacher1] = await ethers.getSigners();

        // Deploy Storage
        const Storage = await ethers.getContractFactory("Storage");
        storage = await Storage.deploy();

        // Deploy AccessControl
        const SchoolAccessControl = await ethers.getContractFactory("SchoolAccessControl");
        accessControl = await SchoolAccessControl.deploy();

        // Deploy Managers
        const StudentManager = await ethers.getContractFactory("StudentManager");
        studentManager = await StudentManager.deploy(await storage.getAddress(), await accessControl.getAddress());

        const TeacherManager = await ethers.getContractFactory("TeacherManager");
        teacherManager = await TeacherManager.deploy(await storage.getAddress(), await accessControl.getAddress());

        const CourseManager = await ethers.getContractFactory("CourseManager");
        courseManager = await CourseManager.deploy(await storage.getAddress(), await accessControl.getAddress());

        // Authorize contracts
        await storage.authorizeContract(await studentManager.getAddress());
        await storage.authorizeContract(await teacherManager.getAddress());
        await storage.authorizeContract(await courseManager.getAddress());
    });

    describe("Access Control", function () {
        it("Should make the deployer the principal", async function () {
            const principalRole = await accessControl.PRINCIPAL_ROLE();
            expect(await accessControl.hasRole(principalRole, owner.address)).to.be.true;
        });

        it("Principal should be able to grant manager role", async function () {
            const managerRole = await accessControl.MANAGER_ROLE();
            await accessControl.connect(owner).addManager(manager.address);
            expect(await accessControl.hasRole(managerRole, manager.address)).to.be.true;
        });

        it("Non-principal should not be able to grant manager role", async function () {
            await expect(accessControl.connect(manager).addManager(teacher1.address))
                .to.be.revertedWith("Caller is not the principal");
        });
    });

    describe("Teacher Management", function () {
        it("Principal should be able to register a teacher", async function () {
            await teacherManager.connect(owner).registerTeacher(teacher1.address, "Dr. Smith", 45, 0, 1);
            const teacherData = await storage.teachers(teacher1.address);
            expect(teacherData.name).to.equal("Dr. Smith");
        });

        it("Non-principal should not be able to register a teacher", async function () {
            await expect(teacherManager.connect(manager).registerTeacher(teacher1.address, "Dr. Smith", 45, 0, 1))
                .to.be.revertedWith("Caller is not the principal");
        });
    });

    describe("Student and Course Management", function () {
        beforeEach(async function() {
            // Assign manager role to a user
            await accessControl.connect(owner).addManager(manager.address);
        });

        it("Manager should be able to register a student", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            const studentData = await storage.students(student1.address);
            expect(studentData.name).to.equal("Alice");
        });

        it("Non-manager should not be able to register a student", async function () {
            await expect(studentManager.connect(teacher1).registerStudent(student1.address, "Alice", 15, 10, 1))
                .to.be.revertedWith("Caller is not a manager");
        });

        it("Manager should be able to create a course", async function () {
            await courseManager.connect(manager).createCourse("Advanced Math", teacher1.address);
            const courseData = await storage.courses(1);
            expect(courseData.name).to.equal("Advanced Math");
        });

        it("Manager should be able to enroll a student in a course", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            await courseManager.connect(manager).createCourse("Advanced Math", teacher1.address);
            await courseManager.connect(manager).enrollStudentInCourse(1, student1.address);

            const isEnrolled = await storage.isStudentEnrolled(1, student1.address);
            expect(isEnrolled).to.be.true;
        });

        it("Manager should be able to update a student's grade", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            await studentManager.connect(manager).updateStudentGrade(student1.address, 1, "A+");
            
            const grade = await storage.getStudentGrade(student1.address, 1);
            expect(grade).to.equal("A+");
        });

        it("Manager should be able to update a student's status", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            await studentManager.connect(manager).updateStudentStatus(student1.address, 2); // 2 = Graduated
            const studentData = await storage.students(student1.address);
            expect(studentData.status).to.equal(2);
        });

        it("Principal should be able to update a teacher's status", async function () {
            await teacherManager.connect(owner).registerTeacher(teacher1.address, "Dr. Smith", 45, 0, 1);
            await teacherManager.connect(owner).updateTeacherStatus(teacher1.address, 1); // 1 = Inactive
            const teacherData = await storage.teachers(teacher1.address);
            expect(teacherData.status).to.equal(1);
        });

        it("Should return the correct list of all student addresses", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            // Using a different address for the second student
            const [,,, , , student2] = await ethers.getSigners();
            await studentManager.connect(manager).registerStudent(student2.address, "Bob", 16, 11, 0);

            const allStudents = await storage.getStudentAddresses();
            expect(allStudents.length).to.equal(2);
            expect(allStudents).to.include(student1.address, student2.address);
        });

        it("Should prevent registering the same student twice", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            await expect(studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1))
                .to.be.revertedWith("Student already exists");
        });

        it("Should return details of all students in a single call", async function () {
            await studentManager.connect(manager).registerStudent(student1.address, "Alice", 15, 10, 1);
            const [,,, , , student2] = await ethers.getSigners();
            await studentManager.connect(manager).registerStudent(student2.address, "Bob", 16, 11, 0);

            const allDetails = await studentManager.getAllStudentDetails();
            expect(allDetails.length).to.equal(2);
            expect(allDetails[0].name).to.equal("Alice");
            expect(allDetails[1].name).to.equal("Bob");
        });
    });
});
