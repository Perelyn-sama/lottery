// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "../Contract.sol";
import "../Lottery.sol";

contract ContractTest is DSTest {
    Vm private vm = Vm(HEVM_ADDRESS);
    Lottery private lottery;
    StdStorage private stdstore;

    address private addr1 = 0x68df7639ef63fA25D618cdEEBbdd1093d37c8e18;
    address private addr2 = 0x476E35cc46f86B3028Ce0c2bD0C8496b6e79f47f;

    function setUp() public {
        // Deploy NFT contract
        lottery = new Lottery();
    }

    function testGuess() public {
        lottery.takeAGuess{value: 1 ether}(5);
        vm.startPrank(address(0xd3ad));
        // vm.prank(addr1);
        lottery.takeAGuess{value: 1 ether}(5);
        vm.stopPrank();

        // vm.prank(addr2);
        // lottery.takeAGuess{value: 1 ether}(5);
    }
}
