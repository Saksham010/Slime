//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;
interface INodeOperatorRegistry{
    /**
        * @dev Struct containing details to setup validator in eth staking contract
        * @param pubkey Public keys of the validator
        * @param withdrawCredential Withdraw credentail based on prefix
        * @param signature Signature of the validator
    */
    struct ValidatorDetails{
        bytes pubkey;
        bytes withdrawCredential;
        bytes signature; 
    }

    /**
        * @dev Struct containing details of the registered node operator 
        * @param name Node operator name
        * @param rewardAddress Address to receive validator rewards
        * @param controllingAddress Address of the node operator
        * @param activeValidators Number of active validators
        * @param enabled Operator status
    */
    struct OperatorDetails{
        string name;
        address rewardAddress; 
        address controllingAddress; 
        uint256 activeValidators;   
        bool enabled;  
    }

    // ************************************
    // ***** Events ******

    /**
        * @dev Emits when a new operator is registered
        * @param _opAddr Address of registered operator
        * @param _rewardAddr Reward address of the registered operator
    */
    event OperatorRegistered(address _opAddr,address _rewardAddr);

    /**
        * @dev Emits when an operator is enabled
        * @param _opAddr Address of enabled operator
    */
    event OperatorEnabled(address _opAddr);

    /**
        * @dev Emits when an operator is disabled
        * @param _opAddr Address of disabled operator
    */
    event OperatorDisabled(address _opAddr);
    

    // ************************************
    // ***** Errors ******

    /**
        * @dev Throws when operator is already registered
    */
    error OperatorAlreadyRegistered();

    /**
        * @dev Throws when the caller is not an registered as operator
    */
    error CallerNotOperator();

    /**
        * @dev Throws when the given address is not an registered as operator
    */
    error OperatorNotRegistered();

    /**
        * @dev Throws when the operator is already enabled
    */
    error OperatorAlreadyEnabled();

    /**
        * @dev Throws when the operator is already disabled
    */
    error OperatorAlreadyDisabled();

    /**
        * @dev Throws when null address is encountered
    */
    error ZeroAddress();

    /**
        * @dev Throws when pub key length is not 48 bytes
    */
    error InvalidPubKeyLength();

    /**
        * @dev Throws when withdraw credential length is not 32 bytes
    */
    error InvalidWithdrawCredentialLength();

    /**
        * @dev Throws when signature length is not 96 bytes
    */
    error InvalidSignatureLength();

    // ************************************
    // ***** External  methods ******

    /**
        * @dev Register a node operator 
        * @param _name Node operator name
        * @param _rewardAddress Address to receive validator rewards
        * @param _controllingAddress Address of the node operator
    */
    function registerNodeOperator(string calldata _name, address _rewardAddress, address _controllingAddress) external;
    
    /**
        * @dev Register a validator
        * @param _pubkeys Public key for the validator
        * @param _withdrawCredential Withdraw credential for validator
        * @param _signature Validator signature
    */
    function registerValidator(bytes calldata _pubkeys, bytes calldata _withdrawCredential, bytes calldata _signature)external;

    /**
        * @dev Get operator detail from address
        * @param _opAddr Operator address
    */
    function getOperatorDetailFromAddr(address _opAddr)external returns(OperatorDetails memory);

    /**
        * @dev Enable operator
        * @param _opAddr Operator address
    */
    function enableOperator(address _opAddr)external;

    /**
        * @dev Disable operator
        * @param _opAddr Operator address
    */
    function disableOperator(address _opAddr)external;

}