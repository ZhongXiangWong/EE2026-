`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2023 15:48:38
// Design Name: 
// Module Name: pixelToXY
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


module pixelToXY(
        input [12:0] oled_pixel_index,
        output [6:0] X,
        output [6:0] Y
    );
    
    parameter DISPLAY_WIDTH = 96;
    
    assign X = oled_pixel_index % DISPLAY_WIDTH;
    assign Y = oled_pixel_index / DISPLAY_WIDTH;
    
endmodule
