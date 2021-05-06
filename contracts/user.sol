pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ElectionInterface {
    function getActiveElections() external view returns(uint[] memory);
    function getCandidates() external view returns(uint[] memory);
    function addVoteToCandidate(uint _candidateId) external returns(uint);
    function getCandidatesForElection(uint _electionId) external view returns(uint[] memory);
}

contract User is Ownable {
    
     modifier isValidVote(uint _electionId, uint _candidateId) {
        bool electionFound = false;
        uint[] memory elections = electionInterface.getActiveElections();
        for (uint i = 0; i <= elections.length - 1; i++) {
            if (elections[i] == _electionId) {
                electionFound = true;
                break;
            }
        }
        
        bool candidateFound = false;
        uint[] memory candidates = electionInterface.getCandidates();
        for (uint i = 0; i <= candidates.length - 1; i++) {
            if (candidates[i] == _candidateId) {
                candidateFound = true;
                break;
            }
        }
        
        bool candidateInElectionFound = false;
        uint[] memory candidatesElection = electionInterface.getCandidatesForElection(_electionId);
        for (uint i = 0; i <= candidatesElection.length - 1; i++) {
            if (candidatesElection[i] == _candidateId) {
                candidateInElectionFound = true;
                break;
            }
        }
        
        require(electionFound == true);
        require(candidateFound == true);
        require(candidateInElectionFound == true);
        _;
    }

    // address electionFactoryAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    ElectionInterface electionInterface;
    
    mapping(address => uint[]) ElectionToVoters;
    
    function setElectionContractAddress(address _address) external onlyOwner {
        electionInterface = ElectionInterface(_address);
    }
    
    function getActiveElections() external view returns(uint[] memory) {
        return electionInterface.getActiveElections();
    }
    
    function addVoteToCandidate(uint _electionId, uint _candidateId) external isValidVote(_electionId, _candidateId) returns(uint){
        // check election id and candidtae id
        uint count = electionInterface.getActiveElections().length;
        if (ElectionToVoters[msg.sender].length == 0) {
            ElectionToVoters[msg.sender] = new uint[](count);
            ElectionToVoters[msg.sender].push(_electionId);
            return electionInterface.addVoteToCandidate(_candidateId);
        } else {
            for (uint i = 0; i < ElectionToVoters[msg.sender].length; i++) {
                if (ElectionToVoters[msg.sender][i] == _electionId) {
                    return 0;
                }
            }
            ElectionToVoters[msg.sender].push(_electionId);
            return electionInterface.addVoteToCandidate(_candidateId);
        }
    }
}