////-------------------------------------------------------------------------
////    Color_Mapper.sv                                                    --
////    Stephen Kempf                                                      --
////    3-1-06                                                             --
////                                                                       --
////    Modified by David Kesler  07-16-2008                               --
////    Translated by Joe Meng    07-07-2013                               --
////    Modified by Zuofu Cheng   08-19-2023                               --
////                                                                       --
////    Fall 2023 Distribution                                             --
////                                                                       --
////    For use with ECE 385 USB + HDMI                                    --
////    University of Illinois ECE Department                              --
////-------------------------------------------------------------------------


//module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
//                       output logic [3:0]  Red, Green, Blue );
    
//    logic ball_on;
	 
// /* Old Ball: Generated square box by checking if the current pixel is within a square of length
//    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
//    if ((DrawX >= BallX - Ball_size) &&
//       (DrawX <= BallX + Ball_size) &&
//       (DrawY >= BallY - Ball_size) &&
//       (DrawY <= BallY + Ball_size))
//       )

//     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
//     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
//     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
//	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
//    assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
  
//    always_comb
//    begin:Ball_on_proc
//        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
//            ball_on = 1'b1;
//        else 
//            ball_on = 1'b0;
//     end 
       
//    always_comb
//    begin:RGB_Display
//        if ((ball_on == 1'b1)) begin 
//            Red = 4'hf;
//            Green = 4'h7;
//            Blue = 4'h0;
//        end       
//        else begin 
//            Red = 4'hf - DrawX[9:6]; 
//            Green = 4'hf - DrawX[9:6];
//            Blue = 4'hf - DrawX[9:6];
//        end      
//    end 
    
//endmodule

// Minesweeper game controller
module minesweeper (
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    
    output logic [3:0]  CursorX,    
    output logic [3:0]  CursorY,    
    output logic [7:0]  board_state[16][16],
    output logic [7:0]  display_state[16][16],
    output logic        game_over,
    output logic        victory
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
    
    logic init_done;
    logic [7:0] mines_placed;
    logic prev_key_state;
    
    // Initialize game board
    function void init_board();
        for (int i = 0; i < BOARD_SIZE; i++) begin
            for (int j = 0; j < BOARD_SIZE; j++) begin
                board_state[i][j] = HIDDEN;
                display_state[i][j] = HIDDEN;
            end
        end
        place_mines();
        calculate_numbers();
        init_done = 1'b1;
    endfunction
    
    // Place mines randomly
    function void place_mines();
        int x, y;
        mines_placed = 0;
        while (mines_placed < MINE_COUNT) begin
            x = $random % BOARD_SIZE;
            y = $random % BOARD_SIZE;
            if (board_state[x][y] != MINE) begin
                board_state[x][y] = MINE;
                mines_placed = mines_placed + 1;
            end
        end
    endfunction
    
    // Calculate numbers for each cell
    function void calculate_numbers();
        for (int i = 0; i < BOARD_SIZE; i++) begin
            for (int j = 0; j < BOARD_SIZE; j++) begin
                if (board_state[i][j] != MINE) begin
                    board_state[i][j] = count_adjacent_mines(i, j);
                end
            end
        end
    endfunction
    
    // Count adjacent mines
    function logic [7:0] count_adjacent_mines(int x, int y);
        logic [7:0] count = 0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if (x+i >= 0 && x+i < BOARD_SIZE && y+j >= 0 && y+j < BOARD_SIZE) begin
                    if (board_state[x+i][y+j] == MINE) count++;
                end
            end
        end
        return count;
    endfunction

    // Reveal cell and adjacent empty cells
    function void reveal_cell(int x, int y);
        if (x < 0 || x >= BOARD_SIZE || y < 0 || y >= BOARD_SIZE)
            return;
            
        if (display_state[x][y] != HIDDEN)
            return;
            
        display_state[x][y] = REVEALED | board_state[x][y];
        
        // If empty cell, reveal neighbors
        if (board_state[x][y] == 0) begin
            for (int i = -1; i <= 1; i++) begin
                for (int j = -1; j <= 1; j++) begin
                    reveal_cell(x+i, y+j);
                end
            end
        end
    endfunction
    
    // Reveal all mines when game is lost
    function void reveal_all_mines();
        for (int i = 0; i < BOARD_SIZE; i++) begin
            for (int j = 0; j < BOARD_SIZE; j++) begin
                if (board_state[i][j] == MINE)
                    display_state[i][j] = REVEALED | MINE;
            end
        end
    endfunction
    
    // Check for victory
    function void check_victory();
        logic won = 1;
        for (int i = 0; i < BOARD_SIZE; i++) begin
            for (int j = 0; j < BOARD_SIZE; j++) begin
                if (board_state[i][j] != MINE && 
                    !(display_state[i][j] & REVEALED)) begin
                    won = 0;
                    break;
                end
            end
        end
        victory = won;
    endfunction
    
    // Main game logic
    always_ff @(posedge frame_clk) begin
        if (Reset) begin
            CursorX <= 4'd8;
            CursorY <= 4'd8;
            game_over <= 0;
            victory <= 0;
            init_done <= 0;
            prev_key_state <= 0;
            init_board();
        end
        else begin
            // Handle keyboard input
            if (keycode != 8'h00 && !prev_key_state) begin
                case (keycode)
                    KEY_W: if (CursorY > 0) CursorY <= CursorY - 1;
                    KEY_S: if (CursorY < BOARD_SIZE-1) CursorY <= CursorY + 1;
                    KEY_A: if (CursorX > 0) CursorX <= CursorX - 1;
                    KEY_D: if (CursorX < BOARD_SIZE-1) CursorX <= CursorX + 1;
                    KEY_SPACE: if (!game_over) begin
                        if (board_state[CursorX][CursorY] == MINE) begin
                            game_over <= 1;
                            reveal_all_mines();
                        end
                        else if (display_state[CursorX][CursorY] == HIDDEN) begin
                            reveal_cell(CursorX, CursorY);
                            check_victory();
                        end
                    end
                    KEY_F: if (!game_over) begin
                        if (display_state[CursorX][CursorY] == HIDDEN)
                            display_state[CursorX][CursorY] = FLAG;
                        else if (display_state[CursorX][CursorY] == FLAG)
                            display_state[CursorX][CursorY] = HIDDEN;
                    end
                endcase
            end
            
            prev_key_state <= (keycode != 8'h00);
        end
    end

endmodule