// SPDX-License-Identifier: MIT

/**
 * @summary: Compound Integration
 * @author: Himanshu Goyal
 */

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./interface/ICompound.sol";

contract CompoundIntegration {

    /**
     * @dev send an amount of tokens to corresponding compound contract
     * @param cToken token contract address
     * @param underlyingToken token contract address
     * @param _numTokensToSupply token amount to be sent
     * @return mint result
     */
    function sendErc20ToCompound(address cToken, address underlyingToken, uint256 _numTokensToSupply) external returns(uint256) {
        require(underlyingToken != address(0), "Only ERC20");
        IERC20 underlying = IERC20(underlyingToken);
        ICompound cToken = ICompound(cToken);
        underlying.approve(underlyingToken, _numTokensToSupply);
        require(underlying.allowance(address(this),underlyingToken) >= _numTokensToSupply, "allowance not match");
        uint256 mintResult = cToken.mint(_numTokensToSupply);
        return mintResult;
    }
   
    /**
     * @dev get eth balance on this contract
     */
    function getEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTokenBalance(address _tokenContract) external view returns (uint256) {
        return IERC20(_tokenContract).balanceOf(address(this));
    }

}