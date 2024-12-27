`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2024 09:32:47 AM
// Design Name: 
// Module Name: timer_tb
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


module timer_tb();
    reg start_tb;              // Pause signal
    reg secbtn_tb, tensecbtn_tb, minbtn_tb;                // Reset signal
    reg clk1sec_tb = 0;            // 1-second clock input
    reg clk100MHz_tb = 0;          // 100 MHz clock input
    wire [3:0] tenminout_tb;  // Output for tens of minutes
    wire [3:0] oneminout_tb;  // Output for ones of minutes
    wire [3:0] tensecout_tb;  // Output for tens of seconds
    wire [3:0] onesecout_tb;  // Output for ones of seconds
    
    timer instant(
        .start(start_tb),            // Connect pause_tb
        .secbtn(secbtn_tb),
        .tensecbtn(tensecbtn_tb),
        .minbtn(minbtn_tb),
        .clk1sec(clk1sec_tb),        // Connect clk1sec_tb
        .clk100MHz(clk100MHz_tb),    // Connect clk100MHz_tb
        .tenminout(tenminout_tb),    // Connect tenminout_tb
        .oneminout(oneminout_tb),    // Connect oneminout_tb
        .tensecout(tensecout_tb),    // Connect tensecout_tb
        .onesecout(onesecout_tb)     // Connect onesecout_tb
    );
    
    always begin 
        #3; 
        clk1sec_tb = ~clk1sec_tb; 
    end
    always begin 
        #3; 
        clk100MHz_tb = ~clk100MHz_tb; 
    end
    initial begin
        #10;
        tensecbtn_tb = 1;
        minbtn_tb = 1;
        #10;
        start_tb = 1; 
        #2000;
        $finish;
    end

endmodule
