pragma solidity >=0.7.0 <0.8.0;


contract ElectionFactory {

    // event NewElection(uint ElectionId, string name, uint addCandidateDate, uint electionDate, uint candidateLimit);

    // uint dnaDigits = 16;
    // uint dnaModulus = 10 ** dnaDigits;
    
    modifier electionCanTakeCandidate(uint _electionId) {
        require(block.timestamp < elections[_electionId].addCandidateDate);
        require(ElectionToCount[_electionId] < elections[_electionId].candidateLimit);
        _;
    }

    struct Election {
        // uint id;
        // address[] public candidates;
        string name;
        uint addCandidateDate;
        uint electionDate;
        uint candidateLimit;
    }

    struct Candidate { 
        string name;
    }

    Election[] public elections;
    Candidate[] public candidates;

    mapping (string => uint) public CandidateToElection;
    mapping (uint => uint) ElectionToCount;
    
    function _createCandidate(string memory _name, uint _electionId) internal electionCanTakeCandidate(_electionId) {
        candidates.push(Candidate(_name));
        uint id = candidates.length - 1;
        CandidateToElection[candidates[id].name] = _electionId;
        ElectionToCount[_electionId]++;
    }

    function _createElection(string memory _name, uint _addCandidateDate, uint _electionDate, uint _candidateLimit) internal {
        elections.push(Election(_name, _addCandidateDate, _electionDate, _candidateLimit));
        uint id = elections.length - 1;
        // emit NewElection(id,  _name, _addCandidateDate,  _electionDate,  _candidateLimit);
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
