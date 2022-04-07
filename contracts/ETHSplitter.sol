// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
*
* @title ETHSplitter
* @dev contract splits the payment of ETH to payees.  The payouts are set to
* be equally distributed among the payees. The owner of the contract can
* dynamically add and remove
* payees.
*
**/
contract ETHSplitter is
Ownable
{
  event PayeeAdded(address account, uint256 shares);
  event PaymentReceivedAndSplit(address from, uint256 amount);

  using SafeMath for uint256;

    address payable[] public payees;

  mapping(address => uint256) public _shares;

  constructor(address payable[] memory payeeAddresses) payable {
    require(payeeAddresses.length > 0, "PaymentSplitter: no payees");

    for (uint256 i = 0; i < payeeAddresses.length; i++) {
        _addPayee(payeeAddresses[i], 1);
    }
  }
  /**
  * @dev Allows the owner to add a new payee
  * see {ETHSplitter - _addPayee} for more information.
  **/
  function addPayee (address payable _address) public onlyOwner virtual {
   //Adds payee with only one share, creating equal distribution
    _addPayee(_address, 1);

  }


  /**
   * @dev Getter for the address of the payee number `index`.
   */
  function payee(uint256 index) public view returns (address) {
      return payees[index];
  }


  /**
   * @dev Add a new payee to the contract.
   * @param account The address of the payee to add.
   * @param shares_ The number of shares owned by the payee.
   */
  function _addPayee(address payable account, uint256 shares_) private {
      require(account != address(0), "PaymentSplitter: account is the zero address");
      require(shares_ > 0, "PaymentSplitter: shares are 0");
      require(_shares[account] == 0, "PaymentSplitter: account already has shares");

      payees.push(account);
      _shares[account] = shares_;
      emit PayeeAdded(account, shares_);
  }

  /**
   * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
   * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
   * reliability of the events, and not the actual splitting of Ether.
   *
   * To learn more about this see the Solidity documentation for
   * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
   * functions].
   */
  receive() external payable virtual {
      require(msg.value > 0, "Fund value 0 is not allowed");
        split(msg.value);

      emit PaymentReceivedAndSplit(_msgSender(), msg.value);
  }

  /**
  *
  * @dev internal function called from {ETHSplitter.sol - receive()}
  * that splits received ETH to all current payees.
  *
  **/

  function split(uint256 amount) internal {
        for (uint256 i = 0; i < payees.length; i++) {
            address payable _payee = payees[i];
            _payee.transfer(amount.div(payees.length));
        }
    }


}
