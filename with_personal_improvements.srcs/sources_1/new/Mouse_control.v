`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2023 16:23:43
// Design Name: 
// Module Name: Mouse_control
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


module Mouse_control(
        input clock,
        input ps2_clk,
        input ps2_data,
        input [6:0] X,
        input [6:0] Y,
        output [15:0] oled_data,
        output [6:0] mouse_click_seg
    );
    // Segment filled configurations
    parameter SEGMENT_LEN = 22;
    parameter SEGMENT_WIDTH = 5;
    parameter SEG_ONE_START_PIXEL_X = 18;
    parameter SEG_ONE_START_PIXEL_Y = 3;
    parameter SEG_TWO_START_PIXEL_X = 40;
    parameter SEG_TWO_START_PIXEL_Y = 3; // 4 + 3 + 1
    parameter SEG_THREE_START_PIXEL_X = 40;
    parameter SEG_THREE_START_PIXEL_Y = 30; // 4 + 3 + 1 + 20 + 1 + 1
    parameter SEG_FOUR_START_PIXEL_X = 18;
    parameter SEG_FOUR_START_PIXEL_Y = 52;
    parameter SEG_FIVE_START_PIXEL_X = 13;
    parameter SEG_FIVE_START_PIXEL_Y = 30;
    parameter SEG_SIX_START_PIXEL_X = 13;
    parameter SEG_SIX_START_PIXEL_Y = 8;
    parameter SEG_SEVEN_START_PIXEL_X = 18;
    parameter SEG_SEVEN_START_PIXEL_Y = 27;

    // mouse
    reg [6:0] click_state = 7'b0;
    reg sety = 0;
    reg setx = 0;
    reg setmax_x = 0;
    reg setmax_y = 0;
    reg value = 12'b0;
    reg rst = 0;
    wire left, middle, right, new_event;
    wire [11:0] mouse_xpos, mouse_ypos;
    wire [3:0] mouse_zpos;
    wire [9:0] mouse_x, mouse_y;

    MouseCtl mc(
        .clk(clock),
        .rst(rst),
        .setx(setx),
        .sety(sety),
        .setmax_x(setmax_x),
        .setmax_y(setmax_y),
        .value(value),
        .xpos(mouse_xpos),
        .ypos(mouse_ypos),
        .zpos(mouse_zpos),
        .left(left),
        .right(right),
        .middle(middle),
        .new_event(new_event),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data)
    );

    // mouse coordinates
    assign mouse_x = mouse_xpos[11:3];
    assign mouse_y = mouse_ypos[11:3];

    assign oled_data[15:0] = (middle && (X >= mouse_x -2) && (X <= mouse_x + 2) && (Y >= mouse_y - 2) && (Y <= mouse_y +2)) ? 16'hF000 :
        (((X == mouse_x) && (Y == mouse_y)) ? 16'h07E0 : 16'b0);

    wire is_seg_one = SEG_ONE_START_PIXEL_X <= X && X < SEG_ONE_START_PIXEL_X + SEGMENT_LEN && SEG_ONE_START_PIXEL_Y <= Y && Y < SEG_ONE_START_PIXEL_Y + SEGMENT_WIDTH;
    wire is_seg_two = SEG_TWO_START_PIXEL_X <= X && X < SEG_TWO_START_PIXEL_X + SEGMENT_WIDTH && SEG_TWO_START_PIXEL_Y <= Y && Y < SEG_TWO_START_PIXEL_Y + SEGMENT_LEN;
    wire is_seg_three = SEG_THREE_START_PIXEL_X <= X && X < SEG_THREE_START_PIXEL_X + SEGMENT_WIDTH && SEG_THREE_START_PIXEL_Y <= Y && Y < SEG_THREE_START_PIXEL_Y + SEGMENT_LEN;
    wire is_seg_four = SEG_FOUR_START_PIXEL_X <= X && X < SEG_FOUR_START_PIXEL_X + SEGMENT_LEN && SEG_FOUR_START_PIXEL_Y <= Y && Y < SEG_FOUR_START_PIXEL_Y + SEGMENT_WIDTH;
    wire is_seg_five = SEG_FIVE_START_PIXEL_X <= X && X < SEG_FIVE_START_PIXEL_X + SEGMENT_WIDTH && SEG_FIVE_START_PIXEL_Y <= Y && Y < SEG_FIVE_START_PIXEL_Y + SEGMENT_LEN;
    wire is_seg_six = SEG_SIX_START_PIXEL_X <= X && X < SEG_SIX_START_PIXEL_X + SEGMENT_WIDTH && SEG_SIX_START_PIXEL_Y <= Y && Y < SEG_SIX_START_PIXEL_Y + SEGMENT_LEN;
    wire is_seg_seven = SEG_SEVEN_START_PIXEL_X <= X && X < SEG_SEVEN_START_PIXEL_X + SEGMENT_LEN && SEG_SEVEN_START_PIXEL_Y <= Y && Y < SEG_SEVEN_START_PIXEL_Y + SEGMENT_WIDTH;

    always @ (*) begin
        if (X == mouse_x && Y == mouse_y) begin
            if (SEG_ONE_START_PIXEL_X <= X && X < SEG_ONE_START_PIXEL_X + SEGMENT_LEN && SEG_ONE_START_PIXEL_Y <= Y && Y < SEG_ONE_START_PIXEL_Y + SEGMENT_WIDTH) begin
                click_state[0] = left ? 1 : right ? 0 : click_state[0];
            end else if (SEG_FOUR_START_PIXEL_X <= X && X < SEG_FOUR_START_PIXEL_X + SEGMENT_LEN && SEG_FOUR_START_PIXEL_Y <= Y && Y < SEG_FOUR_START_PIXEL_Y + SEGMENT_WIDTH) begin
                click_state[3] = left ? 1 : right ? 0 : click_state[3];
            end else if (SEG_SEVEN_START_PIXEL_X <= X && X < SEG_SEVEN_START_PIXEL_X + SEGMENT_LEN && SEG_SEVEN_START_PIXEL_Y <= Y && Y < SEG_SEVEN_START_PIXEL_Y + SEGMENT_WIDTH) begin
                click_state[6] = left ? 1 : right ? 0 : click_state[6];
            end else if (SEG_TWO_START_PIXEL_X <= X && X < SEG_TWO_START_PIXEL_X + SEGMENT_WIDTH && SEG_TWO_START_PIXEL_Y <= Y && Y < SEG_TWO_START_PIXEL_Y + SEGMENT_LEN) begin
                click_state[1] = left ? 1 : right ? 0 : click_state[1];
            end else if (SEG_THREE_START_PIXEL_X <= X && X < SEG_THREE_START_PIXEL_X + SEGMENT_WIDTH && SEG_THREE_START_PIXEL_Y <= Y && Y < SEG_THREE_START_PIXEL_Y + SEGMENT_LEN) begin
                click_state[2] = left ? 1 : right ? 0 : click_state[2];
            end else if (SEG_FIVE_START_PIXEL_X <= X && X < SEG_FIVE_START_PIXEL_X + SEGMENT_WIDTH && SEG_FIVE_START_PIXEL_Y <= Y && Y < SEG_FIVE_START_PIXEL_Y + SEGMENT_LEN) begin
                click_state[4] = left ? 1 : right ? 0 : click_state[4];
            end else if (SEG_SIX_START_PIXEL_X <= X && X < SEG_SIX_START_PIXEL_X + SEGMENT_WIDTH && SEG_SIX_START_PIXEL_Y <= Y && Y < SEG_SIX_START_PIXEL_Y + SEGMENT_LEN) begin
                click_state[5] = left ? 1 : right ? 0 : click_state[5];
            end
        end
    end

    assign mouse_click_seg = click_state;

endmodule
