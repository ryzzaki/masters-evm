pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * BusyBee BZB Token
 */

contract BusyBeeToken is ERC20 {

    address public minter;
    mapping(address => uint) public balances; // To create mapping for balances

    constructor() ERC20("BusyBeeToken", "BZB") {
        minter = msg.sender; // To set original minter = the contract creator
    }
    
    function mint(address receiver, uint amount) external {
        require(msg.sender == minter);
        balanceOf[receiver] += amount;
        totalSupply += amount; // MaxSupply is unlimited
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply; // To track the amount of token in circulation / minted
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner]; // To return the balance of _owner
    }
}
