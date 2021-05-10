pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ElectionFactory is Ownable {
    
    modifier electionCanTakeCandidate(uint _electionId) {
        require(block.timestamp < elections[_electionId].addCandidateDate);
        require(ElectionToCount[_electionId] < elections[_electionId].candidateLimit);
        _;
    }
    
    struct Election {
        string name;
        uint electionId;
        uint addCandidateDate;
        uint electionDate;
        uint candidateLimit;
    }

    struct Candidate {
        string name;
        uint candidateId;
        uint numberOfVotes;
    }

    Election[] public elections;
    Candidate[] public candidates;

    mapping (uint => uint) public CandidateToElection;
    mapping (uint => uint) ElectionToCount;

    function _createElection(string calldata _name, uint _addCandidateDate, uint _electionDate, uint _candidateLimit) external onlyOwner {
        uint id = elections.length;
        elections.push(Election(_name, id, _addCandidateDate, _electionDate, _candidateLimit));
    }
    
    function _createCandidate(string calldata _name, uint _electionId) external onlyOwner electionCanTakeCandidate(_electionId) {
        uint id = candidates.length;
        candidates.push(Candidate(_name, id, 0));
        CandidateToElection[candidates[id].candidateId] = _electionId;
        ElectionToCount[_electionId]++;
    }
    
    function addVoteToCandidate(uint _candidateId) external returns(uint) {
        for (uint i = 0; i <= candidates.length - 1; i++) {
            if (candidates[i].candidateId == _candidateId) {
                candidates[i].numberOfVotes++;
                break;
            }
        }
        return 1;
    }
    
    function getActiveElections() external view returns(uint[] memory) {
        uint[] memory activeElections = new uint[](elections.length);
        for (uint i = 0; i < elections.length; i++) {
            if (elections[i].electionDate - block.timestamp > 0) {
                activeElections[i] = elections[i].electionId;
            }
        }
        return activeElections;
    }
    
    function getCandidates() external view returns(uint[] memory) {
        uint[] memory candidatesIds = new uint[](candidates.length);
        for (uint i = 0; i < candidates.length; i++) {
            candidatesIds[i] = candidates[i].candidateId;
        }
        return candidatesIds;
    }
    
    
    function getCandidatesForElection(uint _electionId) external view returns(uint[] memory) {
        uint[] memory candidatesIds = new uint[](candidates.length);
        for (uint i = 0; i < candidates.length; i++) {
            if (CandidateToElection[candidates[i].candidateId] == _electionId) {
                candidatesIds[i] = candidates[i].candidateId;
            }
        }
        return candidatesIds;
    }
    
    
    function getBlockTimestamp() external view returns(uint) {
        return block.timestamp;
    }

}
