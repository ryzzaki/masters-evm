// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {SafeMathUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./TokenInterfaces.sol";

contract HiveManager is
  Initializable,
  OwnableUpgradeable,
  ReentrancyGuardUpgradeable
{
  using SafeMathUpgradeable for uint256;

  // solhint-disable var-name-mixedcase
  IBeeToken public BEE;
  IHiveToken public HIVE;

  // remain as constants
  uint256 public initialBlockHeight;
  uint256 public initialBlockTime;

  uint256 public lambda; // preset decay constant Lambda
  uint256 public nZero; // preset initial exchange rate at time 0
  uint256 public exponent;
  uint256 public base;
  uint256 public exp;
  uint256 public one;

  function initialize(address _bee, address _hive) external initializer {
    __ReentrancyGuard_init();
    __Ownable_init();
    BEE = IBeeToken(_bee);
    HIVE = IHiveToken(_hive);

    initialBlockHeight = block.number;
    initialBlockTime = block.timestamp;

    one = 1;
    nZero = 10; // preset initial exchange rate at time 0
    lambda = 2; // preset decay constant Lambda
    base = 1000;
    exponent = 2718;
    exp = exponent.div(base);
  }

  function calculateExchangeAmount(uint256 amount)
    public
    view
    returns (uint256)
  {
    uint256 difference = block.number - initialBlockHeight;
    return
      amount.div(nZero * one.div(exponent.div(base)**(lambda.mul(difference))));
  }

  function mintReward(address participant, uint256 amount)
    external
    onlyOwner
    nonReentrant
  {
    // mint the right amount to this address
    BEE.mint(amount);
    // send the amount from this address to participant
    BEE.transfer(participant, amount);
  }

  function convictionBurn(uint256 amount) external nonReentrant {
    address participant = _msgSender();
    // transfer participant's tokens to this address
    BEE.transferFrom(participant, address(this), amount);
    // burn the tokens on this address
    BEE.burn(participant, amount);
    // mint governance tokens
    uint256 exchangeAmount = calculateExchangeAmount(amount);
    HIVE.mint(exchangeAmount);
    // transfer the amount of governance tokens to the participant
    HIVE.transfer(participant, exchangeAmount);
  }
}
