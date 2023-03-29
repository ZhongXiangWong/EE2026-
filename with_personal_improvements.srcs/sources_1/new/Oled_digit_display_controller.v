`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2023 18:30:35
// Design Name: 
// Module Name: Oled_digit_display_controller
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


module Oled_digit_display_controller(
        input [6:0] mouse_click_seg,
        input [8:0] sw,
        output [6:0] oled_seg,
        output is_valid_number
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

    wire [6:0] switch_seg = sw[8] ?
        ~NINE
        : sw[7] ? ~EIGHT
        : sw[6] ? ~SEVEN
        : sw[5] ? ~SIX
        : sw[4] ? ~FIVE
        : sw[3] ? ~FOUR
        : sw[2] ? ~THREE
        : sw[1] ? ~TWO
        : sw[0] ? ~ONE
        : 7'b0;

    assign oled_seg = mouse_click_seg | switch_seg;
    assign is_valid_number = oled_seg == ~ZERO
        || oled_seg == ~ONE
        || oled_seg == ~TWO
        || oled_seg == ~THREE
        || oled_seg == ~FOUR
        || oled_seg == ~FIVE
        || oled_seg == ~SIX
        || oled_seg == ~SEVEN
        || oled_seg == ~EIGHT
        || oled_seg == ~NINE;


endmodule
