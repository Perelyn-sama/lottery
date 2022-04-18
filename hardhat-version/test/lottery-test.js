const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Lottery", function () {
  before(async function () {
    this.Lottery = await ethers.getContractFactory("Lottery");
  });

  beforeEach(async function () {
    this.lottery = await this.Lottery.deploy();
    await this.lottery.deployed();
  });

  it("is everything working", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const wei = ethers.utils.parseEther("1.0");
    const bal = await this.lottery.contractBalance();
    console.log(ethers.utils.formatEther(bal));

    // await this.lottery.takeAGuess(5, { value: wei });
    await this.lottery.connect(owner).takeAGuess(5, { value: wei });
    await this.lottery.connect(addr1).takeAGuess(5, { value: wei });
    await this.lottery.connect(addr2).takeAGuess(5, { value: wei });

    // Players will be registerd after they take a guess
    // for (let i = 0; i < 3; i++) {
    //   const players = await this.lottery.players(i);
    //   console.log(players);
    // }

    // check who got it right!
    await this.lottery.check();

    // registers those who got it right
    const winners = [];
    for (let i = 0; i < 3; i++) {
      winners.push(await this.lottery.winners(i));
    }

    // Balance after players have taken guesses
    const afterBal = await this.lottery.contractBalance();
    console.log(ethers.utils.formatEther(afterBal));

    const ownerBal = await this.lottery.balanceOf(owner.address);
    console.log(ethers.utils.formatEther(ownerBal));
    const addr1Bal = await this.lottery.balanceOf(addr1.address);
    console.log(ethers.utils.formatEther(addr1Bal));
    const addr2Bal = await this.lottery.balanceOf(addr2.address);
    console.log(ethers.utils.formatEther(addr2Bal));

    const check = winners
      .map((e) => (e == owner.address ? true : false))
      .filter((e) => e);
    console.log(check);
    await this.lottery.connect(owner).withdraw();

    const ownerBalAfter = await this.lottery.balanceOf(owner.address);
    console.log(ethers.utils.formatEther(ownerBalAfter));
    const addr1BalAfter = await this.lottery.balanceOf(addr1.address);
    console.log(ethers.utils.formatEther(addr1BalAfter));
    const addr2BalAfter = await this.lottery.balanceOf(addr2.address);
    console.log(ethers.utils.formatEther(addr2BalAfter));
  });
});
