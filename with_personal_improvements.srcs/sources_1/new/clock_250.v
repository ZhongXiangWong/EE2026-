`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 21:51:31
// Design Name: 
// Module Name: clcok_250
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


module clock_250(input clock, output reg signal = 1'b0);
    reg [19:0] counter = 19'b0;
    reg [19:0] counter_clk250 = 19'b1100001101010000000 >> 1;   
    
    always @ (posedge clock) begin
        counter <= (counter == counter_clk250) ? 0 : counter + 1;
        signal <= (counter == 0) ? ~signal : signal;
    end
    
endmodule
