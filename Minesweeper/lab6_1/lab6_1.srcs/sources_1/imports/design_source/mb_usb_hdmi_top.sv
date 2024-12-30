module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
);
    
    // Internal signals
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz;
    logic locked;
    logic [9:0] drawX, drawY;
    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    
    // Minesweeper game signals
    logic [3:0] cursor_x, cursor_y;
    logic [7:0] board_state[16][16];
    logic [7:0] display_state[16][16];
    logic game_over, victory;
    logic [3:0] debug_state;  // New debug signal for game state
    logic in_menu;        // Add this declaration


    
    // Add game clock divider
    logic [15:0] game_clock_div;  // Changed from [19:0] to [15:0]
    logic game_clock;
    
    // Clock divider for game updates - faster now
    always_ff @(posedge Clk) begin
        game_clock_div <= game_clock_div + 1;
    end
    assign game_clock = game_clock_div[15]; // Changed from [19] to [15] for faster updates
    
    // Reset assignment
    assign reset_ah = reset_rtl_0;
    
    // Modified HEX display driver instantiations to show debug info
    hex_driver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({debug_state, keycode0_gpio[7:4], keycode0_gpio[3:0], 4'h0}),  // Show game state and current keycode
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    hex_driver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({4'h0, cursor_x, cursor_y, 4'h0}),  // Show cursor position
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    // Rest of the module remains the same...
    // MicroBlaze block instantiation
    mb_block mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah),  // Active low reset for MicroBlaze
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    // Clock wizard for HDMI timing
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    hdmi_tx_0 vga_to_hdmi (
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        .rst(reset_ah),
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

    // Minesweeper game instance with debug output
    minesweeper minesweeper_instance(
        .Reset(reset_ah),
        .frame_clk(game_clock),
        .keycode(keycode0_gpio[7:0]),
        .CursorX(cursor_x),
        .CursorY(cursor_y),
        .board_state(board_state),
        .display_state(display_state),
        .game_over(game_over),
        .victory(victory),
        .debug_state(debug_state),  // New debug output
        .in_menu(in_menu),
        .current_score(current_score),
        .high_score(high_score)
);
    
    color_mapper color_instance(
        .clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),     
        .CursorX(cursor_x),
        .CursorY(cursor_y),
        .board_state(board_state),
        .display_state(display_state),
        .game_over(game_over),
        .victory(victory),
        .in_menu(in_menu),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .current_score(current_score),
        .high_score(high_score)
    );
    
endmodule