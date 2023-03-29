`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2023 21:46:48
// Design Name: 
// Module Name: clk440
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


module clk440(input clock, output reg signal = 1'b0);
    reg [17:0] counter = 18'b0;
    reg [17:0] counter_clk = 18'b110111011111001000 >> 1;  
    
    always @ (posedge clock) begin
        counter <= (counter == counter_clk) ? 0 : counter + 1;
        signal <= (counter == 0) ? ~signal : signal;
    end
endmodule
