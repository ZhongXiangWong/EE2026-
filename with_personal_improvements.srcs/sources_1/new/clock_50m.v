`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 21:49:17
// Design Name: 
// Module Name: clock_50m
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


module clock_50m(input clock, output reg signal = 1'b0);
    
    always @ (posedge clock) begin
        signal <= ~signal;
    end
    
endmodule