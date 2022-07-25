pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  function transfer(address to, uint256 amount) external {
    _transfer(_msgSender(), to, amount);
  }
}
