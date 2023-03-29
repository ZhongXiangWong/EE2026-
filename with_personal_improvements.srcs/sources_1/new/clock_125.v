`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 21:50:40
// Design Name: 
// Module Name: clock_125
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


module clock_125(input clock, output reg signal = 1'b0);
    reg [19:0] counter = 18'b0;
    reg [19:0] counter_clk125 = 18'b110000110101000000 >> 1;   
    
    always @ (posedge clock) begin
        counter <= (counter == counter_clk125) ? 0 : counter + 1;
        signal <= (counter == 0) ? ~signal : signal;
    end
    
endmodule
