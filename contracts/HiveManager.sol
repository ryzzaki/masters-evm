// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "./TokenInterfaces.sol";

contract HiveManager is
  Initializable,
  OwnableUpgradeable,
  ReentrancyGuardUpgradeable
{
  IBeeToken public BEE;
  IHiveToken public HIVE;

  function initialize(address _bee, address _hive) external initializer {
    __ReentrancyGuard_init();
    __Ownable_init();
    BEE = IBeeToken(_bee);
    HIVE = IHiveToken(_hive);
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

  function convictionBurn(address participant, uint256 amount)
    external
    nonReentrant
  {
    // transfer participant's tokens to this address
    BEE.transferFrom(participant, address(this), amount);
    // burn the tokens on this address
    BEE.burn(participant, amount);
    // mint governance tokens @TO-DO linear decay equation is needed
    HIVE.mint(amount);
    // transfer the amount of governance tokens to the participant
    HIVE.transfer(participant, amount);
  }
}
