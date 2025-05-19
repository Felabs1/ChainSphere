// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../models/UserModels.sol";

/// @title ProposalLib
/// @notice Library for proposal structure and voting logic
library ProposalLib {
    enum VoteType {
        None,
        Yes,
        No
    }

    struct ProposalCore {
        uint256 id;
        string description;
        address proposer;
        uint64 deadline;
        bool executed;
        uint64 voteYes;
        uint64 voteNo;
        UserModels.LightUser proposerProfile;
    }

    function createProposal(
        ProposalCore storage self,
        uint256 id,
        string memory description,
        address proposer,
        uint64 deadline,
        UserModels.LightUser memory proposerProfile
    ) internal {
        self.id = id;
        self.description = description;
        self.proposer = proposer;
        self.deadline = deadline;
        self.executed = false;
        self.voteYes = 0;
        self.voteNo = 0;
        self.proposerProfile = proposerProfile;
    }
} 
