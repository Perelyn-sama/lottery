// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "../src/Lottery.sol";

contract MyScript is Script {
    function run() external {
        vm.startBroadcast();

        MyToken myToken = new MyToken();
    }
}
