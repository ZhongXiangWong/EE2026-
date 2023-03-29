`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2023 11:45:32
// Design Name: 
// Module Name: audio_piano
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

//Feature #1: Piano notes feature 
//SW15-A, SW14-B, SW13-C, SW12-D, SW11-E, SW10-F, SW9-G
//
//Feature #2: Sound Recording and playback feature
//SW8-Sound Recording, btnL-Start Recording, btnC-Delete Recording 
//Mode #1: Only LED         (btnL)
//Mode #2: LED and Sound    (btnL + SW8)
//
//Possible Additional Improvements:
//1. 'Teach' a recorded song: Based on the recording, prompt the next switch to on [Done]

//Updates:
//1. assign LED updated such that it will turn on upon key press.

module audio_piano(
    input clock,                                
    input [15:0] sw,                            //The note keys
    input btnC,                                 //This button clears the recording
    input btnL,                                 //This button plays the recording
    input btnR,                                 //Based on led press key
    output [11:0] piano_audio_signal,           //Output the note sound
    output [15:9] led                           //Display led on corresponding note (only for recording)
    );
    
    //Output sound for this module
    reg [11:0] audio_volume = 12'h800;
    
    
    //Personal Improvement Phase 1: Implement Piano Sounds [DONE]
    
    //7 basic notes
    wire [11:0] audio_note_A; //440Hz
    wire [11:0] audio_note_B; //494Hz
    wire [11:0] audio_note_C; //262Hz
    wire [11:0] audio_note_D; //294Hz
    wire [11:0] audio_note_E; //320Hz
    wire [11:0] audio_note_F; //350Hz
    wire [11:0] audio_note_G; //392Hz
    
    //Audio for the recording
    wire [11:0] audio_recording;
    
   //Frequency associated with each piano note
   clk440 clk_A(clock, audio_note_A);
   clk494 clk_B(clock, audio_note_B);
   clk262 clk_C(clock, audio_note_C);
   clk294 clk_D(clock, audio_note_D);
   clk320 clk_E(clock, audio_note_E);
   clk350 clk_F(clock, audio_note_F);
   clk392 clk_G(clock, audio_note_G);
   
   //Assigning switches to each piano note 
   assign piano_audio_signal = (sw[15]) ? ((audio_note_A == 0)    ? audio_volume[11:0] : 0) :
                               (sw[14]) ? ((audio_note_B == 0)    ? audio_volume[11:0] : 0) :
                               (sw[13]) ? ((audio_note_C == 0)    ? audio_volume[11:0] : 0) :
                               (sw[12]) ? ((audio_note_D == 0)    ? audio_volume[11:0] : 0) :
                               (sw[11]) ? ((audio_note_E == 0)    ? audio_volume[11:0] : 0) :
                               (sw[10]) ? ((audio_note_F == 0)    ? audio_volume[11:0] : 0) :
                               (sw[9])  ? ((audio_note_G == 0)    ? audio_volume[11:0] : 0) :
                               (sw[8])  ? ((audio_recording == 0) ? audio_volume[11:0] : 0) : 
                               11'b0;
           
                                
    
    //Personal Improvement Phase 2: Recording and playback feature [DONE]
    
    //Encoder: Encoded notes so that bitsize of sound_recording will not be absurdly long.
    wire [2:0] encoded_note;
    assign encoded_note [2:0] = (sw[15]) ? 3'b001 :
                                (sw[14]) ? 3'b010 :
                                (sw[13]) ? 3'b011 :
                                (sw[12]) ? 3'b100 :
                                (sw[11]) ? 3'b101 :
                                (sw[10]) ? 3'b110 :
                                (sw[9])  ? 3'b111 :
                                3'b0;

   //Decoder sound: Based on note_to_play, assign appropriate note to audio_recording. 
   wire [2:0] note_to_play;
   assign audio_recording = (note_to_play == 3'b001) ? ((audio_note_A == 0) ? audio_volume[11:0] : 0) :
                            (note_to_play == 3'b010) ? ((audio_note_B == 0) ? audio_volume[11:0] : 0) :
                            (note_to_play == 3'b011) ? ((audio_note_C == 0) ? audio_volume[11:0] : 0) :
                            (note_to_play == 3'b100) ? ((audio_note_D == 0) ? audio_volume[11:0] : 0) :
                            (note_to_play == 3'b101) ? ((audio_note_E == 0) ? audio_volume[11:0] : 0) :
                            (note_to_play == 3'b110) ? ((audio_note_F == 0) ? audio_volume[11:0] : 0) :
                            (note_to_play == 3'b111) ? ((audio_note_G == 0) ? audio_volume[11:0] : 0) :
                            11'b0;
                            
   //Decoder led: Based on note_to_play, assign appropriate note to audio_recording.
   //Added feature: Led will light up whenever corresponding switch is on
   assign led [15:9] = (note_to_play [2:0] == 3'b001 || sw[15]) ? 7'b1000000 :
                       (note_to_play [2:0] == 3'b010 || sw[14]) ? 7'b0100000 :
                       (note_to_play [2:0] == 3'b011 || sw[13]) ? 7'b0010000 :
                       (note_to_play [2:0] == 3'b100 || sw[12]) ? 7'b0001000 :
                       (note_to_play [2:0] == 3'b101 || sw[11]) ? 7'b0000100 :
                       (note_to_play [2:0] == 3'b110 || sw[10]) ? 7'b0000010 :
                       (note_to_play [2:0] == 3'b111 || sw[9]) ? 7'b0000001 :
                       7'b0000000;
    
    
    //This determines whether a note needs to be recorded.
    //Current logic: Must be from all switch off to only 1 switch on to be recorded. (switch is note)
    //This is so to allow consecutive and same notes to be recorded.
    reg get_next_note = 0;
    
    //This will remember up to 60 notes: will play for 30 second.                                      
    reg [179:0] sound_recording = 180'b0; 
   
    //Clock of period 0.5s.
    reg [26:0] counter_clk = 27'b101111101011110000100000000 >> 1;
    reg [26:0] counter = 27'b0; 
   
    //These 2 will work together to determine which note to play during playback.
    reg [6:0] slow_clock = 7'b0000000;
    reg [6:0] note_count = 7'b0000000;   
    
    //To turn on the recording.
    reg play_recording = 0;
    reg start_practice = 0;
    
    always @ (posedge clock) begin
        if (sw[1]) begin
        
            //This clears the recording.
            if (btnC == 1) begin
                sound_recording [179:0] = {180{1'b0}};
                note_count = 0;
                get_next_note = 1;
            end
            
            //This plays the recording.    
            if (btnL == 1) begin
                play_recording = 1;
                slow_clock = 0;
            end
            
            //For practice
            if (btnR == 1) begin
                start_practice = 1;
            end            
           
            
            //Base case: when recording has ended.
            if (note_count < slow_clock) begin
                play_recording = 0;
                start_practice = 0;
                slow_clock = 0;
            end
            
            //Timing for each recorded note: 0.5s.
            if (play_recording) begin
                if (counter == counter_clk) begin
                    slow_clock = slow_clock+1;
                    counter = 0;
                end else begin
                    counter = counter+1;
                end
            end
           
           //Due to the logic of 'Must be from all switch off to only 1 switch on to be recorded' mentioned.
           if (encoded_note == 3'b000) begin
                get_next_note = 1;
           end
           
           //Adding the recorded note to the recording
           if (get_next_note && encoded_note != 3'b000 && !start_practice) begin
                sound_recording = (sound_recording << 3) + encoded_note;
                note_count = note_count + 1;
                get_next_note = 0;
           end
           
           
           if (start_practice) begin
                if (note_to_play == encoded_note) begin
                    slow_clock = slow_clock + 1;
                end
           end
       end
    end

        
    //To avoid for-loop. Multiplexer to select which note to play.
    assign note_to_play = (note_count - slow_clock == 0)  ? sound_recording[2:0]     :
                          (note_count - slow_clock == 1)  ? sound_recording[5:3]     :
                          (note_count - slow_clock == 2)  ? sound_recording[8:6]     :
                          (note_count - slow_clock == 3)  ? sound_recording[11:9]    :
                          (note_count - slow_clock == 4)  ? sound_recording[14:12]   :
                          (note_count - slow_clock == 5)  ? sound_recording[17:15]   :  
                          (note_count - slow_clock == 6)  ? sound_recording[20:18]   :
                          (note_count - slow_clock == 7)  ? sound_recording[23:21]   :
                          (note_count - slow_clock == 8)  ? sound_recording[26:24]   :
                          (note_count - slow_clock == 9)  ? sound_recording[29:27]   :
                          (note_count - slow_clock == 10) ? sound_recording[32:30]   :
                          (note_count - slow_clock == 11) ? sound_recording[35:33]   :
                          (note_count - slow_clock == 12) ? sound_recording[38:36]   :
                          (note_count - slow_clock == 13) ? sound_recording[41:39]   :
                          (note_count - slow_clock == 14) ? sound_recording[44:42]   :
                          (note_count - slow_clock == 15) ? sound_recording[47:45]   :
                          (note_count - slow_clock == 16) ? sound_recording[50:48]   : 
                          (note_count - slow_clock == 17) ? sound_recording[53:51]   : 
                          (note_count - slow_clock == 18) ? sound_recording[56:54]   :
                          (note_count - slow_clock == 19) ? sound_recording[59:57]   :
                          (note_count - slow_clock == 20) ? sound_recording[62:60]   :
                          (note_count - slow_clock == 21) ? sound_recording[65:63]   :
                          (note_count - slow_clock == 22) ? sound_recording[68:66]   :
                          (note_count - slow_clock == 23) ? sound_recording[71:69]   :
                          (note_count - slow_clock == 24) ? sound_recording[74:72]   :
                          (note_count - slow_clock == 25) ? sound_recording[77:75]   :
                          (note_count - slow_clock == 26) ? sound_recording[80:78]   :
                          (note_count - slow_clock == 27) ? sound_recording[83:81]   :
                          (note_count - slow_clock == 28) ? sound_recording[86:84]   :
                          (note_count - slow_clock == 29) ? sound_recording[89:87]   :
                          (note_count - slow_clock == 30) ? sound_recording[92:90]   :
                          (note_count - slow_clock == 31) ? sound_recording[95:93]   :
                          (note_count - slow_clock == 32) ? sound_recording[98:96]   :
                          (note_count - slow_clock == 33) ? sound_recording[101:99]  :
                          (note_count - slow_clock == 34) ? sound_recording[104:102] :
                          (note_count - slow_clock == 35) ? sound_recording[107:105] :
                          (note_count - slow_clock == 36) ? sound_recording[110:108] :
                          (note_count - slow_clock == 37) ? sound_recording[113:111] :
                          (note_count - slow_clock == 38) ? sound_recording[116:114] :
                          (note_count - slow_clock == 39) ? sound_recording[119:117] :
                          (note_count - slow_clock == 40) ? sound_recording[122:120] :
                          (note_count - slow_clock == 41) ? sound_recording[125:123] :
                          (note_count - slow_clock == 42) ? sound_recording[128:126] :
                          (note_count - slow_clock == 43) ? sound_recording[131:129] :
                          (note_count - slow_clock == 44) ? sound_recording[135:132] :
                          (note_count - slow_clock == 45) ? sound_recording[135:135] :
                          (note_count - slow_clock == 46) ? sound_recording[140:138] :
                          (note_count - slow_clock == 47) ? sound_recording[143:141] :
                          (note_count - slow_clock == 48) ? sound_recording[146:144] :
                          (note_count - slow_clock == 49) ? sound_recording[149:147] :
                          (note_count - slow_clock == 50) ? sound_recording[152:150] :
                          (note_count - slow_clock == 51) ? sound_recording[155:153] :
                          (note_count - slow_clock == 52) ? sound_recording[158:156] :
                          (note_count - slow_clock == 53) ? sound_recording[161:159] :
                          (note_count - slow_clock == 54) ? sound_recording[164:162] :
                          (note_count - slow_clock == 55) ? sound_recording[167:165] :
                          (note_count - slow_clock == 56) ? sound_recording[170:168] :
                          (note_count - slow_clock == 57) ? sound_recording[173:171] :
                          (note_count - slow_clock == 58) ? sound_recording[176:174] :
                          (note_count - slow_clock == 59) ? sound_recording[179:177] :
                          3'b000;
                              
    //Debugging code (Please Ignore):
    
    //Test for encoder
 //   assign led [15:9] = (sound_recording [2:0] == 3'b001) ? 7'b1000000 :
 //                       (sound_recording [2:0] == 3'b010) ? 7'b0100000 :
 //                       (sound_recording [2:0] == 3'b011) ? 7'b0010000 :
 //                       (sound_recording [2:0] == 3'b100) ? 7'b0001000 :
 //                       (sound_recording [2:0] == 3'b101) ? 7'b0000100 :
 //                       (sound_recording [2:0] == 3'b110) ? 7'b0000010 :
 //                       (sound_recording [2:0] == 3'b111) ? 7'b0000001 :
 //                       7'b0000000;
   
    //Test for sound 
    //   assign audio_recording = (sound_recording == 3'b001) ? ((audio_note_A == 0) ? audio_volume[11:0] : 0) :
 //                            (sound_recording == 3'b010) ? ((audio_note_B == 0) ? audio_volume[11:0] : 0) :
 //                            (sound_recording == 3'b011) ? ((audio_note_C == 0) ? audio_volume[11:0] : 0) :
 //                            (sound_recording == 3'b100) ? ((audio_note_D == 0) ? audio_volume[11:0] : 0) :
 //                            (sound_recording == 3'b101) ? ((audio_note_E == 0) ? audio_volume[11:0] : 0) :
 //                            (sound_recording == 3'b110) ? ((audio_note_F == 0) ? audio_volume[11:0] : 0) :
 //                            (sound_recording == 3'b111) ? ((audio_note_G == 0) ? audio_volume[11:0] : 0) :
 //                            11'b0;   
    
    
 //   assign led = (sound_recording == 3'b001) ? 7'b1000000 :
 //                (sound_recording == 3'b010) ? 7'b0100000 :
 //                (sound_recording == 3'b011) ? 7'b0010000 :
 //                (sound_recording == 3'b100) ? 7'b0001000 :
 //                (sound_recording == 3'b101) ? 7'b0000100 :
 //                (sound_recording == 3'b110) ? 7'b0000010 :
 //                (sound_recording == 3'b111) ? 7'b0000001 :
 //                7'b0;     
 
 // assign led [14:9] = (note_to_play) ? 7'b1111111 : 7'b0000000;
 //    assign led[15] = (note_count >= slow_clock) ? {7{1'b1}} : {7{1'b0}};    
 //    assign led [15:9] = (get_next_note) ? 7'b1111111 : 6'b0000000;
   
endmodule
