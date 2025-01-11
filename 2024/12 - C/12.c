#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_ROWS 200
#define MAX_COLS 200

char garden[MAX_ROWS][MAX_COLS];
bool visited[MAX_ROWS][MAX_COLS];
int rows, cols;

int dr[4] = {0, -1, 0, 1};
int dc[4] = {-1, 0, 1, 0};

bool is_valid(int r, int c, char plant_type) {
    return r >= 0 && r < rows && c >= 0 && c < cols &&
           !visited[r][c] && garden[r][c] == plant_type;
}

// Count corners at a given cell
int count_corners(int r, int c, char plant_type) {
    int corners = 0;

    // Check if we have a corner in each of the 4 quadrants around this cell
    for (int i = 0; i < 4; i++) {
        // Get coordinates for the three cells we need to check
        int r1 = r + dr[i];
        int c1 = c + dc[i];
        int r2 = r + dr[(i+1)%4];
        int c2 = c + dc[(i+1)%4];
        int rd = r + dr[i] + dr[(i+1)%4];
        int cd = c + dc[i] + dc[(i+1)%4];


        // Inner corner if both adjacent cells are the same type and the diagonal is different
        if (r1 >= 0 && r1 < rows && c1 >= 0 && c1 < cols && 
            r2 >= 0 && r2 < rows && c2 >= 0 && c2 < cols && 
            rd >= 0 && rd < rows && cd >= 0 && cd < cols &&
            garden[r1][c1] == plant_type && garden[r2][c2] == plant_type &&
            garden[rd][cd] != plant_type) {
            corners++;
            continue;
        }
        
        // Outer corner if either adjacent cell is out of bounds or different type
        bool cell1_different = (r1 < 0 || r1 >= rows || c1 < 0 || c1 >= cols || garden[r1][c1] != plant_type);
        bool cell2_different = (r2 < 0 || r2 >= rows || c2 < 0 || c2 >= cols || garden[r2][c2] != plant_type);
        if (cell1_different && cell2_different) {
            corners++;
        }
    }
    return corners;
}

// DFS to calculate area and perimeter of a region
void calculate(int r, int c, char plant_type, int *area, int *perimeter, int *corners) {
    visited[r][c] = true;
    (*area)++;
    
    // Count perimeter edges
    for (int i = 0; i < 4; i++) {
        int nr = r + dr[i];
        int nc = c + dc[i];
        
        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols || garden[nr][nc] != plant_type) {
            (*perimeter)++;
        } else if (!visited[nr][nc]) {
            calculate(nr, nc, plant_type, area, perimeter, corners);
        }
    }
    
    // Add corners for this cell
    *corners += count_corners(r, c, plant_type);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Error opening file %s\n", argv[1]);
        return 1;
    }

    // Read garden map
    rows = 0;
    cols = 0;
    char line[MAX_COLS];
    
    while (fgets(line, sizeof(line), file) && rows < MAX_ROWS) {
        // Remove newline if present
        size_t len = strlen(line);
        if (len > 0 && line[len-1] == '\n') {
            line[len-1] = '\0';
            len--;
        }
        
        // Skip empty lines
        if (len == 0) continue;
        
        // Set cols based on first line
        if (rows == 0) {
            cols = len;
        } else if (len != cols) {
            printf("Inconsistent line length at row %d\n. Expected %d, got %d", rows, cols, len);
            fclose(file);
            return 1;
        }
        
        for (size_t i = 0; i < len; i++) {
            garden[rows][i] = line[i];
        }
        garden[rows][len] = '\0';
        rows++;
    }

    fclose(file);

    // Initialize visited array
    for (int i = 0; i < MAX_ROWS; i++) {
        for (int j = 0; j < MAX_COLS; j++) {
            visited[i][j] = false;
        }
    }

    int total_price = 0;
    int total_price_discounted = 0;

    // Traverse the garden map
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (!visited[r][c] && garden[r][c] != '.') {
                // New region found
                int area = 0, perimeter = 0, corners = 0;
                calculate(r, c, garden[r][c], &area, &perimeter, &corners);

                // Calculate prices for this region
                int price = area * perimeter;
                int discounted_price = area * corners;
                
                total_price += price;
                total_price_discounted += discounted_price;

                printf("Region %c: area=%d, perimeter=%d, corners/sides=%d, price=%d, discounted_price=%d\n", 
                       garden[r][c], area, perimeter, corners, price, discounted_price);
            }
        }
    }

    printf("Total price of fencing: %d\n", total_price);
    printf("Total price of fencing (discounted): %d\n", total_price_discounted);
    return 0;
}
