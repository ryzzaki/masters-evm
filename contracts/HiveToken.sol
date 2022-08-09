// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

/**
 *  Hive Governance Token
 */

// Mintable; Upgradable; Unlimited Supply

contract HiveToken is
  Initializable,
  ERC20Upgradeable,
  OwnableUpgradeable,
  ReentrancyGuardUpgradeable
{
  address private managerContract;

  function initialize() external initializer {
    __ERC20_init("Hive Token", "HIVE");
    __ReentrancyGuard_init();
    __Ownable_init();
  }

  function manager() public view virtual returns (address) {
    return managerContract;
  }

  modifier onlyManager() {
    require(manager() == _msgSender(), "Error: caller is not manager");
    _;
  }

  function mint(uint256 amount) external onlyManager nonReentrant {
    _mint(_msgSender(), amount);
  }

  function setManager(address _managerContract) external onlyOwner {
    managerContract = _managerContract;
  }
}
