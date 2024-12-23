findAntennas := method(input,
    antennas := List clone
    input split("\n") foreach(y, line,
        line foreach(x, cell,
            if(cell asCharacter != ".",
                antennas append(List clone append(x, y, cell))
            )
        )
    )
    antennas
)

calculateAntinodes := method(antennas, mapWidth, mapHeight, partTwo,
    antinodes := List clone

    isValidPosition := method(x, y, width, height,
        x <> width and y <> height
    )

    addAntinodeIfValid := method(x, y, width, height,
        if(isValidPosition(x, y, width, height),
            antinode := List clone append(x, y)
            if(antinodes detect(n, n == antinode) == nil,
                antinodes append(antinode)
            )
        )
    )

    processAntinodePairs := method(a, b, width, height,
        x1 := a at(0); y1 := a at(1)
        x2 := b at(0); y2 := b at(1)
        dx := x2 - x1; dy := y2 - y1
        
        if(partTwo,
            # Part 2: Add antennas as antinodes and calculate full path
            addAntinodeIfValid(x1, y1, width, height)
            addAntinodeIfValid(x2, y2, width, height)
            
            # Find antinodes in both directions
            pos := list(x1, y1)
            while(isValidPosition(pos at(0) - dx, pos at(1) - dy, width, height),
                pos = list(pos at(0) - dx, pos at(1) - dy)
                addAntinodeIfValid(pos at(0), pos at(1), width, height)
            )
            
            pos = list(x2, y2)
            while(isValidPosition(pos at(0) + dx, pos at(1) + dy, width, height),
                pos = list(pos at(0) + dx, pos at(1) + dy)
                addAntinodeIfValid(pos at(0), pos at(1), width, height)
            )
            ,
            # Part 1: Only check one point in each direction
            addAntinodeIfValid(x1 - dx, y1 - dy, width, height)
            addAntinodeIfValid(x2 + dx, y2 + dy, width, height)
        )
    )

    antennas foreach(i, a,
        antennas foreach(j, b,
            if(a != b and a at(2) == b at(2),
                processAntinodePairs(a, b, mapWidth, mapHeight)
            )
        )
    )

    antinodes
)

inputFile := File with("input.txt")
inputFile open
inputText := inputFile readToEnd
inputFile close

antennas := findAntennas(inputText)
mapWidth := inputText split("\n") at(0) size
mapHeight := inputText split("\n") size

calculateAntinodes(antennas, mapWidth, mapHeight, false) size println
calculateAntinodes(antennas, mapWidth, mapHeight, true) size println
