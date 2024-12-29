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
    input rst,
    input fivesecbtn, 
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
    wire timeon;
    reg mintick;
    
    always @(posedge start)begin
        if(sel == 2'b10)
            toggle = ~toggle; // Start/Pause ONLY toggled when on timer mode
    end
    
    // Decrements ONLY when timer is not at 00:00
    assign timeon = toggle && (tensec != 0 || onesec != 0 || onemin != 0 || tenmin != 0);
    
    // Second Control
    always @(posedge clk1sec or posedge fivesecbtn or posedge rst)begin
        if(rst)begin // Resets to 00:00
            onesec <= 0;
            tensec <= 0;
        end
        else begin  
            if(timeon)begin
                if(clk1sec)begin
                    if(onesec == 0 && tensec > 0)begin
                        tensec <= tensec - 1;
                        onesec <= 9;
                        mintick <= 0;
                    end
                    else if(onesec == 0 && tensec == 0 && (onemin != 0 || tenmin != 0))begin  // Edge Case handling + Minute Tick
                        tensec <= 5;
                        onesec <= 9;
                        mintick <= 1;
                    end   
                    else begin
                        mintick <= 0;
                        onesec <= onesec - 1;
                    end     
                end
            end
            else begin
                if(fivesecbtn && (sel == 2'b10))begin // Increments by 5 seconds (Minute is Not changed) i.e. 00:55 -> 00:00
                    if(onesec >= 5)begin
                        onesec <= onesec - 5;
                        if(tensec == 5)
                            tensec <= 0;
                        else
                            tensec <= tensec + 1;
                    end
                    else
                        onesec <= onesec + 5;
                end
            end        
        end          
    end  
    
    
    // Minute control  
    always @(posedge mintick or posedge minbtn or posedge rst)begin
        if(rst)begin // Resets to 00:00 when reset is pressed 
            onemin <= 0;
            tenmin <= 0;
        end
        else begin
            if(timeon)begin // If toggle is on AND time is not 00:00
                if(mintick)begin // Activated every minute every minute
                    if(onemin == 0 && tenmin != 0)begin //Decrements minutes if minutes > 1
                        onemin <= 9;
                        tenmin <= tenmin - 1;
                    end
                    else if(onemin != 0)
                        onemin <= onemin - 1;
                end    
            end
            else if (minbtn && (sel == 2'b10))begin // Increments minutes if timeon is off at pushbutton edge
                if(onemin == 9)begin
                    onemin <= 0;
                    if(tenmin == 9)
                        tenmin <= 0;
                    else
                        tenmin <= tenmin + 1;
                end
                else
                    onemin <= onemin + 1;
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
