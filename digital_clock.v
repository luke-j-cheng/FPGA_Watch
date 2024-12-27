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
    reg minute = 0;
    reg [3:0] tenhour = 1, onehour = 2, tenmin = 0, onemin = 0;
    
    always @(posedge clk1sec)begin
        if (counter == 29)begin
            counter <= 0;
            minute <= ~minute;
        end
        else
            counter = counter + 1;
    end

    // Changes ONLY when mode is correct

    always @(posedge minbtn) begin
        if(sel == 2'b00)begin
            if (onemin == 9) begin
                onemin <= 0;
                if (tenmin == 5) begin
                    tenmin <= 0;
                    if (onehour == 9 && tenhour == 0) begin
                        onehour <= 0;
                        tenhour <= 1;
                    end
                    else if (onehour == 2 && tenhour == 1) begin
                        onehour <= 1;
                        tenhour <= 0; 
                    end
                    else begin
                        onehour <= onehour + 1;
                    end
                end
                else begin
                    tenmin <= tenmin + 1;  
                end
            end
            else begin
                onemin <= onemin + 1;
            end
        end
    end
    always @(posedge tenminbtn)begin
        if(sel == 2'b00)begin
            if (tenmin == 5) begin
                tenmin <= 0;
                if (onehour == 9 && tenhour == 0) begin
                    onehour <= 0;
                    tenhour <= 1;
                end
                else if (onehour == 2 && tenhour == 1) begin
                    onehour <= 1;
                    tenhour <= 0; 
                end
                else begin
                    onehour <= onehour + 1;
                end
            end
            else begin
                tenmin <= tenmin + 1;  
            end
        end
    end
    always @(posedge hrbtn)begin
        if(sel == 2'b00)begin
            if (onehour == 9 && tenhour == 0) begin
                onehour <= 0;
                tenhour <= 1;
            end
            else if (onehour == 2 && tenhour == 1) begin
                onehour <= 1;
                tenhour <= 0; 
            end
            else 
                onehour <= onehour + 1;    
        end
    end
    
    // Minute always changes clock 
    
    always @(posedge minute)begin
            if (onemin == 9) begin
                onemin <= 0;
                if (tenmin == 5) begin
                    tenmin <= 0;
                    if (onehour == 9 && tenhour == 0) begin
                        onehour <= 0;
                        tenhour <= 1;
                    end
                    else if (onehour == 2 && tenhour == 1) begin
                        onehour <= 1;
                        tenhour <= 0; 
                    end
                    else begin
                        onehour <= onehour + 1;
                    end
                end
                else begin
                    tenmin <= tenmin + 1;  
                end
            end
            else begin
                onemin <= onemin + 1;
            end
     end
    
    // Reset also only when on clock mode
    
    always @(posedge rst)begin
        if(sel == 2'b00)begin
            onehour = 2;
            tenhour = 1;
            onemin = 0;
            tenmin = 0;
        end
    end
    
 
    
    always @(posedge clk100MHz)begin
        tenhrout <= tenhour;
        onehrout <= onehour;
        tenminout <= tenmin;
        oneminout <= onemin;
    end
    
endmodule
