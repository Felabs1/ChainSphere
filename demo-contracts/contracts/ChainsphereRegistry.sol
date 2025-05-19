// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./UserManagement.sol";
import "./PostManagement.sol";
import "./CommunityManagement.sol";
import "./NotificationManagement.sol";
import "./ReelManagement.sol";
import "./PointManagement.sol";

contract ChainsphereRegistry is ChainsphereCore {
    UserManagement public userContract;
    PostManagement public postContract;
    CommunityManagement public communityContract;
    NotificationManagement public notificationContract;
    ReelManagement public reelContract;
    PointManagement public pointContract;
    
    event ContractsDeployed(
        address indexed deployer,
        address userAddr,
        address postAddr,
        address communityAddr,
        address notificationAddr,
        address reelAddr,
        address pointAddr
    );
    
    constructor(address _deployer) ChainsphereCore(_deployer) {
        // Deploy and initialize all contracts
        userContract = new UserManagement(_deployer);
        postContract = new PostManagement(_deployer, address(userContract));
        communityContract = new CommunityManagement(_deployer, address(userContract));
        notificationContract = new NotificationManagement(_deployer, address(userContract));
        reelContract = new ReelManagement(_deployer, address(userContract));
        pointContract = new PointManagement(
            _deployer, 
            address(userContract), 
            address(postContract), 
            address(reelContract)
        );
        
        // Emit event with all deployed addresses
        emit ContractsDeployed(
            _deployer,
            address(userContract),
            address(postContract),
            address(communityContract),
            address(notificationContract),
            address(reelContract),
            address(pointContract)
        );
    }
    
    // Function to get all contract addresses
    function getContractAddresses() external view returns (
        address userAddr,
        address postAddr,
        address communityAddr,
        address notificationAddr,
        address reelAddr,
        address pointAddr
    ) {
        return (
            address(userContract),
            address(postContract),
            address(communityContract),
            address(notificationContract),
            address(reelContract),
            address(pointContract)
        );
    }
    
    // Setup cross-contract permissions
    function setupPermissions() external onlyOwner {
        // Todo
    }
    
    // Function to update a specific contract (for future upgrades)
    function updateContract(string memory contractName, address newAddress) external onlyOwner {
        require(newAddress != address(0), "Invalid address");
        
        if (keccak256(bytes(contractName)) == keccak256(bytes("user"))) {
            userContract = UserManagement(newAddress);
        } else if (keccak256(bytes(contractName)) == keccak256(bytes("post"))) {
            postContract = PostManagement(newAddress);
        } else if (keccak256(bytes(contractName)) == keccak256(bytes("community"))) {
            communityContract = CommunityManagement(newAddress);
        } else if (keccak256(bytes(contractName)) == keccak256(bytes("notification"))) {
            notificationContract = NotificationManagement(newAddress);
        } else if (keccak256(bytes(contractName)) == keccak256(bytes("reel"))) {
            reelContract = ReelManagement(newAddress);
        } else if (keccak256(bytes(contractName)) == keccak256(bytes("point"))) {
            pointContract = PointManagement(newAddress);
        } else {
            revert("Unknown contract name");
        }
    }
}