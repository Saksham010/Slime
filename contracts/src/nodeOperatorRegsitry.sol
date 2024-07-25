//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;
contract NodeOperatorRegistry{
    uint256 _nid;
    mapping(address=>bool) isRegistered;
    mapping(uint256=>address) nodeOperatorId;
    uint256[] registeredNodeIDL;

    /*  
    @param1 _address: Address of the node operator
    @param2 keys: Withdrawal and signing keys for a node operator
    */
    function registerNode(address _naddress, bytes32[] memory keys) public {

        require(!isRegistered[_naddress],"AlreadyRegistered");
        require(keys.length == 842, "Invalid length of keys");

        nodeOperatorId[_nid] = _naddress;
        isRegistered[_naddress] = true;
        registeredNodeIDL.push(_nid);
        _nid++;
    }   

}