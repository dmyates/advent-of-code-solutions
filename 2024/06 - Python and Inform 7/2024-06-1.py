print(f""""Guard Gallivant Solution" by "David Yates"

Chapter 1 - Game Logic

Forward is a direction that varies. Forward is north.

Patrolling is an action applying to nothing.

Understand "patrol" as patrolling.

Carry out patrolling:
\twhile the player is not in Endgame:
\t\ttry going forward.

Instead of going nowhere:
\tnow forward is right of forward;
\tsay "Turning right...";
\tsay "You have visited [number of visited rooms] rooms so far.";
\ttry going forward.

Report going to Endgame:
\tsay "You have visited [number of visited rooms] rooms in total.";
\tend the story.

To decide what direction is right of (D - direction):
\tif D is north:
\t\tdecide on east;
\tif D is east:
\t\tdecide on south;
\tif D is south:
\t\tdecide on west;
\tif D is west:
\t\tdecide on north.

Chapter 2 - The Map

Endgame is a room.
""")

import numpy as np

# create grid
grid = np.array([list(line.strip()) for line in open("input.txt")])

# generate I7 code
room_name = lambda y, x: f"P{y}-{x}"
for y, row in enumerate(grid):
    for x, cell in enumerate(row):
        # skip obstacle
        if cell not in '.^':
            continue

        # create room
        this_room = room_name(y, x)
        print(f"{this_room} is a room.")

        # create room connections
        for d, ay, ax in [("west", y, x-1), ("east", y, x+1), ("north", y-1, x), ("south", y+1, x)]:
            if not (0 <= ay < grid.shape[0] and 0 <= ax < grid.shape[1]): # out of bounds
                print(f"Endgame is {d} of {this_room}.")
            elif grid[ay, ax] in '.^': # in bounds and not an obstacle
                print(f"{room_name(ay, ax)} is {d} of {this_room}.")

        # create starting room
        if cell == '^':
            print(f"""
When play begins:
\tnow the player is in {this_room}.""")
