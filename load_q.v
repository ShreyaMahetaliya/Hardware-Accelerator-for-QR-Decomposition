//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 06:15:45 AM
// Design Name: 
// Module Name: load_q
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


module load_q(
input [15:0] q1,
input [15:0] q2,
input [15:0] q3,
output [15:0] q1_l,
output [15:0] q2_l,
output [15:0] q3_l,
input clk,
input start,
input reset,
output stop
    );
   
logic stop_r, stop_n;
logic [15:0] q1_l_r, q2_l_r, q3_l_r;
logic [15:0] q1_l_n, q2_l_n, q3_l_n;

assign q1_l = q1_l_r;
assign q2_l = q2_l_r;
assign q3_l = q3_l_r;

assign stop = stop_r;

always_ff @(posedge clk)
begin
if(reset)
   begin
   q1_l_r <= 0;
   q2_l_r <= 0;
   q3_l_r <= 0;
   stop_r <= 0;
   end
else
   begin
    q1_l_r <= q1_l_n;
    q2_l_r <= q2_l_n;
    q3_l_r <= q3_l_n;
    stop_r <= stop_n;
    end
end
   
always_comb
   begin
     if (start)
     begin
     q1_l_n = q1;
     q2_l_n = q2;
     q3_l_n = q3;
     stop_n = 1;
     end
     else
     begin
     q1_l_n = q1_l_r;
     q2_l_n = q2_l_r;
     q3_l_n = q3_l_r;
     stop_n = 0;
     end
   end



endmodule
