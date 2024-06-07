//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2024 06:49:27 AM
// Design Name: 
// Module Name: oc_ic_counter
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


module oc_ic_counter(input clk, reset,enable ,output[3:0] counter
    );
logic [3:0] counter_up;

// up counter

always_ff @(posedge clk)
begin
 if(reset)
 begin
   counter_up <= 0;
 end
 else
   begin
   if(enable)
   counter_up <= counter_up + 4'd1;
   else
   counter_up <= counter_up;
   end
end
assign counter = counter_up;
endmodule
