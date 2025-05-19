// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGovernance {
    function createProposal(string memory description) external returns (uint256);
    function vote(uint256 proposalId, bool support) external;
    function executeProposal(uint256 proposalId) external;
}
