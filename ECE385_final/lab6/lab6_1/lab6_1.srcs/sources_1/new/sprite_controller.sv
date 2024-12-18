`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 17:28:40
// Design Name: 
// Module Name: sprite_controller
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

module sprite_controller (
    input  logic        clk,          
    input  logic [3:0]  sprite_id,    // Which sprite to show (0-11, supporting 12 sprites)
    input  logic [3:0]  pixel_x,      
    input  logic [3:0]  pixel_y,      
    output logic [11:0] pixel_color   
);
    // Calculate ROM address based on sprite_id and pixel position
    logic [11:0] rom_addr;  // Increased to 12 bits to support all sprites (12 sprites * 256 pixels each)
    
    // Use a larger intermediate value for multiplication to avoid truncation
    assign rom_addr = ({8'd0, sprite_id} * 'd256) + ({8'd0, pixel_y} * 'd16) + pixel_x;
    
    // Instantiate the ROM IP without clock
    sprite_rom rom_inst (
        .a(rom_addr),        // Address input needs to match your ROM IP configuration
        .spo(pixel_color)    
    );
endmodule