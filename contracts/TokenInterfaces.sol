// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/interfaces/IERC20Upgradeable.sol";

interface IHiveToken is IERC20Upgradeable {
  function mint(uint256 amount) external;
}

interface IBeeToken is IHiveToken {
  function burn(address governor, uint256 amount) external;
}
