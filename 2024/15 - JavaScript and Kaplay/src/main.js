import kaplay from "kaplay";

const k = kaplay({
    width: 800,
    height: 600,
    scale: 2,
    background: [200, 200, 200, ]
});
const GRIDSIZE = 16;

k.loadSprite("bean", "sprites/bean.png");
k.loadSprite("crate", "sprites/crate.png");
k.loadSprite("wall", "sprites/wall.png");
k.loadSprite("crate-left", "sprites/crate-left.png");
k.loadSprite("crate-right", "sprites/crate-right.png");

const LEVELS = [
    [
        "########",
        "##..####",
        "##[][]##",
        "##.[].##",
        "##..@.##",
        "########"
    ],
    [
        "########",
        "##..####",
        "##[]..##",
        "##.[].##",
        "##..[]##",
        "##..@.##",
        "########"
    ],
    [
        "########",
        "##....##",
        "##.[].##",
        "####[]##",
        "##..@.##",
        "########"
    ],
    [
        "####################",
        "##....[]....[]..[]##",
        "##............[]..##",
        "##..[][]....[]..[]##",
        "##....[]@.....[]..##",
        "##[]##....[]......##",
        "##[]....[]....[]..##",
        "##..[][]..[]..[][]##",
        "##........[]......##",
        "####################"
    ],
    [
        "########",
        "#..O.O.#",
        "#.@.O..#",
        "#...O..#",
        "#.#.O..#",
        "#...O..#",
        "#......#",
        "########"
    ],
    [
        "##########",
        "#..O..O.O#",
        "#......O.#",
        "#.OO..O.O#",
        "#..O@..O.#",
        "#O#..O...#",
        "#O..O..O.#",
        "#.OO.O.OO#",
        "#....O...#",
        "##########"
    ],
]

const LEVELOPT = {
    tileWidth: GRIDSIZE,
    tileHeight: GRIDSIZE,
    tiles: {
        "@": () => [
            k.sprite("bean"),
            k.area(),
            "player"
        ],
        "O": () => [
            k.sprite("crate"),
            k.area(),
            "crate",
            "solid"
        ],
        "#": () => [
            k.sprite("wall"),
            k.area(),
            "wall",
            "solid"
        ],
        "[": () => [
            k.sprite("crate-left"),
            k.area(),
            "crate",
            "solid",
            "left"
        ],
        "]": () => [
            k.sprite("crate-right"),
            k.area(),
            "crate",
            "solid",
            "right"
        ]
    }
}

const AUTOMOVES = [
    "",
    "",
    "",
    "<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^ vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv< <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^ ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^>< ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^ >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^ <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<> ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v> v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^",
    "<^^>>>vv<v>>v<<",
    "<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^ vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv< <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^ ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^>< ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^ >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^ <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<> ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v> v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"]

let currentLevelIndex = 0;
let loadedLevels = LEVELS;
let loadedMoves = AUTOMOVES;

function loadLevel(file, upsize) {
    const reader = new FileReader();
    reader.onload = (e) => {
        const text = e.target.result;
        // split text into two parts, level and moves, on empty line
        const [lvl, moves] = text.split("\n\n");
        let newLevel = lvl.split("\n").map(line => line.trim());
        
        // If upsize is checked, double the size of the level
        if (upsize) {
            newLevel = newLevel.map(line => line.replace(/./g, char => {
                switch (char) {
                    case "#": return "##";
                    case "O": return "[]";
                    default: return char + ".";
                }
            }));
        }
        
        loadedLevels.push(newLevel);
        currentLevelIndex = loadedLevels.length - 1;
        k.go("main", currentLevelIndex);

        const newAutoMoves = moves.trim();
        loadedMoves.push(newAutoMoves);
    };
    reader.readAsText(file);
}

document.getElementById('levelFile').addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (file) {
        const upsizeCheckbox = document.getElementById('upsizeLevel');
        loadLevel(file, upsizeCheckbox.checked);
    }
});

scene("main", (levelIndex) => {
    const level = k.addLevel(loadedLevels[levelIndex], LEVELOPT);

    const player = level.get("player")[0];

    const move = (obj, dir) => {
        if (dir.x == 1) obj.moveRight();
        if (dir.x == -1) obj.moveLeft();
        if (dir.y == 1) obj.moveDown();
        if (dir.y == -1) obj.moveUp();
    };

    const movePlayer = (dir) => {
        const moveTo = player.tilePos.add(dir);
        let displaced = level.getAt(moveTo)[0];

        if (displaced === undefined) {
            move(player, dir);
            return;
        }

        if (displaced.is("wall")) {
            return;
        }

        let cratesToMove = new Set();
        let stack = [displaced];
        while(stack.length > 0) {
            let next = stack.pop();
            if (next) {
                if (next.is("wall")) return;
                if (next.is("crate")) {
                    cratesToMove.add(next);
                    stack.push(level.getAt(next.tilePos.add(dir))[0]);
                }
                if (dir.y != 0) {
                    if (next.is("left")) {
                        let partner = level.getAt(next.tilePos.add(vec2(1, 0)))[0]
                        cratesToMove.add(partner);
                        stack.push(level.getAt(partner.tilePos.add(dir))[0]);
                    }
                    if (next.is("right")) {
                        let partner = level.getAt(next.tilePos.add(vec2(-1, 0)))[0]
                        cratesToMove.add(partner);
                        stack.push(level.getAt(partner.tilePos.add(dir))[0]);
                    }
                }
            }
        }
        for (const crate of cratesToMove) {
            move(crate, dir);
        }
        move(player, dir);
    };

    k.onKeyPress("up", () => movePlayer(vec2(0, -1)));
    k.onKeyPress("down", () => movePlayer(vec2(0, 1)));
    k.onKeyPress("left", () => movePlayer(vec2(-1, 0)));
    k.onKeyPress("right", () => movePlayer(vec2(1, 0)));
    
    // autoplay the level quickly
    k.onKeyPress("space", () => {
        const autoMoves = loadedMoves[currentLevelIndex];
        // loop through string character by character
        for (const m of autoMoves) {
            console.log(m)
            switch (m) {
                case "v":
                    movePlayer(vec2(0, 1));
                    break;
                case "^":
                    movePlayer(vec2(0, -1));
                    break;
                case ">":
                    movePlayer(vec2(1, 0));
                    break;
                case "<":
                    movePlayer(vec2(-1, 0));
                    break;
                default:
                    continue;
            }
        }
        console.log("done");
        console.log(level.get("crate").reduce((sum, obj) => {
            return sum + 100*obj.tilePos.y + obj.tilePos.x
        }, 0));
        console.log(level.get("left").reduce((sum, obj) => {
            return sum + 100*obj.tilePos.y + obj.tilePos.x
        }, 0));
    });

    // autoplay the level slowly
    k.onKeyPress("enter", () => {
        const autoMoves = loadedMoves[currentLevelIndex];
        let moveIndex = 0;

        const doNextMove = () => {
            if (moveIndex >= autoMoves.length) {
                console.log("done");
                console.log(level.get("crate").reduce((sum, obj) => {
                    return sum + 100*obj.tilePos.y + obj.tilePos.x
                }, 0));
                console.log(level.get("left").reduce((sum, obj) => {
                    return sum + 100*obj.tilePos.y + obj.tilePos.x
                }, 0));
                return;
            }

            const m = autoMoves[moveIndex];
            console.log(m);
            switch (m) {
                case "v":
                    movePlayer(vec2(0, 1));
                    break;
                case "^":
                    movePlayer(vec2(0, -1));
                    break;
                case ">":
                    movePlayer(vec2(1, 0));
                    break;
                case "<":
                    movePlayer(vec2(-1, 0));
                    break;
            }
            moveIndex++;
            setTimeout(doNextMove, 10);
        };

        doNextMove();
    });

    // go to previous level
    k.onKeyPress("[", () => {
        if (currentLevelIndex > 0) {
            currentLevelIndex--;
            k.go("main", currentLevelIndex);
        }
    });

    // go to next level
    k.onKeyPress("]", () => {
        if (currentLevelIndex < loadedLevels.length - 1) {
            currentLevelIndex++;
            k.go("main", currentLevelIndex);
        }
    });

});

k.go("main", 0);
