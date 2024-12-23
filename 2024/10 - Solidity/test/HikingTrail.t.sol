// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {HikingTrail} from "../src/HikingTrail.sol";

contract HikingTrailTest is Test {
    HikingTrail public trail;

    function parseInput(string memory input) public pure returns (uint8[50][50] memory) {
        bytes memory inputBytes = bytes(input);
        uint8[50][50] memory map;

        uint8 x = 0;
        uint8 y = 0;

        for (uint256 i = 0; i < inputBytes.length; i++) {
            uint8 c = uint8(inputBytes[i]);
            if (c >= 48 && c <= 57) { // digit
                c -= 48;
                map[x][y] = c;
                x++;
            }
            else if (c == 10) { // newline
                x = 0;
                y++;
            }
        }

        return map;
    }

    function setUp() public {
        string memory input = vm.readFile("input.txt");
        uint8[50][50] memory map = parseInput(input);

        trail = new HikingTrail(map);
    }

    function test_calculateTrailheadScores() public {
        while (trail.lastProcessedRow() < 50) {
            trail.calculateTrailheadScoresBatch(100);
        }
        console.log("Score:", trail.totalScore());
    }

    function test_calculateTrailheadRatings() public {
        while (trail.lastProcessedRowRatings() < 50) {
            trail.calculateTrailheadRatingsBatch(100);
        }
        console.log("Ratings:", trail.totalRatings());
    }
}
