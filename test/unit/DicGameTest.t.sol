// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DiceGame} from "src/DiceGame.sol";

contract DiceGameTest is Test {
    DiceGame diceGame;
    address public constant player1 = 0x0000000000000000000000000000000000000001;
    address public constant player2 = 0x0000000000000000000000000000000000000002;

    function setUp() external {
        diceGame = new DiceGame;
    }

    function testRollDice() public {
        uint256 initialRowCount = diceGame.rowCount();
        uint256 initialSessionCount = diceGame.gameSessionCount();

        // Roll the dice once
        diceGame.rollDice();

        // Check if row count increased
        assertEq(diceGame.rowCount(), initialRowCount + 1, "Row count should increase by 1 after rolling the dice.");

        // Roll the dice until the session ends (10 rolls)
        for (uint256 i = 0; i < 9; i++) {
            diceGame.rollDice();
        }

        // Check if session count increased
        assertEq(
            diceGame.gameSessionCount(),
            initialSessionCount + 1,
            "Session count should increase by 1 after completing a session."
        );
    }

   
}
