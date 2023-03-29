`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 21:47:47
// Design Name: 
// Module Name: audio_out
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


module audio_out(
    input clock,
    input btnC,
    input sw0,
    input is_valid_number,
    input [6:0] oled_seg,
    output [11:0] audio_out
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
    
    //Contains the frequency and amplitude data of the sound
//    wire [11:0] audio_out; 
    


    //Determines the duration of the sound
    reg [26:0] counter_clk = 27'b101111101011110000100000000;         
    reg [26:0] counter = 27'b0;
    reg sound_type = 0;
        
    //Sound Type 1: Lower Freq & Larger Amplitude
    wire signal125; clock_125 s125 (clock, signal125);
    parameter [11:0] max_volume = 12'hfff;
    
    //Audio Type 2: Higher Freq & Smaller Amplitude
    wire signal250; clock_250 s250 (clock, signal250);
    parameter [11:0] half_volume = 12'h800;
    
    //Default Audio: No Sound
    reg [11:0] audio_volume = 12'h000;
           
    
    //Introduced so that the sound only play for 1 time duration.
    reg play_sound = 0;
    
    //Introduced to fix bug where transition from a valid state to another valid state w/o an intermediate
    //non-valid state results in no sound being played.
    reg [6:0] prev_num = 0;
    
    //Week 8 Individual Task
    always @ (posedge clock) begin
        if (btnC) begin
            sound_type = (sw0) ? 1 : 0;
            counter_clk = 27'b101111101011110000100000000;
        end
        
        if (is_valid_number) begin
            if (oled_seg != prev_num) begin
                sound_type = (sw0) ? 1 : 0;
                play_sound = 1;   
            
                if (oled_seg == ~ZERO) begin
                    counter_clk = 27'b000100110001001011010000000;     //0.1s
                end else if (oled_seg == ~ONE) begin
                    counter_clk = 27'b001001100010010110100000000;     //0.2s
                end else if (oled_seg == ~TWO) begin
                    counter_clk = 27'b001110010011100001110000000;     //0.3s
                end else if (oled_seg == ~THREE) begin
                    counter_clk = 27'b010011000100101101000000000;     //0.4s
                end else if (oled_seg == ~FOUR) begin
                    counter_clk = 27'b010111110101111000010000000;     //0.5s
                end else if (oled_seg == ~FIVE) begin
                    counter_clk = 27'b011100100111000011100000000;     //0.6s
                end else if (oled_seg == ~SIX) begin
                    counter_clk = 27'b100001011000001110110000000;     //0.7s
                end else if (oled_seg == ~SEVEN) begin
                    counter_clk = 27'b100110001001011010000000000;     //0.8s
                end else if (oled_seg == ~EIGHT) begin
                    counter_clk = 27'b101010111010100101010000000;     //0.9s
                end else if (oled_seg == ~NINE) begin
                    counter_clk = 27'b101111101011110000100000000;     //1.0s
                end else begin
                    counter_clk = 27'b000000000000000000000000;        //Nothing happens
                end
            end
            prev_num = oled_seg;
        end else begin
            prev_num = 0;
        end
          
          
        if (btnC || counter > 0 || play_sound) begin
            case (sound_type)
                0: audio_volume[11:0] = (signal250 == 0) ? half_volume[11:0] : 0;
                1: audio_volume[11:0] = (signal125 == 0) ? max_volume[11:0] : 0;        
            endcase
            
            play_sound = 0;
            counter = (counter == counter_clk) ? 0 : counter + 1;
        end     
    end 
    
    
    assign audio_out[11:0] = audio_volume[11:0];
       
    
endmodule