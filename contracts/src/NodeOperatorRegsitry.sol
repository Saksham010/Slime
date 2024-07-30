//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;
import {INodeOperatorRegsitry} from "../interfaces/INodeOperatorRegistry.sol";


contract NodeOperatorRegistry is INodeOperatorRegsitry{
    uint256 operatorId;
    mapping(address=>uint256) getOperatorIdFromAddress;
    mapping(address=>bool) isOperatorRegistered;
    mapping(uint256=>OperatorDetails) getOperatorDetailsFromId;

    modifier checkZeroAddress(address _addr){
        if(_addr == address(0)) revert ZeroAddress();
        _;
    }

    function registerNodeOperator(string calldata _name, address _rewardAddress, address _controllingAddress) public checkZeroAddress(_rewardAddress) checkZeroAddress(_controllingAddress){

        if(isOperatorRegistered[_controllingAddress]) revert OperatorAlreadyRegistered();

        OperatorDetails memory opd = new OperatorDetails(_name,_rewardAddress,_controllingAddress,0,true);
        getOperatorDetailsFromId[_controllingAddress] = operatorId;
        isOperatorRegistered[_controllingAddress] = true;
        getOperatorDetailsFromId[operatorId] = opd;

        operatorId++;

        emit OperatorRegistered(_controllingAddress,_rewardAddress);
    }   

    function registerValidator(bytes calldata _pubkeys,bytes calldata _withdrawCredential ,bytes calldata _signature) public {

        if(!isOperatorRegistered[msg.sender]) revert CallerNotOperator();
        if(_pubkeys.length != 48) revert InvalidPubKeyLength();
        if(_withdrawCredential.length != 32) revert InvalidWithdrawCredentialLength();
        if(_signature.length != 96) revert InvalidSignatureLength();

        
        ValidatorDetails memory vld = new ValidatorDetails(_pubkeys,_withdrawCredential,_signature);
        OperatorDetails memory opd = getOperatorDetailFromAddr(msg.sender);
        opd.activeValidators++;
        getOperatorDetailsFromId[opId] = opd;
    }

    function getOperatorDetailFromAddr(address _opAddr)public checkZeroAddress(_opAddr) returns(OperatorDetails memory) {
        if(!isOperatorRegistered[_opAddr]) revert OperatorNotRegistered();

        uint256 opid = getOperatorIdFromAddress[_opAddr];
        OperatorDetails memory opd = getOperatorDetailsFromId[opid];
        return opd;
    }

    function enableOperator(address _opAddr)public checkZeroAddress(_opAddr) {
        if(!isOperatorRegistered[_opAddr]) revert OperatorNotRegistered();
        if(msg.sender != isOperatorRegistered[_opAddr]) revert CallerNotOperator();

        OperatorDetails memory opd = getOperatorDetailFromAddr(_opAddr);
        if(opd.enabled) revert OperatorAlreadyEnabled();

        opd.enabled = true;
        uint256 opid = getOperatorIdFromAddress[_opAddr];
        getOperatorDetailsFromId[opid] = opd;

        emit OperatorEnabled(_opAddr);

    }

    function disableOperator(address _opAddr) public checkZeroAddress(_opAddr){
        if(!isOperatorRegistered[_opAddr]) revert OperatorNotRegistered();
        if(msg.sender != isOperatorRegistered[_opAddr]) revert CallerNotOperator();

        OperatorDetails memory opd = getOperatorDetailFromAddr(_opAddr);
        if(!opd.enabled) revert OperatorAlreadyDisabled();

        opd.enabled = false;
        uint256 opid = getOperatorIdFromAddress[_opAddr];
        getOperatorDetailsFromId[opid] = opd;

        emit OperatorDisabled(_opAddr);

    }

}