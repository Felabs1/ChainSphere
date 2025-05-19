// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./Models.sol";

contract UserManagement is ChainsphereCore {
    uint256 public usersCount;
    
    // Mapping for users
    mapping(address => ChainsphereModels.User) public users;
    mapping(uint256 => address) public userAddresses;
    
    // Followers and following profiles
    mapping(address => mapping(uint8 => address)) public followers;
    
    event NewUserRegistered(address indexed userId, string name);
    
    constructor(address _deployer) ChainsphereCore(_deployer) {}
    
    function addUser(
        string memory name, 
        string memory username, 
        string memory about, 
        string memory profilePic, 
        string memory coverPhoto
    ) external {
        address caller = msg.sender;
        require(users[caller].userId == address(0), "User already exists");
        
        ChainsphereModels.User memory newUser = ChainsphereModels.User({
            userId: caller,
            name: name,
            username: username,
            about: about,
            profilePic: profilePic,
            coverPhoto: coverPhoto,
            dateRegistered: uint64(block.timestamp),
            noOfFollowers: 0,
            numberFollowing: 0,
            notifications: 0,
            chainspherePoints: 0
        });
        
        users[caller] = newUser;
        userAddresses[usersCount] = caller;
        usersCount++;
        
        emit NewUserRegistered(caller, name);
    }
    
    function viewUser(address userId) external view returns (ChainsphereModels.User memory) {
        require(users[userId].userId != address(0), "User does not exist");
        return users[userId];
    }
    
    function viewUserCount() external view returns (uint256) {
        return usersCount;
    }
    
    function viewAllUsers() external view returns (ChainsphereModels.User[] memory) {
        ChainsphereModels.User[] memory allUsers = new ChainsphereModels.User[](usersCount);
        for (uint256 i = 0; i < usersCount; i++) {
            address userAddress = userAddresses[i];
            allUsers[i] = users[userAddress];
        }
        return allUsers;
    }
    
    function followUser(address user) external {
        address caller = msg.sender;
        require(users[caller].userId != address(0), "Caller not registered");
        require(users[user].userId != address(0), "User to follow does not exist");
        require(caller != user, "Cannot follow yourself");
        require(!followerExist(user), "Already following this user");
        
        uint8 followingCount = users[caller].numberFollowing;
        followers[caller][followingCount] = user;
        users[caller].numberFollowing++;
        users[user].noOfFollowers++;
    }
    
    function followerExist(address user) public view returns (bool) {
        address caller = msg.sender;
        uint8 followingCount = users[caller].numberFollowing;
        
        for (uint8 i = 0; i < followingCount; i++) {
            if (followers[caller][i] == user) {
                return true;
            }
        }
        
        return false;
    }
    
    function viewFollowers(address user) external view returns (ChainsphereModels.User[] memory) {
        require(users[user].userId != address(0), "User does not exist");
        
        uint8 followersCount = users[user].noOfFollowers;
        ChainsphereModels.User[] memory followersList = new ChainsphereModels.User[](followersCount);
        uint8 currentIndex = 0;
        
        for (uint256 i = 0; i < usersCount; i++) {
            address potentialFollower = userAddresses[i];
            uint8 followingCount = users[potentialFollower].numberFollowing;
            
            for (uint8 j = 0; j < followingCount; j++) {
                if (followers[potentialFollower][j] == user) {
                    followersList[currentIndex] = users[potentialFollower];
                    currentIndex++;
                    break;
                }
            }
            
            if (currentIndex == followersCount) {
                break;
            }
        }
        
        return followersList;
    }
    
    function withdrawChainspherePoints(uint256 amount) external {
        address caller = msg.sender;
        require(users[caller].userId != address(0), "User not registered");
        require(users[caller].chainspherePoints >= amount, "Insufficient points");
        
        users[caller].chainspherePoints -= amount;
        // Additional logic for token transfer would go here
    }
}