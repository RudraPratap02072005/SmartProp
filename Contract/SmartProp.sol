// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SmartProp - A decentralized property management and ownership registry
 * @dev Allows users to register, transfer, and verify property ownership on-chain.
 */
contract SmartProp {
    struct Property {
        uint256 id;
        address owner;
        string location;
        uint256 value;
        bool isRegistered;
    }

    mapping(uint256 => Property) public properties;
    uint256 public propertyCount;

    event PropertyRegistered(uint256 indexed id, address indexed owner, string location, uint256 value);
    event OwnershipTransferred(uint256 indexed id, address indexed from, address indexed to);
    event PropertyUpdated(uint256 indexed id, uint256 newValue);

    modifier onlyOwner(uint256 _propertyId) {
        require(properties[_propertyId].owner == msg.sender, "Not property owner");
        _;
    }

    /// @notice Register a new property
    function registerProperty(string memory _location, uint256 _value) external {
        propertyCount++;
        properties[propertyCount] = Property(propertyCount, msg.sender, _location, _value, true);

        emit PropertyRegistered(propertyCount, msg.sender, _location, _value);
    }

    /// @notice Transfer property ownership to another address
    function transferOwnership(uint256 _propertyId, address _newOwner) external onlyOwner(_propertyId) {
        require(_newOwner != address(0), "Invalid address");
        address oldOwner = properties[_propertyId].owner;
        properties[_propertyId].owner = _newOwner;

        emit OwnershipTransferred(_propertyId, oldOwner, _newOwner);
    }

    /// @notice Update the property value
    function updateValue(uint256 _propertyId, uint256 _newValue) external onlyOwner(_propertyId) {
        properties[_propertyId].value = _newValue;
        emit PropertyUpdated(_propertyId, _newValue);
    }

    /// @notice Retrieve property details
    function getProperty(uint256 _propertyId)
        external
        view
        returns (uint256 id, address owner, string memory location, uint256 value, bool isRegistered)
    {
        Property memory prop = properties[_propertyId];
        return (prop.id, prop.owner, prop.location, prop.value, prop.isRegistered);
    }
}

