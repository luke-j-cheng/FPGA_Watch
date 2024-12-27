`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 01:54:31 PM
// Design Name: 
// Module Name: timer
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


module timer(
    input secbtn,
    input tensecbtn, 
    input minbtn,
    input start,
    input clk1sec,
    input clk100MHz,
    input [1:0] sel,
    output reg [3:0] tenminout,
    output reg [3:0] oneminout,
    output reg [3:0] tensecout,
    output reg [3:0] onesecout
    );
    reg [3:0] onesec = 0, tensec = 0, onemin = 0, tenmin = 0;
    reg toggle =  0;
    
    always @(posedge start)begin
        if(sel == 2'b10)
            toggle = ~toggle;
    end
    
    
    
// SETTING TIMER
    always @(posedge secbtn) begin
        if(sel == 2'b10)begin
            if (onesec == 9) begin
                onesec <= 0;
                if (tensec == 5) begin
                    tensec <= 0;
                    if (onemin == 9 && tenmin != 9) begin
                        onemin <= 0;
                        tenmin <= tenmin + 1;
                    end
                    else if (onemin == 9 && tenmin == 9) begin
                        onemin <= 9;
                        tenmin <= 9; 
                    end
                    else begin
                        onemin <= onemin + 1;
                    end
                end
                else begin
                    tensec <= tensec + 1;  
                end
            end
            else begin
                onesec <= onesec + 1;
            end
        end
    end
    
    always @(posedge tensecbtn) begin
        if(sel == 2'b10)begin
            if (tensec == 5) begin
                tensec <= 0;
                if (onemin == 9 && tenmin == 0) begin
                    onemin <= 0;
                    tenmin <= 1;
                end
                else if (onemin == 2 && tenmin == 1) begin
                    onemin <= 1;
                    tenmin <= 0; 
                end
                else begin
                    onemin <= onemin + 1;
                end
            end
            else begin
                tensec <= tensec + 1;  
            end
        end
    end
    
    always @(posedge minbtn) begin
        if(sel == 2'b10)begin    
            if (onemin == 9 && tenmin == 0) begin
                onemin <= 0;
                tenmin <= 1;
            end
            else if (onemin == 2 && tenmin == 1) begin
                onemin <= 1;
                tenmin <= 0; 
            end
            else 
                onemin <= onemin + 1;    
        end
    end
    
// Countdown
    always @(posedge clk1sec) begin
        if (toggle) begin
            if (onesec == 0) begin
                if (tensec != 0) begin
                    onesec <= 9;
                    tensec <= tensec - 1;
                end
                else if (onemin != 0 || tenmin != 0) begin
                    onesec <= 9;
                    tensec <= 5;
                    if (onemin == 0) begin
                        onemin <= 9;
                        tenmin <= tenmin - 1;
                    end
                    else begin
                        onemin <= onemin - 1;
                    end
                end
                else begin
                    onesec <= 0; // Timer reached zero
                    tensec <= 0;
                    onemin <= 0;
                    tenmin <= 0;
                end
            end
            else begin
                onesec <= onesec - 1;
            end
        end
    end

    
    
    
    always @(posedge clk100MHz)begin
        tensecout <= tensec;
        onesecout <= onesec;
        tenminout <= tenmin;
        oneminout <= onemin;
    end
     


endmodule
