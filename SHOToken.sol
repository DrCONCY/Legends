// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract SHOToken is ERC20 {
    using SafeMath for uint;
    address public admin;
    uint public maxTotalSupply;

    constructor(
        string memory name,
        string memory symbol,
        uint _maxTotalSupply) 
            ERC20(name, symbol){
                admin = msg.sender;
                maxTotalSupply = _maxTotalSupply; //Supply in TokenBits
            }
        
    function updateAdmin(address newAdmin) external {
        require(msg.sender == admin, "only admin");
        admin = newAdmin;
    }

    function mint(address account, uint256 amount) external{
        require(msg.sender == admin, "only admin");
        uint totalSupply = totalSupply();
        require (totalSupply.add(amount) <= maxTotalSupply, "above maxTotalSupply limit");
        _mint(account, amount);
    }
}

//This is dummy mintable contract for ICO
//Contract name should remain Token as this was declared in the ICO Contract
//To deploy, add 3 variables
//Var1 Name: This should be the name of the ICO TOken
//Var2 SYMBOL :Symbol of the ICO Token
//Var3 MaxTotalSupply: Total Supply of the ICO Token
/// Click Transact and Deploy
///Ensure to add extra 18 zeros to the supply


//Connect to Mainnet using InjectiveWeb3
//Contract will deploy to whatever network in the metamask
//Easily add network by connecting to chainlist.org