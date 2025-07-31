// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolAccessControl {
    mapping(bytes32 => mapping(address => bool)) private _roles;

    bytes32 public constant PRINCIPAL_ROLE = keccak256("PRINCIPAL_ROLE");
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PRINCIPAL_ROLE, msg.sender);
    }

    modifier onlyPrincipal() {
        require(
            hasRole(PRINCIPAL_ROLE, msg.sender),
            "Caller is not the principal"
        );
        _;
    }

    modifier onlyManager() {
        require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");
        _;
    }

    function _setupRole(bytes32 role, address account) internal {
        _roles[role][account] = true;
    }

    function grantRole(bytes32 role, address account) public {
        require(
            hasRole(PRINCIPAL_ROLE, msg.sender),
            "Caller is not the principal"
        );
        _roles[role][account] = true;
    }

    function revokeRole(bytes32 role, address account) public {
        require(
            hasRole(PRINCIPAL_ROLE, msg.sender),
            "Caller is not the principal"
        );
        _roles[role][account] = false;
    }

    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }

    function addManager(address _teacherAddress) public onlyPrincipal {
        grantRole(MANAGER_ROLE, _teacherAddress);
    }

    function removeManager(address _teacherAddress) public onlyPrincipal {
        revokeRole(MANAGER_ROLE, _teacherAddress);
    }
}
