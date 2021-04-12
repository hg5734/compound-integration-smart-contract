// SPDX-License-Identifier: MIT

/**
 * @summary: Compound Integration
 * @author: Himanshu Goyal
 */

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./interface/ICErc20.sol";

contract CompoundIntegration {
    /**
     * @dev send an amount of tokens to corresponding compound contract
     * @param cTokenAddress token contract address
     * @param underlyingToken token contract address
     * @param _amount token amount to be sent
     * @return mint result
     */
    function sendErc20ToCompound(
        address cTokenAddress,
        address underlyingToken,
        uint256 _amount
    ) external returns (uint256) {
        require(underlyingToken != address(0), "Only ERC20");
        IERC20 underlying = IERC20(underlyingToken);
        ICErc20 cToken = ICErc20(cTokenAddress);
        underlying.approve(cTokenAddress, _amount);
        require(
            underlying.allowance(address(this), cTokenAddress) >= _amount,
            "allowance not match"
        );
        uint256 mintResult = cToken.mint(_amount);
        return mintResult;
    }

    /**
     * @dev send an amount of tokens to corresponding compound contract
     * @param cTokenAddress token contract address
     * @param underlyingToken token contract address
     * @param _amount token amount to be sent
     * @return mint result
     */
    function redeemCErc20Tokens(
        address cTokenAddress,
        address underlyingToken,
        uint256 _amount
    ) external returns (bool) {
        require(underlyingToken != address(0), "Only ERC20");
        ICErc20 cToken = ICErc20(cTokenAddress);
        uint256 redeemResult;
        redeemResult = cToken.redeem(_amount);
        return true;
    }

    /**
     * @dev get eth balance on this contract
     */
    function getEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTokenBalance(address _tokenContract)
        external
        view
        returns (uint256)
    {
        return IERC20(_tokenContract).balanceOf(address(this));
    }
}
