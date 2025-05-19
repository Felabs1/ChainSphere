// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../models/UserModels.sol";
import "./ProposalLib.sol";

/// @title IGovernance
/// @notice Interface for the ChainSphere DAO governance contract
interface IGovernance {

    /// @notice Register a new user in the DAO
    /// @param user The full user data to register
    function registerUser(UserModels.User calldata user) external;

    /// @notice Create a new governance proposal
    /// @param description The text description of the proposal
    /// @return proposalId The ID of the created proposal
    function createProposal(string calldata description) external returns (uint256 proposalId);

    /// @notice Vote on a proposal
    /// @param proposalId The ID of the proposal to vote on
    /// @param support True to vote yes, false to vote no
    function vote(uint256 proposalId, bool support) external;

    /// @notice Execute a proposal if it has passed
    /// @param proposalId The ID of the proposal to execute
    function executeProposal(uint256 proposalId) external;

    /// @notice Retrieve a user's full profile
    /// @param userAddr The address of the user
    /// @return The full user data
    function getUser(address userAddr) external view returns (UserModels.User memory);

    /// @notice Retrieve a governance proposal
    /// @param proposalId The ID of the proposal
    /// @return The full proposal core data
    function getProposal(uint256 proposalId) external view returns (ProposalLib.ProposalCore memory);
} 
