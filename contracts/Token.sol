// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  uint256 public tokenCap;

  constructor() ERC20("BusyBee", "BZB") {
    // 2 million tokens cap (tokens have 18 decimal places == wei)
    tokenCap = 2000000 * 10 * 18;
  }

  function transfer(address to, uint256 amount) public override returns (bool) {
    _transfer(_msgSender(), to, amount);
    return true;
  }

  function mint(address to, uint256 amount) external {
    require(amount + totalSupply() <= tokenCap, "Cannot mint more!");
    _mint(to, amount);
  }
}
