pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ElectionInterface {
    function getActiveElections() external view returns(uint[] memory);
}

contract User is Ownable {
    
    // address electionFactoryAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    ElectionInterface electionInterface;
    
    
    function setElectionContractAddress(address _address) external onlyOwner {
        electionInterface = ElectionInterface(_address);
        
    }
    
    function getActiveElections() external view returns(uint[] memory) {
        return electionInterface.getActiveElections();
    }
    
}