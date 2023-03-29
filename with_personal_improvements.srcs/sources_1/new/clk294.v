`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2023 22:04:22
// Design Name: 
// Module Name: clk294
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


module clk294(input clock, output reg signal = 1'b0);
    reg [18:0] counter = 19'b0;
    reg [18:0] counter_clk = 19'b1010011000010101000 >> 1;  
    
    always @ (posedge clock) begin
        counter <= (counter == counter_clk) ? 0 : counter + 1;
        signal <= (counter == 0) ? ~signal : signal;
    end
endmodule

