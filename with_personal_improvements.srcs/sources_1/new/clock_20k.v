`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 21:49:58
// Design Name: 
// Module Name: clock_20k
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


module clock_20k(input clock, output reg signal = 1'b0);
    reg [8:0] counter = 9'b0;
    reg [8:0] counter_clk20k = 9'b111110100 >> 1;  
    
    always @ (posedge clock) begin
        counter <= (counter == counter_clk20k) ? 0 : counter + 1;
        signal <= (counter == 0) ? ~signal : signal;
    end
endmodule

    

