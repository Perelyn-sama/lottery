// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "../Contract.sol";
import "../Lottery.sol";

import "../libraries/Strings.sol";

contract ContractTest is DSTest {
    // using Strings for string;

    Vm private vm = Vm(HEVM_ADDRESS);
    Lottery private lottery;
    StdStorage private stdstore;
    uint256 private length;
    // Cheats cheats = Cheats(HEVM_ADDRESS);

    address private addr1 = 0x68df7639ef63fA25D618cdEEBbdd1093d37c8e18;
    address private addr2 = 0x476E35cc46f86B3028Ce0c2bD0C8496b6e79f47f;

    function setUp() public {
        lottery = new Lottery();
        vm.deal(addr1, 1 ether);
        vm.deal(addr2, 1 ether);
        // emit log_uint(addr1.balance);
        // emit log_address(addr1);
    }

    function testGuess() public {
        // use default account to Take address
        lottery.takeAGuess{value: 1 ether}(5);

        // Changes msg.sender of next call to be `addr1`
        vm.prank(addr1);

        // Trigger take a guess function as `addr1`
        lottery.takeAGuess{value: 1 ether}(5);

        // Changes msg.sender of next call to be `addr2`
        vm.prank(addr2);

        // Trigger take a guess function as `addr2`
        lottery.takeAGuess{value: 1 ether}(5);

        // Log the balance of the contract
        // emit log_uint(lottery.contractBalance());

        // Trigger check function with default account
        lottery.check();

        // Get current length of winners arrays
        length = lottery.length();

        // Get list of winners
        for (uint256 i = 0; i < length; ++i) {
            // emit log_address(lottery.winners(i));

            // Convert index to string for logging
            string memory val = Strings.toString(i);
            emit log_named_uint(
                string(abi.encodePacked("Winner ", val, "", " Balance")),
                lottery.winners(i).balance
            );
        }

        // withdraw
        emit log_address(msg.sender);
        lottery.withdraw();

        for (uint256 i = 0; i < 3; ++i) {
            // emit log_address(lottery.winners(i));
            emit log_uint(lottery.winners(i).balance);
        }
    }

    function testWithdraw() public {
        // emit log_uint(lottery.winners.length);
        // emit log_uint(lottery.winners().length);
        emit log_uint(length);
    }
}
