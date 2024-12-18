module minesweeper (
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    
    output logic [3:0]  CursorX,    
    output logic [3:0]  CursorY,    
    output logic [7:0]  board_state[16][16],
    output logic [7:0]  display_state[16][16],
    output logic        game_over,
    output logic        victory,
    output logic [3:0]  debug_state,
    output logic        in_menu,
    output logic [15:0] current_score,
    output logic [15:0] high_score
);
    // Game configuration
    parameter BOARD_SIZE = 16;
    parameter MINE_COUNT = 40;
    
    // Cell state definitions
    parameter logic [7:0] HIDDEN = 8'h00;
    parameter logic [7:0] MINE = 8'h80;
    parameter logic [7:0] FLAG = 8'h40;
    parameter logic [7:0] REVEALED = 8'h20;
    
    // Keyboard scancodes
    parameter logic [7:0] KEY_W = 8'h1A;
    parameter logic [7:0] KEY_S = 8'h16;
    parameter logic [7:0] KEY_A = 8'h04;
    parameter logic [7:0] KEY_D = 8'h07;
    parameter logic [7:0] KEY_SPACE = 8'h2C;
    parameter logic [7:0] KEY_F = 8'h09;
    parameter logic [7:0] KEY_ENTER = 8'h28;
    
    // Game state variables
    logic [7:0] mines_placed;
    logic [3:0] init_x, init_y;
    logic [3:0] count_x, count_y, adj_x, adj_y;
    logic [7:0] mine_count;
    logic prev_keycode_valid;
    logic [7:0] prev_keycode;
    
    // Randomization
    logic [15:0] lfsr;
    logic [31:0] random_counter;
    logic [15:0] lfsr2;
    logic [3:0] next_x;
    logic [3:0] next_y;
    logic signed [4:0] dx, dy;
    
    // Queue for empty cells
    logic [3:0] empty_queue_x[256];
    logic [3:0] empty_queue_y[256];
    logic [7:0] empty_queue_front;
    logic [7:0] empty_queue_back;
    logic empty_queue_empty;
    
    // Current cell processing
    logic [3:0] current_x;
    logic [3:0] current_y;
    logic [2:0] neighbor_index;
    logic valid_direction;
    
    // Add score tracking
    logic [7:0] cells_to_score;
    
    // Game state machine
    enum logic [3:0] {
        MENU_STATE = 4'h0,
        INIT_CLEAR = 4'h1,
        PLACE_MINES = 4'h2,
        COUNT_MINES = 4'h3,
        CHECK_ADJACENT = 4'h4,
        GAME_READY = 4'h5,
        PROCESS_EMPTY_CELLS = 4'h6,    
        CHECK_NEIGHBORS = 4'h7
    } init_state;

    // Assign debug output
    assign debug_state = init_state;
    assign in_menu = (init_state == MENU_STATE);
    
    // Helper function to check if coordinates are valid
    function automatic logic is_valid_coord;
        input logic [3:0] x, y;
        begin
            is_valid_coord = (x < BOARD_SIZE && y < BOARD_SIZE);
        end
    endfunction
    
    // Modified reveal process
    task automatic start_reveal;
        input logic [3:0] x, y;
        begin
            if (board_state[x][y] == 0) begin
                // If starting cell is empty, initialize queue
                empty_queue_front <= 0;
                empty_queue_back <= 1;
                empty_queue_empty <= 0;
                empty_queue_x[0] <= x;
                empty_queue_y[0] <= y;
                
                display_state[x][y] <= REVEALED;
                cells_to_score <= 1;
                current_score <= current_score + 5;
                
                init_state <= PROCESS_EMPTY_CELLS;
            end
            else begin
                // If not empty, just reveal it
                display_state[x][y] <= REVEALED | board_state[x][y];
                cells_to_score <= 1;
                current_score <= current_score + 5;
                init_state <= GAME_READY;
            end
        end
    endtask

    // Game initialization and main logic
    always_ff @(posedge frame_clk) begin
        if (Reset || keycode == 8'h29) begin
            // Reset to menu state
            init_state <= MENU_STATE;
            init_x <= 0;
            init_y <= 0;
            mines_placed <= 0;
            cells_to_score <= 0;
            
            // Reset random number generators
            lfsr <= 16'hACE1;
            lfsr2 <= 16'hB00B;
            random_counter <= 0;
            
            // Reset cursor and game state
            CursorX <= 4'd8;
            CursorY <= 4'd8;
            game_over <= 0;
            victory <= 0;
            
            // Reset input tracking
            prev_keycode_valid <= 0;
            prev_keycode <= 8'h00;
            
            // Reset queue
            empty_queue_front <= 0;
            empty_queue_back <= 0;
            empty_queue_empty <= 1;
            neighbor_index <= 0;
            
            // Reset scoring system
            current_score <= 0;
            
            if (!Reset) begin  // Keep high score unless it's a hard reset
                high_score <= high_score;
            end else begin
                high_score <= 0;
            end
            
            // Clear board
            for (int i = 0; i < BOARD_SIZE; i++) begin
                for (int j = 0; j < BOARD_SIZE; j++) begin
                    board_state[i][j] <= HIDDEN;
                    display_state[i][j] <= HIDDEN;
                end
            end
        end
        else begin
            cells_to_score <= 0;  // Reset counter each cycle
            
            // Update random number generators
            random_counter <= random_counter + 1;
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[14] ^ lfsr[12] ^ lfsr[3]};
            lfsr2 <= {lfsr2[14:0], lfsr2[15] ^ lfsr2[13] ^ lfsr2[11] ^ lfsr2[2]};
            
            // Handle keyboard input
            if (keycode != 8'h00 && (!prev_keycode_valid || keycode != prev_keycode)) begin
                if (init_state == MENU_STATE) begin
                    if (keycode == KEY_ENTER) begin
                        init_state <= INIT_CLEAR;
                    end
                end
                else begin
                    case (keycode)
                        KEY_W: if (CursorY > 0) CursorY <= CursorY - 1;
                        KEY_S: if (CursorY < BOARD_SIZE-1) CursorY <= CursorY + 1;
                        KEY_A: if (CursorX > 0) CursorX <= CursorX - 1;
                        KEY_D: if (CursorX < BOARD_SIZE-1) CursorX <= CursorX + 1;
                        
                        KEY_SPACE: begin
                            if (!game_over && !victory && 
                                display_state[CursorX][CursorY] != FLAG) begin
                                if (board_state[CursorX][CursorY] == MINE) begin
                                    game_over <= 1;
                                    current_score <= 0;
                                    for (int i = 0; i < BOARD_SIZE; i++) begin
                                        for (int j = 0; j < BOARD_SIZE; j++) begin
                                            if (board_state[i][j] == MINE)
                                                display_state[i][j] <= REVEALED | MINE;
                                        end
                                    end
                                end
                                else if (display_state[CursorX][CursorY] != REVEALED) begin
                                    start_reveal(CursorX, CursorY);
                                end
                            end
                        end
                        
                        KEY_F: begin
                            if (!game_over && !victory) begin
                                if (display_state[CursorX][CursorY] == HIDDEN) begin
                                    display_state[CursorX][CursorY] <= FLAG;
                                    current_score <= (current_score >= 5) ? current_score - 5 : 0;
                                end
                                else if (display_state[CursorX][CursorY] == FLAG) begin
                                    display_state[CursorX][CursorY] <= HIDDEN;
                                    current_score <= current_score + 5;
                                end
                            end
                        end
                    endcase
                end
            end
            
            prev_keycode_valid <= (keycode != 8'h00);
            prev_keycode <= keycode;
            
            // State machine
            case (init_state)
                INIT_CLEAR: begin
                    init_state <= PLACE_MINES;
                end
                
                PLACE_MINES: begin
                    if (mines_placed < MINE_COUNT) begin
                        init_x <= ((lfsr[3:0] ^ lfsr2[3:0] ^ random_counter[3:0]) % BOARD_SIZE);
                        init_y <= ((lfsr[7:4] ^ lfsr2[7:4] ^ random_counter[7:4]) % BOARD_SIZE);
                        
                        if (board_state[init_x][init_y] != MINE) begin
                            board_state[init_x][init_y] <= MINE;
                            mines_placed <= mines_placed + 1;
                        end
                    end
                    else begin
                        init_state <= COUNT_MINES;
                        count_x <= 0;
                        count_y <= 0;
                    end
                end
                
                COUNT_MINES: begin
                    if (board_state[count_x][count_y] != MINE) begin
                        mine_count <= 0;
                        init_state <= CHECK_ADJACENT;
                        adj_x <= 0;
                        adj_y <= 0;
                    end
                    else begin
                        if (count_x == BOARD_SIZE-1 && count_y == BOARD_SIZE-1)
                            init_state <= GAME_READY;
                        else if (count_x == BOARD_SIZE-1) begin
                            count_x <= 0;
                            count_y <= count_y + 1;
                        end
                        else
                            count_x <= count_x + 1;
                    end
                end
                
                CHECK_ADJACENT: begin
                    if (adj_x < 3) begin
                        if (adj_y < 3) begin
                            int curr_x = count_x + adj_x - 1;
                            int curr_y = count_y + adj_y - 1;
                            
                            if (curr_x >= 0 && curr_x < BOARD_SIZE && 
                                curr_y >= 0 && curr_y < BOARD_SIZE) begin
                                if (board_state[curr_x][curr_y] == MINE)
                                    mine_count <= mine_count + 1;
                            end
                            adj_y <= adj_y + 1;
                        end
                        else begin
                            adj_x <= adj_x + 1;
                            adj_y <= 0;
                        end
                    end
                    else begin
                        board_state[count_x][count_y] <= mine_count;
                        
                        if (count_x == BOARD_SIZE-1 && count_y == BOARD_SIZE-1)
                            init_state <= GAME_READY;
                        else begin
                            init_state <= COUNT_MINES;
                            if (count_x == BOARD_SIZE-1) begin
                                count_x <= 0;
                                count_y <= count_y + 1;
                            end
                            else
                                count_x <= count_x + 1;
                        end
                    end
                end
                
                PROCESS_EMPTY_CELLS: begin
                    if (!empty_queue_empty) begin
                        current_x <= empty_queue_x[empty_queue_front];
                        current_y <= empty_queue_y[empty_queue_front];
                        neighbor_index <= 0;
                        init_state <= CHECK_NEIGHBORS;
                    end
                    else begin
                        init_state <= GAME_READY;
                    end
                end
                
                CHECK_NEIGHBORS: begin
                    if (neighbor_index < 8) begin
                        case (neighbor_index)
                            0: begin dx = -1; dy = -1; end
                            1: begin dx = -1; dy = 0; end
                            2: begin dx = -1; dy = 1; end
                            3: begin dx = 0; dy = -1; end
                            4: begin dx = 0; dy = 1; end
                            5: begin dx = 1; dy = -1; end
                            6: begin dx = 1; dy = 0; end
                            7: begin dx = 1; dy = 1; end
                            default: begin dx = 0; dy = 0; end
                        endcase
                        
                        valid_direction = 1'b1;
                        
                        if (current_x == 0 && dx < 0) valid_direction = 1'b0;
                        if (current_x == BOARD_SIZE-1 && dx > 0) valid_direction = 1'b0;
                        if (current_y == 0 && dy < 0) valid_direction = 1'b0;
                        if (current_y == BOARD_SIZE-1 && dy > 0) valid_direction = 1'b0;
                        
                        if (valid_direction) begin
                            next_x = current_x + dx;
                            next_y = current_y + dy;
                            
                            if (display_state[next_x][next_y] == HIDDEN) begin
                                if (board_state[next_x][next_y] == 0) begin
                                    empty_queue_x[empty_queue_back] <= next_x;
                                    empty_queue_y[empty_queue_back] <= next_y;
                                    empty_queue_back <= empty_queue_back + 1;
                                    empty_queue_empty <= 0;
                                    display_state[next_x][next_y] <= REVEALED;
                                    current_score <= current_score + 5;
                                    cells_to_score <= cells_to_score + 1;
                                end
                                else if (board_state[next_x][next_y] != MINE) begin
                                    display_state[next_x][next_y] <= REVEALED | board_state[next_x][next_y];
                                    current_score <= current_score + 5;
                                    cells_to_score <= cells_to_score + 1;
                                end
                            end
                        end
                        
                        neighbor_index <= neighbor_index + 1;
                    end
                    else begin
                        empty_queue_front <= empty_queue_front + 1;
                        empty_queue_empty <= (empty_queue_front + 1 == empty_queue_back);
                        init_state <= PROCESS_EMPTY_CELLS;
                    end
                end
                
                GAME_READY: begin
                    // Check for victory condition
                    logic temp_victory = 1;
                    
                    // Only check for victory if game is still active
                    if (!game_over) begin
                        for (int i = 0; i < BOARD_SIZE; i++) begin
                            for (int j = 0; j < BOARD_SIZE; j++) begin
                                if (board_state[i][j] != MINE && 
                                    !(display_state[i][j] & REVEALED)) begin
                                    temp_victory = 0;
                                end
                            end
                        end
                        
                        // If victory is achieved
                        if (temp_victory && !victory) begin
                            // Update high score if current score is higher
                            if (current_score > high_score)
                                high_score <= current_score;
                                
                            // Set victory flag
                            victory <= 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule