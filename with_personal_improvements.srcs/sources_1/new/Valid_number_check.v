`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2023 16:57:39
// Design Name: 
// Module Name: Valid_number_check
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


module Valid_number_check(
        input clock,
        input is_valid_number,
        input [6:0] oled_seg,
        input sw,
        output [6:0] seg,
        output [3:0] an,
        output dp,
        output led
    );

    parameter ZERO = 7'b1000000;
    parameter ONE = 7'b1111001;
    parameter TWO = 7'b0100100;
    parameter THREE = 7'b0110000;
    parameter FOUR = 7'b0011001;
    parameter FIVE = 7'b0010010;
    parameter SIX = 7'b0000010;
    parameter SEVEN = 7'b1111000;
    parameter EIGHT = 7'b0000000;
    parameter NINE = 7'b0010000;

    reg [19:0] refresh_counter;
    wire [1:0] LED_activating_counter;
    reg [6:0] valid_seg;
    reg [3:0] valid_an;
    reg valid_dp;

  //  assign led = is_valid_number && sw;

    always @(posedge clock) begin 
        refresh_counter <= refresh_counter + 1;
    end

    assign LED_activating_counter = refresh_counter[19];

    always @ (*) begin
        if (is_valid_number && LED_activating_counter) begin
            valid_seg = oled_seg == ~NINE ? ONE : ZERO;
            valid_an = 4'b0111;
            valid_dp = 0;
        end else if (is_valid_number && !LED_activating_counter) begin
            valid_seg = oled_seg == ~ZERO ? ONE
                : oled_seg == ~ONE ? TWO
                : oled_seg == ~TWO ? THREE
                : oled_seg == ~THREE ? FOUR
                : oled_seg == ~FOUR ? FIVE
                : oled_seg == ~FIVE ? SIX
                : oled_seg == ~SIX ? SEVEN
                : oled_seg == ~SEVEN ? EIGHT
                : oled_seg == ~EIGHT ? NINE
                : ZERO;
            valid_an = 4'b1011;
            valid_dp = 1;
        end else begin
            valid_seg = 7'b1111111;
            valid_an = 4'b1111;
        end
    end
    
    assign seg = valid_seg;
    assign an = valid_an;
    assign dp = valid_dp;

endmodule
