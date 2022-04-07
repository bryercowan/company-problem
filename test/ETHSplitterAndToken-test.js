const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ETHSplitterAndToken Tests", () => {
  let deployer
  let account1
  let account2
  let testPaymentToken
  let paymentToken
  let paymentTokenAddress

  beforeEach(async () => {
    [deployer, paymentToken, account1, account2] = await ethers.getSigners()

    const TestPaymentToken = await ethers.getContractFactory('ERC20PresetMinterPauser')
    testPaymentToken = await TestPaymentToken.deploy('TestPaymentToken', 'TPT')
    await testPaymentToken.deployed()

  })
  describe('Add payees for equal distributed payments', async () => {

  })

  it('payment token is ditributed evenly to multiple payees', async () => {

    payeeAddressArray = [account1.address, account2.address]
    const ETHSplitterAndToken = await ethers.getContractFactory('ETHSplitterAndToken')
    ethSplitterAndToken = await ETHSplitterAndToken.deploy(
      payeeAddressArray,
      testPaymentToken.address
    )
    await testPaymentToken.mint(ethSplitterAndToken.address, 100)

    await ethSplitterAndToken
          .splitToken()

    const account1TokenBalance = await testPaymentToken.balanceOf(account1.address)
    const account2TokenBalance = await testPaymentToken.balanceOf(account2.address)

    expect(account1TokenBalance).to.equal(50)
    expect(account2TokenBalance).to.equal(50)



  })
})
