// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/token/contracts/v0.6/ERC677Token.sol";
import "./ETHSplitter.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
*
* @title ETHSplitterAndToken
* @dev contract builds on {ETHSplitter.sol} to allow distribution of ERC677
* Tokens along side ETH.
*
**/
contract ETHSplitterAndToken is
Ownable,
ETHSplitter
{
  using SafeMath for uint256;
  address internal paymentToken;
  bool public isInitialized;

  /**
  *
  * @dev function is used to initialize the contract when deployed through
  * a clone factory.
  *
  **/
  function initialize (
    address payable[] memory payees,
    address _paymentToken) external {
    require(!isInitialized, "ETHSplitterAndToken already initialized.");
    isInitialized = true;
  }

  constructor(
    address payable[] memory payees,
    address _paymentToken)
    ETHSplitter(payees) {

    paymentToken = _paymentToken;

  }

  /**
  *
  * @dev function is used to split the payment of tokens to payees.
  *
  **/
  function splitToken() public virtual onlyOwner {
    uint256 payment = IERC20(paymentToken).balanceOf(address(this));
    require(payment != 0, "ETHSplitterAndToken: payment is 0");

    for (uint256 i = 0; i < payees.length; i++) {
        address payable _payee = payees[i];
        IERC20(paymentToken).transfer(_payee, payment.div(payees.length));
    }
  }

}
