require('dotenv').config();

const CompoundContract = artifacts.require('./CompoundIntegration');
var { abi } = require('../build/contracts/IERC20.json');

module.exports = async (deployer, network, accounts) => {
  const owner = accounts[0];

  if (network == "kovan") {
    let { DAI, CDAI } = process.env;

    // compound instance deployment
    let compoundInstance = await deployer.deploy(CompoundContract, { from: owner });
    compoundInstance = await CompoundContract.deployed();
    console.log('instance deployed', compoundInstance.address);

    // contract approval
    let daiContract = new web3.eth.Contract(abi, DAI)
    await daiContract.methods.transfer(compoundInstance.address, web3.utils.toWei("10", "ether")).send({ from: owner });
    // console.log('approved dai for contract');
    // In case of already deployed
    // let compoundInstance = await CompoundContract.at("0x80D11B3c27f83d3b5Ef3106599d3C3543800DbF0")

    // Deposit DAI and receive CDAI
    await compoundInstance.sendErc20ToCompound(CDAI, DAI, (10 ** 18).toString(), { from: owner })
    // Get CDAI balance
    let tokenBalance = await compoundInstance.getTokenBalance(CDAI);
    console.log('CDAI balance' + tokenBalance);

    await compoundInstance.redeemCErc20Tokens(CDAI, DAI, tokenBalance.toString(), { from: owner })

  }
}