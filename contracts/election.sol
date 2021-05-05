pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ElectionFactory is Ownable {

    // event NewElection(uint ElectionId, string name, uint addCandidateDate, uint electionDate, uint candidateLimit);

    // uint dnaDigits = 16;
    // uint dnaModulus = 10 ** dnaDigits;
    
    modifier electionCanTakeCandidate(uint _electionId) {
        require(block.timestamp < elections[_electionId].addCandidateDate);
        require(ElectionToCount[_electionId] < elections[_electionId].candidateLimit);
        _;
    }
    
    modifier isValidVote(uint _electionId, uint _candidateId) {
        bool electionFound = false;
        for (uint i = 0; i <= elections.length - 1; i++) {
            if (elections[i].electionId == _electionId) {
                electionFound = true;
                break;
            }
        }
        
        bool candidateFound = false;
        for (uint i = 0; i <= candidates.length - 1; i++) {
            if (candidates[i].candidateId == _candidateId) {
                candidateFound = true;
                break;
            }
        }
        
        require(electionFound == true);
        require(candidateFound == true);
        require(CandidateToElection[_candidateId] == _electionId);
        _;
    }

    struct Election {
        // uint id;
        // address[] public candidates;
        uint electionId;
        string name;
        uint addCandidateDate;
        uint electionDate;
        uint candidateLimit;
    }

    struct Candidate {
        uint candidateId;
        string name;
        uint numberOfVotes;
    }

    Election[] public elections;
    Candidate[] public candidates;
    uint[] public activeElections;

    mapping (uint => uint) public CandidateToElection;
    mapping (uint => uint) ElectionToCount;

    function _createElection(string calldata _name, uint _addCandidateDate, uint _electionDate, uint _candidateLimit) external onlyOwner {
        uint id = elections.length;
        elections.push(Election(id, _name, _addCandidateDate, _electionDate, _candidateLimit));
        // emit NewElection(id,  _name, _addCandidateDate,  _electionDate,  _candidateLimit);
    }
    
    function createCandidate(string calldata _name, uint _electionId) external onlyOwner electionCanTakeCandidate(_electionId) {
        uint id = candidates.length;
        candidates.push(Candidate(id, _name, 0));
        CandidateToElection[candidates[id].candidateId] = _electionId;
        ElectionToCount[_electionId]++;
    }
    
    function addVoteToCandidate(uint _electionId, uint _candidateId) external isValidVote(_electionId, _candidateId) {
        for (uint i = 0; i <= candidates.length - 1; i++) {
            if (candidates[i].candidateId == _candidateId) {
                candidates[i].numberOfVotes++;
                break;
            }
        }
    }
    
    function getActiveElections() external returns(uint[] memory) {
        for (uint i = 0; i < elections.length - 1; i++) {
            if (elections[i].electionDate - block.timestamp > 0) {
                activeElections.push(elections[i].electionId);
            }
        }
        return activeElections;
    }
    
    function getBlockTimestamp() external view returns(uint) {
        return block.timestamp;
    }
    

    // function _generateRandomId(string memory _str) private view returns (uint) {
    //     uint rand = uint(keccak256(abi.encodePacked(_str)));
    //     return rand % dnaModulus;
    // }

    // function createRandomElection(string memory _name) public {
    //     require(ownerElectionCount[msg.sender] == 0);
    //     uint randDna = _generateRandomDna(_name);
    //     _createElection(_name, randDna);
    // }

}
