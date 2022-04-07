// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ETHSplitter.sol";


/**
*
* @title ETHSplitterFactory
* @dev contract deploys {ETHSplitter.sol} for a user. A user may only deploy one
* contract per address.
*
**/
contract ETHSplitterFactory {
  event ETHSplitterDeployed(address indexed contractAddress);


  address[] public contracts;
  mapping (address => bool) public contractOwners;

  /**
  *
  * @dev internal function returns bool, checks if user already deployed
  * contract from Factory
  *
  **/
  function alreadyOwner(address _contractOwner) internal view returns (bool){
    return contractOwners[_contractOwner];
  }

  /**
  *
  * @dev funciton returns the amount of contracts deployed from the factory.
  *
  **/
  function getContractCount() public view returns (uint256){
    return contracts.length;
  }


  /**
  *
  * @dev function deploys {ETHSplitter.sol} contract for "msg.sender" and
  * initalizes it with "payeeAddresses"
  *
  **/
  function registerContract(address payable[] memory payeeAddresses) public {
    require(alreadyOwner(msg.sender) == false, "You already have a deployed ETHSplitter." );
    ETHSplitter ethSplitter = new ETHSplitter(payeeAddresses);
    contracts.push(address(ethSplitter));
    ethSplitter.transferOwnership(msg.sender);
    contractOwners[msg.sender] = true;
    emit ETHSplitterDeployed(address(ethSplitter));
  }


}
