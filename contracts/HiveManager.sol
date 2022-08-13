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

  mapping(address => uint256) private walletSessions;

  function initialize(address _bee, address _hive) external initializer {
    __ReentrancyGuard_init();
    __Ownable_init();

    BEE = IBeeToken(_bee);
    HIVE = IHiveToken(_hive);
  }

  function calculateExchangeAmount(address participant, uint256 amount)
    public
    view
    returns (uint256)
  {
    return amount.mul(walletSessions[participant]).div(20000);
  }

  function mintReward(address participant, uint256 amount)
    external
    onlyOwner
    nonReentrant
  {
    // increment the session
    uint256 sessions = walletSessions[participant];
    // cap at 20000
    walletSessions[participant] = sessions <= 20000 ? sessions + 1 : 20000;
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
    uint256 exchangeAmount = calculateExchangeAmount(participant, amount);
    HIVE.mint(exchangeAmount);
    // transfer the amount of governance tokens to the participant
    HIVE.transfer(participant, exchangeAmount);
  }
}
