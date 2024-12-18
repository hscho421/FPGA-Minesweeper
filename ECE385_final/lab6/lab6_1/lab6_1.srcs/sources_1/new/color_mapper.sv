module color_mapper (
    input  logic        clk,          
    input  logic [9:0]  DrawX, DrawY,
    input  logic [3:0]  CursorX, CursorY,
    input  logic [7:0]  board_state[16][16],
    input  logic [7:0]  display_state[16][16],
    input  logic        game_over,
    input  logic        victory,
    input  logic        in_menu,
    input  logic [15:0] current_score,
    input  logic [15:0] high_score,      
    output logic [3:0]  Red, Green, Blue
);
    // State definitions
    parameter logic [7:0] HIDDEN = 8'h00;
    parameter logic [7:0] MINE = 8'h80;
    parameter logic [7:0] FLAG = 8'h40;
    parameter logic [7:0] REVEALED = 8'h20;

    // Board parameters
    parameter CELL_SIZE = 30;
    parameter BOARD_SIZE = 16;
    parameter BOARD_OFFSET_X = 80;
    parameter BOARD_OFFSET_Y = 0;
    
    // Title logo parameters
    parameter TITLE_WIDTH = 320;
    parameter TITLE_HEIGHT = 59;
    parameter TITLE_X = 160;
    parameter TITLE_Y = 130;
    
    parameter TEXT_WIDTH = 280;
    parameter TEXT_HEIGHT = 15;
    parameter TEXT_X = 180;
    parameter TEXT_Y = 300;
    
    // Score display parameters
    parameter SCORE_X = 20;
    parameter SCORE_Y = 20;
    parameter HIGH_SCORE_Y = 50;
    parameter DIGIT_WIDTH = 13;
    parameter DIGIT_HEIGHT = 23;
    
    // Color definitions
    parameter [11:0] COLOR_HIDDEN = 12'hCCC;
    parameter [11:0] COLOR_REVEALED = 12'h999;
    parameter [11:0] COLOR_GRID = 12'h666;
    parameter [11:0] COLOR_CURSOR = 12'hFF0;
    parameter [11:0] COLOR_BACKGROUND = 12'hCCC;

    // Position calculations
    logic [9:0] local_x, local_y;
    logic [3:0] cell_x, cell_y;
    logic [9:0] pixel_in_cell_x, pixel_in_cell_y;
    logic [3:0] sprite_pixel_x, sprite_pixel_y;
    logic cursor_on;
    logic grid_line;
    logic in_board;
    
    // Title ROM signals
    logic [$clog2(TITLE_WIDTH*TITLE_HEIGHT)-1:0] title_addr;
    logic [11:0] title_pixel;
    logic in_title_area;
    
    logic [$clog2(TEXT_WIDTH*TEXT_HEIGHT)-1:0] text_addr;
    logic [11:0] text_pixel;
    logic in_text_area;
    
    // Score display signals
    logic [3:0] score_digits[4];
    logic [3:0] high_score_digits[4];
    logic in_score_area;
    logic [3:0] current_digit_id;
    logic [3:0] score_pixel_x;
    logic [4:0] score_pixel_y;
    logic [11:0] score_color;
    
    // Sprite control signals
    logic [3:0] current_sprite_id;
    logic [11:0] sprite_color;
    logic sprite_pixel_on;

    // Position calculations
    assign local_x = in_menu ? DrawX : DrawX - BOARD_OFFSET_X;
    assign local_y = in_menu ? DrawY : DrawY - BOARD_OFFSET_Y;
    assign cell_x = local_x / CELL_SIZE;
    assign cell_y = local_y / CELL_SIZE;
    assign pixel_in_cell_x = local_x % CELL_SIZE;
    assign pixel_in_cell_y = local_y % CELL_SIZE;
    assign sprite_pixel_on = (sprite_color != 12'hCCC);
    
    // Area checks
    assign in_title_area = (DrawX >= TITLE_X && DrawX < TITLE_X + TITLE_WIDTH &&
                           DrawY >= TITLE_Y && DrawY < TITLE_Y + TITLE_HEIGHT);
                           
    assign in_text_area = (DrawX >= TEXT_X && DrawX < TEXT_X + TEXT_WIDTH &&
                          DrawY >= TEXT_Y && DrawY < TEXT_Y + TEXT_HEIGHT);
                           
    // ROM address calculations
    assign title_addr = (in_title_area) ? 
        ((DrawY - TITLE_Y) * TITLE_WIDTH + (DrawX - TITLE_X)) : '0;
   
    assign text_addr = (in_text_area) ? 
        ((DrawY - TEXT_Y) * TEXT_WIDTH + (DrawX - TEXT_X)) : '0;
    
    // Sprite pixel scaling
    assign sprite_pixel_x = pixel_in_cell_x[4:1];
    assign sprite_pixel_y = pixel_in_cell_y[4:1];
    
    // Board boundary check
    assign in_board = (local_x < BOARD_SIZE * CELL_SIZE) && 
                     (local_y < BOARD_SIZE * CELL_SIZE) &&
                     (local_x >= 0) && (local_y >= 0);
    
    // Grid line calculation
    always_comb begin
        if (in_menu)
            grid_line = 1'b0;
        else
            grid_line = ((local_x % CELL_SIZE == 0) || (local_y % CELL_SIZE == 0));
    end
    
    // Cursor detection
    assign cursor_on = (cell_x == CursorX && cell_y == CursorY);
    
    // Score digit extraction
   // Score digit extraction - modify this section in color_mapper
    always_comb begin
        // Extract digits for current score (left to right)
        score_digits[0] = current_score / 1000 % 10;        // thousands
        score_digits[1] = (current_score / 100) % 10;       // hundreds
        score_digits[2] = (current_score / 10) % 10;        // tens
        score_digits[3] = current_score % 10;               // ones
        
        // Extract digits for high score (left to right)
        high_score_digits[0] = high_score / 1000 % 10;
        high_score_digits[1] = (high_score / 100) % 10;
        high_score_digits[2] = (high_score / 10) % 10;
        high_score_digits[3] = high_score % 10;
    end
    
    // Score display area check and digit selection
    always_comb begin
        in_score_area = 0;
        current_digit_id = 0;
        score_pixel_x = 0;
        score_pixel_y = 0;
        
        // Check current score area, keep left-to-right order
        for (int i = 0; i < 4; i++) begin
            if (DrawX >= (SCORE_X + i * DIGIT_WIDTH) && 
                DrawX < (SCORE_X + (i + 1) * DIGIT_WIDTH) &&
                DrawY >= SCORE_Y && 
                DrawY < (SCORE_Y + DIGIT_HEIGHT)) begin
                in_score_area = 1;
                current_digit_id = score_digits[i];  // Keep same order as extraction
                score_pixel_x = DrawX - (SCORE_X + i * DIGIT_WIDTH);
                score_pixel_y = DrawY - SCORE_Y;
            end
        end
        
        // Check high score area, keep left-to-right order
        for (int i = 0; i < 4; i++) begin
            if (DrawX >= (SCORE_X + i * DIGIT_WIDTH) && 
                DrawX < (SCORE_X + (i + 1) * DIGIT_WIDTH) &&
                DrawY >= HIGH_SCORE_Y && 
                DrawY < (HIGH_SCORE_Y + DIGIT_HEIGHT)) begin
                in_score_area = 1;
                current_digit_id = high_score_digits[i];  // Keep same order as extraction
                score_pixel_x = DrawX - (SCORE_X + i * DIGIT_WIDTH);
                score_pixel_y = DrawY - HIGH_SCORE_Y;
            end
        end
    end
    
    // Sprite ID logic for game board
    always_comb begin
        if (!in_board)
            current_sprite_id = 4'h0;
        else if (display_state[cell_x][cell_y] & REVEALED) begin
            if (board_state[cell_x][cell_y] & MINE) begin
                if (cell_x == CursorX && cell_y == CursorY && game_over)
                    current_sprite_id = 4'hC;  // Red mine (exploded)
                else
                    current_sprite_id = 4'hB;  // Regular mine
            end
            else if (board_state[cell_x][cell_y][3:0] > 0)
                current_sprite_id = board_state[cell_x][cell_y][3:0] + 4'h1;  // Numbered cell
            else
                current_sprite_id = 4'h1;  // Empty cell
        end
        else if (display_state[cell_x][cell_y] & FLAG)
            current_sprite_id = 4'hA;  // Flag
        else
            current_sprite_id = 4'h0;  // Hidden cell
    end
    
    // Instantiate ROMs and controllers
    sprite_controller sprite_ctrl (
        .clk(clk),
        .sprite_id(current_sprite_id),
        .pixel_x(sprite_pixel_x),
        .pixel_y(sprite_pixel_y),
        .pixel_color(sprite_color)
    );
    
    title_rom title_rom_inst (
        .a(title_addr),
        .spo(title_pixel)
    );
    
    text_rom text_rom_inst (
        .a(text_addr),
        .spo(text_pixel)
    );
    
    score_controller score_display (
        .clk(clk),
        .sprite_id(current_digit_id),
        .pixel_x(score_pixel_x),
        .pixel_y(score_pixel_y),
        .pixel_color(score_color)
    );
    
    // Final color determination logic
    logic [11:0] cell_color;
    always_comb begin
        if (in_menu) begin
            if (in_title_area)
                cell_color = title_pixel;
            else if (in_text_area)
                cell_color = text_pixel;
            else
                cell_color = 12'hCCC;  // Menu background
        end
        else begin
            if (in_score_area && score_color != 12'hCCC)
                cell_color = score_color;
            else begin
                // Game board display logic
                if (!in_board)
                    cell_color = COLOR_BACKGROUND;
                else if (grid_line)
                    cell_color = COLOR_GRID;
                else if (cursor_on && !sprite_pixel_on)
                    cell_color = COLOR_CURSOR;
                else if (display_state[cell_x][cell_y] & REVEALED)
                    cell_color = sprite_color;
                else if (display_state[cell_x][cell_y] & FLAG)
                    cell_color = sprite_color;
                else
                    cell_color = sprite_color;
                    
                // Apply game state effects
                if (game_over)
                    cell_color = {cell_color[11:8] | 4'h4, cell_color[7:4], cell_color[3:0]};
                else if (victory)
                    cell_color = {cell_color[11:8], cell_color[7:4] | 4'h4, cell_color[3:0]};
            end
        end
    end

    // Output final color
    assign Red = cell_color[11:8];
    assign Green = cell_color[7:4];
    assign Blue = cell_color[3:0];

endmodule