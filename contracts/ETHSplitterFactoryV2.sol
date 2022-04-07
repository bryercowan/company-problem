// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ETHSplitterAndToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";



/**
*
* @title ETHSplitterFactory
* @dev contract deploys {ETHSplitter.sol} for a user. A user may only deploy one
* contract per address.
*
**/
contract ETHSplitterFactory is Ownable {
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
  * @dev function deploys {ETHSplitterAndToken.sol} contract for "msg.sender" and
  * initalizes it with "payeeAddresses" and "_paymentTokenAddress". After the first
  * deployment the function uses a clone factory to reduce gas prices
  *
  **/
  function registerContract(address payable[] memory payeeAddresses, address _paymentTokenAddress) public {
    require(alreadyOwner(msg.sender) == false, "You already have a deployed ETHSplitter." );
    if(contracts.length == 0) {
      ETHSplitterAndToken ethSplitterAndToken = new ETHSplitterAndToken(payeeAddresses, _paymentTokenAddress);
      contracts.push(address(ethSplitterAndToken));
      ethSplitterAndToken.transferOwnership(msg.sender);
      contractOwners[msg.sender] = true;
      emit ETHSplitterDeployed(address(ethSplitterAndToken));
    } else {
      address payable clone = payable(Clones.clone(contracts[0]));
      ETHSplitterAndToken(clone).initialize(payeeAddresses, _paymentTokenAddress);
      emit ETHSplitterDeployed(clone);
    }
  }


}
