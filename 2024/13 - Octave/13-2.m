% Open the file and read the entire content
fileID = fopen('input.txt', 'r');
fileContent = fread(fileID, '*char')';
% ^ unmatched ' is transpose -- necessary to read file as lines rather than columns
fclose(fileID);

% Split the content into blocks
blocks = strsplit(fileContent, '\n\n');

% Initialize sums for A and B
sumA = int64(0);
sumB = int64(0);

% Process each block
for i = 1:length(blocks)
    lines = strsplit(strtrim(blocks{i}), '\n');
    
    % Extract numbers from the strings and convert to int64
    buttonA_nums = int64(sscanf(lines{1}, 'Button A: X+%d, Y+%d'));
    buttonB_nums = int64(sscanf(lines{2}, 'Button B: X+%d, Y+%d'));
    prize_nums = int64(sscanf(lines{3}, 'Prize: X=%d, Y=%d'));

    % Add the large number
    prize_nums = prize_nums + int64(10000000000000);

    % Build the Cramer equations
    a1 = buttonA_nums(1); a2 = buttonA_nums(2);
    b1 = buttonB_nums(1); b2 = buttonB_nums(2);
    c1 = prize_nums(1); c2 = prize_nums(2);
    
    % Calculate determinants
    D = a1 * b2 - a2 * b1;
    Dx = c1 * b2 - c2 * b1;
    Dy = a1 * c2 - a2 * c1;
    
    % Discard non-integer solutions
    if D ~= 0 
        x = Dx / D;
        y = Dy / D;
        if mod(Dx, D) == 0 && mod(Dy, D) == 0
            sumA = sumA + x;
            sumB = sumB + y;
        end
    end
end

% Display the summed results
result = sumA * int64(3) + sumB;
disp(result);