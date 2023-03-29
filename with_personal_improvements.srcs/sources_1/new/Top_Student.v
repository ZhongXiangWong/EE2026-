`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
        // OLED inputs
        input clock,
        input btnR,
        input btnC,
        input btnL,
        inout ps2_clk, ps2_data,
        input [15:0] sw,
        output [7:0] JB,
        output [15:0] led,
        output [6:0] seg,
        output [3:0] an,
        output dp,
        output [3:0] JXADC
    );
    
    // OLED::instantiation
    wire clk_6p25m;
    wire [15:0] oled_pixel_data, digit_pixel_data, mouse_pixel_data;
    wire oled_frame_begin, oled_sending_pixel, oled_sample_pixel;
    wire [12:0] oled_pixel_index;
    wire [6:0] pixelX, pixelY;
    clk6p25m oled_clk(clock, clk_6p25m);
    Oled_Display oled(
        clk_6p25m,
        btnR,
        oled_frame_begin,
        oled_sending_pixel,
        oled_sample_pixel,
        oled_pixel_index,
        oled_pixel_data,
        JB[0],
        JB[1],
        JB[3],
        JB[4],
        JB[5],
        JB[6],
        JB[7]
    );
    
    // State
    wire [6:0] X, Y;
    wire [6:0] oled_seg, mouse_click_seg;
    wire is_valid_number;
    
    // Pixel to coordinate conversion
    pixelToXY convert(oled_pixel_index, X, Y);
    
    // Display for OLED
    // Mouse::pointer
    Mouse_control pointer(clock, ps2_clk, ps2_data, X, Y, mouse_pixel_data, mouse_click_seg);
    Oled_digit_display_controller control(mouse_click_seg, sw[9:1], oled_seg, is_valid_number);
    Oled_digit_display display_digit(sw[0], oled_seg, X, Y, digit_pixel_data);
    // Check and display valid number
    
    wire [15:0] valid_num_led;
    Valid_number_check check_valid_number(clock, is_valid_number, oled_seg, sw[15], seg, an, dp, valid_num_led[15]);
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //-----------------------------------------Audio Part-----------------------------------------------------// 
    wire [11:0] default_audio_signal;
    wire [11:0] piano_audio_signal;
    wire [11:0] audio_signal;
    wire [15:0] piano_led;
    
    wire signal50M; clock_50m s50M (clock, signal50M); //Clock speed for the audio ouput
    wire signal20k; clock_20k s20k (clock, signal20k); //Sampling rate for the audio output 
   
    //Module for Individual Task: btnC plays sound, SW[1] affects tone and pitch 
    audio_out audio_out (clock, btnC, sw[0], is_valid_number, oled_seg [6:0], default_audio_signal[11:0]);
    //Module for Personal Improvement: Piano keys {SW[15:9]}, ability to record {automatically} 
    //and playback {btnL: LED, SW8: Sound}.
    audio_piano audio_piano (clock, sw[15:0], btnC, btnL, btnR, piano_audio_signal[11:0], piano_led[15:9]);
    
    //Audio module: Just need to pass the audio data into this
    Audio_Output myAudioOutput(.CLK(signal50M), .START(signal20k), .DATA1(audio_signal[11:0]), .RST(0)
            , .D1(JXADC[1]), .D2(JXADC[2]), .CLK_OUT(JXADC[3]), .nSYNC(JXADC[0])); 
                
    
    assign audio_signal = (sw[1]) ? piano_audio_signal:
                                    default_audio_signal;
                                    
    assign led[15:0] = (sw[1]) ? piano_led[15:0] : 
                                 valid_num_led[15:0];
    //---------------------------------------------------------------------------------------------------------//
    

    

    assign oled_pixel_data = mouse_pixel_data ? mouse_pixel_data : digit_pixel_data;



endmodule