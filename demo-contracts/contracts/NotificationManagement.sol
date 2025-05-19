// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./UserManagement.sol";
import "./Models.sol";

contract NotificationManagement is ChainsphereCore {
    UserManagement public userContract;
    
    // Notifications
    mapping(address => uint256) public notificationCounts;
    mapping(address => mapping(uint256 => ChainsphereModels.Notification)) public notifications;
    
    event NotificationCreated(
        uint256 indexed notificationId, 
        address indexed caller, 
        address indexed receiver
    );
    
    constructor(address _deployer, address _userContractAddress) ChainsphereCore(_deployer) {
        userContract = UserManagement(_userContractAddress);
    }
    
    function triggerNotification(address receiver) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "Caller not registered");
        require(userContract.viewUser(receiver).userId != address(0), "Receiver not registered");
        
        uint256 notificationId = notificationCounts[receiver];
        
        ChainsphereModels.Notification memory newNotification = ChainsphereModels.Notification({
            notificationId: notificationId,              // Changed from notification_id
            caller: caller,
            receiver: receiver,
            notificationMessage: string(abi.encodePacked(userContract.viewUser(caller).name, " performed an action")),  // Changed from notification_message
            notificationType: "general",                 // Changed from notification_type
            notificationStatus: "unread",                // Changed from notification_status
            timestamp: uint64(block.timestamp)
        });
        
        notifications[receiver][notificationId] = newNotification;
        notificationCounts[receiver]++;
        
        emit NotificationCreated(notificationId, caller, receiver);
    }
    
    function viewNotifications(address accountName) external view returns (ChainsphereModels.Notification[] memory) {
        require(userContract.viewUser(accountName).userId != address(0), "User does not exist");
        
        uint256 notificationCount = notificationCounts[accountName];
        ChainsphereModels.Notification[] memory userNotifications = new ChainsphereModels.Notification[](notificationCount);
        
        for (uint256 i = 0; i < notificationCount; i++) {
            userNotifications[i] = notifications[accountName][i];
        }
        
        return userNotifications;
    }
}