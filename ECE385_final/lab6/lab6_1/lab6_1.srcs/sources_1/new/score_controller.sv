`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 11:44:32
// Design Name: 
// Module Name: score_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 09:26:09
// Design Name: 
// Module Name: score_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module score_controller (
    input  logic        clk,          
    input  logic [3:0]  sprite_id,    // Which digit to show (0-9)
    input  logic [3:0]  pixel_x,      // 0-12 (13 pixels wide)
    input  logic [4:0]  pixel_y,      // 0-22 (23 pixels high) - Note: Changed to 5 bits to accommodate 0-22
    output logic [11:0] pixel_color   
);
    // Constants for sprite dimensions
    parameter DIGIT_WIDTH = 13;
    parameter DIGIT_HEIGHT = 23;
    
    // Calculate ROM address based on sprite_id and pixel position
    logic [11:0] rom_addr;
    logic valid_pixel;
    
    // Check if the requested pixel is within the digit's bounds
    always_comb begin
        // Validate pixel coordinates
        valid_pixel = (pixel_x < DIGIT_WIDTH) && (pixel_y < DIGIT_HEIGHT);
        
        if (valid_pixel) begin
            // Each digit occupies DIGIT_WIDTH * DIGIT_HEIGHT = 13 * 23 = 299 pixels
            rom_addr = (sprite_id * (DIGIT_WIDTH * DIGIT_HEIGHT)) + 
                      (pixel_y * DIGIT_WIDTH) + pixel_x;
        end else begin
            rom_addr = '0;
        end
    end
    
    // Instantiate the ROM
    score_rom rom_inst (
        .a(rom_addr),
        .spo(pixel_color)    
    );

endmodule
