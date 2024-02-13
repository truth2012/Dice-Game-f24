// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/*
Contract: DiceGame
- 2 player
- Score board
- roll dice
- Game history
- 10 rolls per sessions
- winner of each session
*/

contract DiceGame {
    struct PlayerHistory {
        uint128 numberOfWins;
    }

    address public player1 = 0x0000000000000000000000000000000000000001;
    address public player2 = 0x0000000000000000000000000000000000000002;
    address public lastWinner;
    uint256 public ties;
    uint256 private constant MaxRowPerSession = 10;
    uint256 public gameSessionCount;
    uint256 public rowCount;

    mapping(address => uint256) public rowPoints; // reset after every session
    mapping(address => PlayerHistory) public playerHistory;

    event Winner(address winner, uint256 player1Score);

    function rollDice() external returns (uint256) {
        if (rowCount == 10) startNewSession();

        rowCount++;

        uint256 pseudoRandomNumber = uint256(keccak256(abi.encode(block.timestamp)));
        uint256 diceRoll = (pseudoRandomNumber % 6) + 1;

        if (rowCount % 2 == 0) {
            rowPoints[player1] += diceRoll;
        } else {
            rowPoints[player2] += diceRoll;
        }

        return (rowCount);
    }

    function startNewSession() internal {
        // Update count history
        gameSessionCount++;

        // rowPoints[player1] > rowPoints[player2] ? player1WinnerPoint = 1 : player2WinnerPoint = 1 ;

        if (rowPoints[player1] > rowPoints[player2]) {
            playerHistory[player1].numberOfWins++;
            lastWinner = player1;

            emit Winner(player1, rowPoints[player1]);
        } else if (rowPoints[player1] < rowPoints[player2]) {
            playerHistory[player2].numberOfWins++;
            lastWinner = player2;

            emit Winner(player2, rowPoints[player2]);
        } else {
            ties++;
        }

        // reset everything but history
        rowCount = 0;
        rowPoints[player1] = 0;
        rowPoints[player2] = 0;
    }

    function checkWins() external view returns (uint256 player1Wins, uint256 player2Wins) {
        player1Wins = playerHistory[player1].numberOfWins;
        player2Wins = playerHistory[player1].numberOfWins;
    }
}
