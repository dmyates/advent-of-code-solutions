import numpy as np

def patrol(grid, loops=False):
    directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]  # up, right, down, left
    in_bounds = lambda y, x: 0 <= y < len(grid) and 0 <= x < len(grid[0])

    y, x = np.where(grid == '^')[0][0], np.where(grid == '^')[1][0]
    visited = set()
    visited.add((y, x))
    direction = 0
    loop = False

    while in_bounds(y, x):
        my, mx = y + directions[direction][0], x + directions[direction][1]

        if not in_bounds(my, mx):
            break # we've left the map
        if grid[my, mx] == '#':
            direction = (direction + 1) % 4 # hit an obstacle, turn right
            continue

        y, x = my, mx # move

        # Record visited
        current = (y, x, direction) if loops else (y, x)
        if loops and current in visited:
            return (visited, True)

        visited.add(current)

    return (visited, loop) if loops else visited

grid = np.array([list(line.strip()) for line in open("input.txt")])

# Part 1
visited = patrol(grid)
print(len(visited))

# Part 2
loops = 0
for y, x in visited:
    if grid[y, x] == '^':
        continue # can't put an obstacle where the guard is
    grid[y, x] = '#' # new obstacle
    _, loop = patrol(grid, True)
    grid[y, x] = '.' # reset
    loops += 1 if loop else 0

print(loops)

