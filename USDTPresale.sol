// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./SHOToken.sol"; //Mintable Token that is being sold

contract USDTPresale{
    using SafeMath for uint;
    struct Sale{
        address investor;
        uint amount;
        bool tokensWithdrawn;
    }

    mapping(address => Sale) public sales;
    address public admin;
    uint public end;
    uint public duration;
    uint public price;
    uint public availableTokens;
    uint public minPurchase;
    uint public maxPurchase;
    Token public token;
    IERC20 public USDT = IERC20(0xAEFC5cC62A36bE102dad7BD026D6eF0d68426dA6); //Adress that receives the deposits

    constructor(
         address tokenAddress,
         uint _duration,
         uint _price,
         uint _availableTokens,
         uint _minPurchase,
         uint _maxPurchase){
             token = Token(tokenAddress);
             require(_duration > 0, "Sales Not Started");
             require(_availableTokens > 0 && _availableTokens <= token.maxTotalSupply());
             require(_minPurchase > 0, "Minimum Purchase is $100");
             require(_maxPurchase > 0 && _maxPurchase <= _availableTokens);

             admin = msg.sender;
             duration = _duration;
             price = _price;
             availableTokens = _availableTokens;
             minPurchase = _minPurchase;
             maxPurchase = _maxPurchase;

         }
    
    
    function start() external onlyAdmin() icoNotActive(){
        end = block.timestamp + duration;
    }
    
    //Buy Functions ICO
    function buy(uint USDTAmount) external icoActive(){
        require(USDTAmount >= minPurchase && USDTAmount <= maxPurchase, "Min 10k, Max 100k");
        uint tokenAmount = USDTAmount.div(price);
        require(tokenAmount <= availableTokens,"Not Enough Token Left for sale");
        USDT.transferFrom(msg.sender, address(this), USDTAmount);
        token.mint(address(this), tokenAmount);
        sales[msg.sender] = Sale(
            msg.sender,
            tokenAmount,
            false
        );
    }


//AWithraws All USDT Deposits
function withdrawUSDT(uint amount) external onlyAdmin() icoEnded(){
    USDT.transfer(admin, amount);
}

modifier icoActive(){
    require (end > 0 && block.timestamp < end && availableTokens > 0, "ICO must be active");
    _;
}

modifier icoNotActive(){
    require(end == 0, 'ICO should not be active');
    _;
}

modifier icoEnded(){
    require(end > 0 && (block.timestamp >= end || availableTokens == 0),"ICO must have ended");
    _;
}

modifier onlyAdmin(){
    require(msg.sender == admin, 'only admin');
     _;
}

}

//Step 1 Deploy Token.sol //Set Name, Symbol, MaxSupply accordingly
//Copy Token Address(Contract Address) and Deployer Account

//Step 2, set the Variables
// var  Token Address: This is Contract Adress of Token.sol
// var MinPurchase and MaxPurchase
// Duration of ICO in seconds
// ICO price in TKNBits
//Avalaible Token for sale
// Deploy  PresaleA
// Call Start Function to Start ICO