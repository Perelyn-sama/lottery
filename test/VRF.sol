// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "../src/Lottery.sol";
import "../src/Merge.sol";

contract VRF is DSTest {
    VRFv2Consumer vrf;

    function setUp() public {
        vrf = new VRFv2Consumer(2274);
    }

    function testExample() public {
        vrf.requestRandomWords();
        emit log_uint(vrf.convert(0));
    }
}
