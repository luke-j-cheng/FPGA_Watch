`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 11:10:42 AM
// Design Name: 
// Module Name: secondclk
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


module secondclk(
    input clk,
    output reg newclk = 0
    );
    
    integer num = 0;
    
always @(posedge clk) begin
    if (num == 2)begin // Change back to 100000000
        num <= 0;
        newclk <= ~newclk;
    end
    else
        num <= num + 1;
end
endmodule
