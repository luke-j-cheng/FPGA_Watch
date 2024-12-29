`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2024 11:30:47 AM
// Design Name: 
// Module Name: digital_clock
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

///TRY DOING ALWAYS @ POSEDGES WITH CONDITIONALS i.e.
/// if(min && ten && ....)


module digital_clock(
    input minbtn,
    input tenminbtn,
    input hrbtn, 
    input rst,
    input clk100MHz,
    input clk1sec,
    input [1:0] sel,
    output reg [3:0] tenhrout,
    output reg [3:0] onehrout,
    output reg [3:0] tenminout,
    output reg [3:0] oneminout
    );
    
    reg [4:0] counter = 0;
    reg minute = 0; //Ticks every min
    reg [3:0] tenhour = 1, onehour = 2, tenmin = 0, onemin = 0; // Clock will always start at 12:00
    reg tentick = 0, hrtick = 0; //Ticks every ten minutes, ticks every hour
    
   
    
    always @(posedge clk1sec)begin
        if(rst)begin
            counter <= 0;
            minute <= 0;
        end
        else begin
            if (counter == 59)begin //Creates a positive edge every minute every 60 seconds)
                counter <= 0;
                minute <= 1;
            end
            else begin
                counter <= counter + 1;
                minute <= 0;
            end
        end
    end
    
    always @(posedge minute or posedge minbtn or posedge rst)begin
        if(rst)
            onemin <= 0;   
        else
            if(minute)begin //Minute tick will keep increment clock even when on stopwatch/timer mode
                if(onemin == 9)begin // Logic to handle edge cases
                    onemin <= 0;
                    tentick <= 1; // Creates a tick whenever ten must be incremented
                end
                else begin
                    tentick <= 0; 
                    onemin <= onemin + 1;
                end
            end
            else if (minbtn && (sel == 2'b00))begin // Pushbuttons ONLY work when on clock mode
                if(onemin == 9)begin    
                    onemin <= 0;
                    tentick <= 1;
                end
                else begin
                    tentick <= 0;
                    onemin <= onemin + 1;
                end
            end
    end
    
    
    // Same logic applies for ten minute column and hour column as above always statement 
    always @(posedge tentick or posedge tenminbtn or posedge rst)begin
        if(rst)
            tenmin <= 0;
        else begin
            if(tentick)begin
                if(tenmin == 5)begin
                    tenmin <= 0;
                    hrtick <= 1;
                end
                else begin
                    tenmin <= tenmin + 1;
                    hrtick <= 0;
                end
            end
            else if(tenminbtn && (sel == 2'b00))begin
                if(tenmin == 5)begin
                    tenmin <= 0;
                    hrtick <= 1;
                end
                else begin
                    tenmin <= tenmin + 1;
                    hrtick <= 0;
                end
            end
        end
    end
    
    always @(posedge hrtick or posedge hrbtn or posedge rst)begin
        if(rst)begin
            tenhour <= 1;
            onehour <= 2;
        end
        else begin
            if(hrtick)begin
                if(tenhour == 1 && onehour == 2)begin
                    onehour <= 1;
                    tenhour <= 0;
                end
                else if (tenhour == 0 && onehour == 9)begin
                    onehour <= 0;
                    tenhour <= 1;
                end
                else
                    onehour <= onehour + 1;
            end
            else if(hrbtn && (sel == 2'b00))begin
                if(tenhour == 1 && onehour == 2)begin
                    onehour <= 1;
                    tenhour <= 0;
                end
                else if (tenhour == 0 && onehour == 9)begin
                    onehour <= 0;
                    tenhour <= 1;
                end
                else
                    onehour <= onehour + 1;
            end
        end                 
    end      

    //Output register updates every 100 MHz clock cycle (avoid glitches)

    always @(posedge clk100MHz)begin
        tenhrout <= tenhour;
        onehrout <= onehour;
        tenminout <= tenmin;
        oneminout <= onemin;
    end
    
endmodule
