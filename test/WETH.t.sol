// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {Test} from "forge-std/Test.sol";

import { WETH } from "../src/WETH.sol";

contract WETHSymTest is SymTest, Test {
    WETH weth;

    function setUp() public {
        weth = new WETH();
    }

    function test_BalancePreservation(address guy, uint256 value) public  {
        uint256 initialRecipientBalance = weth.balanceOf(guy);

        vm.deal(guy, value);
        vm.prank(guy);

        weth.deposit{ value: value }();

        uint256 finalRecipientBalance = weth.balanceOf(guy);

        assert(finalRecipientBalance == initialRecipientBalance + value);
    }
}