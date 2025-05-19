// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./UserManagement.sol";
import "./Models.sol";

contract CommunityManagement is ChainsphereCore {
    UserManagement public userContract;
    uint256 public communityCount;
    
    // Communities
    mapping(uint256 => ChainsphereModels.Community) public communities;
    mapping(uint256 => mapping(uint256 => address)) public communityMembers;
    mapping(uint256 => uint256) public memberCounts;
    
    event CommunityCreated(uint256 indexed communityId, address indexed admin);
    event CommunityJoined(uint256 indexed communityId, address indexed member);
    
    constructor(address _deployer, address _userContractAddress) ChainsphereCore(_deployer) {
        userContract = UserManagement(_userContractAddress);
    }
    
    function createCommunity(
        string memory communityName, 
        string memory description, 
        string memory profileImage, 
        string memory coverImage
    ) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        
        ChainsphereModels.Community memory newCommunity = ChainsphereModels.Community({
            communityId: communityCount,
            communityAdmin: caller,
            communityName: communityName,
            description: description,
            members: 1, // Creator is the first member
            onlineMembers: 0,
            profileImage: profileImage,
            coverImage: coverImage,
            chainspherePoints: 0
        });
        
        communities[communityCount] = newCommunity;
        communityMembers[communityCount][0] = caller;
        memberCounts[communityCount] = 1;
        communityCount++;
        
        emit CommunityCreated(communityCount - 1, caller);
    }
    
    function listCommunities() external view returns (ChainsphereModels.Community[] memory) {
        ChainsphereModels.Community[] memory allCommunities = new ChainsphereModels.Community[](communityCount);
        
        for (uint256 i = 0; i < communityCount; i++) {
            allCommunities[i] = communities[i];
        }
        
        return allCommunities;
    }
    
    function joinCommunity(uint256 communityId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(communityId < communityCount, "Community does not exist");
        require(!memberExist(communityId, caller), "Already a member of this community");
        
        uint256 memberCount = memberCounts[communityId];
        communityMembers[communityId][memberCount] = caller;
        memberCounts[communityId]++;
        communities[communityId].members++;
        
        emit CommunityJoined(communityId, caller);
    }
    
    function memberExist(uint256 communityId, address userId) public view returns (bool) {
        require(communityId < communityCount, "Community does not exist");
        
        uint256 memberCount = memberCounts[communityId];
        for (uint256 i = 0; i < memberCount; i++) {
            if (communityMembers[communityId][i] == userId) {
                return true;
            }
        }
        
        return false;
    }
    
    function viewCommunityMembers(uint256 communityId) external view returns (ChainsphereModels.User[] memory) {
        require(communityId < communityCount, "Community does not exist");
        
        uint256 memberCount = memberCounts[communityId];
        ChainsphereModels.User[] memory members = new ChainsphereModels.User[](memberCount);
        
        for (uint256 i = 0; i < memberCount; i++) {
            address memberAddress = communityMembers[communityId][i];
            members[i] = userContract.viewUser(memberAddress);
        }
        
        return members;
    }
}