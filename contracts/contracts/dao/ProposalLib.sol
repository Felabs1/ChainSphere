// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Proposal Library
/// @notice Contains enums and structs for DAO proposals

library ProposalLib {
    enum VoteType { None, Yes, No }

    struct ProposalCore {
        uint256 id;
        string description;
        address proposer;
        uint256 voteYes;
        uint256 voteNo;
        uint256 deadline;
        bool executed;
    }

    struct ProposalState {
        ProposalCore core;
        mapping(address => bool) hasVoted;
    }
}
