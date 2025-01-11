pkg load symbolic

% Open the file and read the entire content
fileID = fopen('input.txt', 'r');
fileContent = fread(fileID, '*char')';
% ^ unmatched ' is transpose -- necessary to read file as lines rather than columns
fclose(fileID);

% Split the content into blocks
blocks = strsplit(fileContent, '\n\n');

% Initialize sums for A and B
sumA = 0;
sumB = 0;

% Process each block
for i = 1:length(blocks)
    lines = strsplit(strtrim(blocks{i}), '\n');
    
    % Extract numbers from the strings
    buttonA_nums = sscanf(lines{1}, 'Button A: X+%d, Y+%d');
    buttonB_nums = sscanf(lines{2}, 'Button B: X+%d, Y+%d');
    prize_nums = sscanf(lines{3}, 'Prize: X=%d, Y=%d');
    
    % Build the equations
    syms A B
    eq1 = A*buttonA_nums(1) + B*buttonB_nums(1) == prize_nums(1);
    eq2 = A*buttonA_nums(2) + B*buttonB_nums(2) == prize_nums(2);
    
    % Solve the equations
    sol = solve([eq1, eq2], [A, B]);
    
    % Discard non-integer solutions
    if mod(sol.A, 1) == 0
        sumA = sumA + double(sol.A);
    end
    if mod(sol.B, 1) == 0
        sumB = sumB + double(sol.B);
    end

end

% Display the summed results
disp(sumA*3 + sumB);