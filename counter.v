//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 01:22:30 PM
// Design Name: 
// Module Name: counter
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


module counter(input clk, reset,enable ,output[3:0] counter
    );
reg [3:0] counter_up;

// up counter
always_ff @(posedge clk)
begin
if(reset)
 counter_up <= 4'd0;
else
 if(enable)
 counter_up <= counter_up + 4'd1;
 else
 counter_up <= 0;
end 
assign counter = counter_up;
endmodule
