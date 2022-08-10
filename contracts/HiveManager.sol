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

  uint256 public initialBlockHeight;
  uint256 public initialBlockTime;
  uint public lambda = 2; // preset decay constant Lambda
  uint public N_0 = 10; // preset initial exchange rate at time 0
  uint256 public N_t = N_0 * exp ^ (-lambda * block.number); // exchange rate at time T with decay
  
  // get user input of the amount of $BEE to be exchanged for $HIVE
  function get() => exchangeAmount

  function initialize(address _bee, address _hive) external initializer {
    __ReentrancyGuard_init();
    __Ownable_init();
    BEE = IBeeToken(_bee);
    HIVE = IHiveToken(_hive);

    initialBlockHeight = block.number;
    initialBlockTime = block.timestamp;
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

  function convictionBurn(address participant, uint256 amount, uint256 N_t )
    external
    nonReentrant
  {
    // check if there is enough $BEE for exchange
    require(
      BEE.balanceOf(address participant) > N_t; "There is not enough $BEE for $HIVE"
      );

    // transfer participant's tokens to this address
    BEE.transferFrom(participant, address(this), amount);
    // burn the tokens on this address
    BEE.burn(participant, amount);
    // mint governance tokens @TO-DO linear decay equation is needed
    HIVE.mint(exchangeAmount.mul(N_t));
    // transfer the amount of governance tokens to the participant
    HIVE.transfer(participant, exchangeAmount.mul(N_t));
  }
}
