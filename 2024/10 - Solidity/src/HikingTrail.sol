// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HikingTrail {
    uint8[50][50] public map;
    uint8 public rows = 50;
    uint8 public cols = 50;
    int8[4] rowDirections = [int8(0), 0, -1, 1];
    int8[4] colDirections = [int8(-1), 1, 0, 0];

    struct Position {
        uint8 row;
        uint8 col;
        uint8 height;
    }

    uint8 public lastProcessedRow;
    uint8 public lastProcessedCol;
    uint8 public lastProcessedRowRatings;
    uint8 public lastProcessedColRatings;
    uint256 public totalScore;
    uint256 public totalRatings;

    constructor(uint8[50][50] memory inputMap) {
        map = inputMap;
    }

    function calculateTrailheadScores() public view returns (uint256 score) {
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < cols; j++) {
                if (map[i][j] == 0) {
                    // calculate score for each trailhead (0) on the map
                    score = calculateScoreForTrailhead(uint8(i), uint8(j));
                }
            }
        }
    }

    function calculateTrailheadScoresBatch(uint8 batchSize) public {
        for (uint256 i = lastProcessedRow; i < rows; i++) {
            for (uint256 j = (i == lastProcessedRow ? lastProcessedCol : 0); j < cols; j++) {
                if (map[i][j] == 0) {
                    totalScore += calculateScoreForTrailhead(uint8(i), uint8(j));
                }
                if (--batchSize == 0) {
                    lastProcessedRow = uint8(i);
                    lastProcessedCol = uint8(j) + 1;
                    if (lastProcessedCol == cols) {
                        lastProcessedRow++;
                        lastProcessedCol = 0;
                    }
                    return;
                }
            }
        }
        lastProcessedRow = 0;
        lastProcessedCol = 0;
    }

    function calculateTrailheadRatingsBatch(uint8 batchSize) public {
        for (uint256 i = lastProcessedRowRatings; i < rows; i++) {
            for (uint256 j = (i == lastProcessedRowRatings ? lastProcessedColRatings : 0); j < cols; j++) {
                if (map[i][j] == 0) {
                    totalRatings += calculateRatingForTrailhead(uint8(i), uint8(j));
                }
                if (--batchSize == 0) {
                    lastProcessedRowRatings = uint8(i);
                    lastProcessedColRatings = uint8(j) + 1;
                    if (lastProcessedColRatings == cols) {
                        lastProcessedRowRatings++;
                        lastProcessedColRatings = 0;
                    }
                    return;
                }
            }
        }
        lastProcessedRowRatings = 0;
        lastProcessedColRatings = 0;
    }

    function calculateScoreForTrailhead(
        uint8 startRow,
        uint8 startCol
        ) internal view returns (uint256 score) {
        // init some vars
        bool[50][50] memory visited;
        Position[] memory stack = new Position[](uint256(rows) * uint256(cols));
        uint256 stackSize = 0;
        int8 x;
        int8 y;

        // push the start position onto the stack
        stack[stackSize++] = Position(startRow, startCol, 0);
        visited[startRow][startCol] = true;


        while (stackSize > 0) {
            // pop the top position off the stack
            Position memory current = stack[--stackSize];

            if (current.height == 9) {
                // we've reached the end of the trail
                score++;
                continue;
            }

            // check all 4 directions
            for (uint256 d = 0; d < 4; d++) {
                y = int8(current.row) + int8(rowDirections[d]);
                x = int8(current.col) + int8(colDirections[d]);

                // skip if out of bounds
                if (!(y >= 0 && y < int8(rows)
                      && x >= 0 && x < int8(cols))) continue;
                    
                // if it's a new position at a reachable height, push it onto the stack
                if (!visited[uint8(y)][uint8(x)] &&
                    map[uint8(y)][uint8(x)] == current.height + 1
                ) {
                    visited[uint8(y)][uint8(x)] = true;
                    stack[stackSize++] = Position(
                        uint8(y),
                        uint8(x),
                        current.height + 1);
                }
            }
        }
    }

    function calculateRatingForTrailhead(uint8 startRow, uint8 startCol) public view returns (uint256 rating) {
        // init some vars
        Position[] memory stack = new Position[](uint256(rows) * uint256(cols));
        uint256 stackSize = 0;
        int8 x;
        int8 y;

        // push the start position onto the stack
        stack[stackSize++] = Position(startRow, startCol, 0);

        while (stackSize > 0) {
            // pop the top position off the stack
            Position memory current = stack[--stackSize];

            if (current.height == 9) {
                // we've reached the end of the trail
                rating++;
                continue;
            }

            // check all 4 directions
            for (uint256 d = 0; d < 4; d++) {
                y = int8(current.row) + int8(rowDirections[d]);
                x = int8(current.col) + int8(colDirections[d]);

                // skip if out of bounds
                if (!(y >= 0 && y < int8(rows)
                    && x >= 0 && x < int8(cols))) continue;

                // if it's a new position at a reachable height, push it onto the stack
                if (map[uint8(y)][uint8(x)] == current.height + 1) {
                    stack[stackSize++] = Position(
                        uint8(y),
                        uint8(x),
                        current.height + 1
                    );
                }
            }
        }
    }
}
