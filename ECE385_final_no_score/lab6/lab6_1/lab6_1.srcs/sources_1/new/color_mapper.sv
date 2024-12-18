module color_mapper (
    input  logic        clk,          
    input  logic [9:0]  DrawX, DrawY,
    input  logic [3:0]  CursorX, CursorY,
    input  logic [7:0]  board_state[16][16],
    input  logic [7:0]  display_state[16][16],
    input  logic        game_over,
    input  logic        victory,
    input  logic        in_menu,      
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
    
    // Title logo parameters - corrected for actual ROM dimensions
    parameter TITLE_WIDTH = 320;    // Actual width from COE
    parameter TITLE_HEIGHT = 59;   // Actual height from COE
    parameter TITLE_X = 160;       // Center on screen (640/2 - TITLE_WIDTH/2)
    parameter TITLE_Y = 130;       // Position from top
    
    parameter TEXT_WIDTH = 280;    // Actual width from COE
    parameter TEXT_HEIGHT = 15;   // Actual height from COE
    parameter TEXT_X = 180;       // Center on screen (640/2 - TITLE_WIDTH/2)
    parameter TEXT_Y = 300;       // Position from top
    
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
    
    // Title area check with corrected dimensions
    assign in_title_area = (DrawX >= TITLE_X && DrawX < TITLE_X + TITLE_WIDTH &&
                           DrawY >= TITLE_Y && DrawY < TITLE_Y + TITLE_HEIGHT);
                           
    assign in_text_area = (DrawX >= TEXT_X && DrawX < TEXT_X + TEXT_WIDTH &&
                           DrawY >= TEXT_Y && DrawY < TEXT_Y + TEXT_HEIGHT);
                           
    // Title ROM address calculation with corrected width
    assign title_addr = (in_title_area) ? 
        ((DrawY - TITLE_Y) * TITLE_WIDTH + (DrawX - TITLE_X)) : '0;
   
    assign text_addr = (in_text_area) ? 
        ((DrawY - TEXT_Y) * TEXT_WIDTH + (DrawX - TEXT_X)) : '0;
    
    // Scale from 30x30 cell to 16x16 sprite
    assign sprite_pixel_x = pixel_in_cell_x[4:1];
    assign sprite_pixel_y = pixel_in_cell_y[4:1];
    
    // Board boundary checks
    assign in_board = (local_x < BOARD_SIZE * CELL_SIZE) && 
                     (local_y < BOARD_SIZE * CELL_SIZE) &&
                     (local_x >= 0) && (local_y >= 0);
    
    // Grid line calculation with menu check
    always_comb begin
        if (in_menu)
            grid_line = 1'b0;  // No grid lines in menu
        else
            grid_line = ((local_x % CELL_SIZE == 0) || (local_y % CELL_SIZE == 0));
    end
    
    // Cursor detection
    assign cursor_on = (cell_x == CursorX && cell_y == CursorY);
    
    // Sprite ID logic
    always_comb begin
        if (!in_board)
            current_sprite_id = 4'h0;
        else if (display_state[cell_x][cell_y] & REVEALED) begin
            if (board_state[cell_x][cell_y] & MINE) begin
                if (cell_x == CursorX && cell_y == CursorY && game_over)
                    current_sprite_id = 4'hC;
                else
                    current_sprite_id = 4'hB;
            end
            else if (board_state[cell_x][cell_y][3:0] > 0)
                current_sprite_id = board_state[cell_x][cell_y][3:0] + 4'h1;
            else
                current_sprite_id = 4'h1;
        end
        else if (display_state[cell_x][cell_y] & FLAG)
            current_sprite_id = 4'hA;
        else
            current_sprite_id = 4'h0;
    end
    
    // Instantiate ROMs
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
    
    // Color determination logic
    logic [11:0] cell_color;
    always_comb begin
        if (in_menu) begin
            if (in_title_area)
                cell_color = title_pixel; // Use ROM data directly
            else if (in_text_area)
                cell_color = text_pixel;
            else
                cell_color = 12'hCCC;  // Black background for non-title area
        end
        else begin
            // Game display logic
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

    // Output final color
    assign Red = cell_color[11:8];
    assign Green = cell_color[7:4];
    assign Blue = cell_color[3:0];

endmodule