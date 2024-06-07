//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 07:05:58 AM
// Design Name: 
// Module Name: o_q_i_dot
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


module o_q_i_dot(

input start,
input reset,
input clk,
input [15:0] q1_l, q2_l, q3_l,
output [15:0] q_i_dot,
output stop
    );
    
logic stop_temp;  
logic [15:0] q_i_dot_temp; 

assign stop = stop_temp;
assign q_i_dot = q_i_dot_temp;

logic [3:0] count;
counter cd(.clk(clk),
             .reset(reset),
             .enable(start & (~stop_temp)),
             .counter(count));

always_ff @(posedge clk)
begin
if (reset)
  begin
  stop_temp <= 0;
  q_i_dot_temp <= 0;
  end 
else
  begin
  case(count)
      4'b0000: q_i_dot_temp <= q1_l;
      4'b0001: q_i_dot_temp <= q2_l;
      4'b0010: begin
              q_i_dot_temp <= q3_l;
              stop_temp <= 1'b1;
              end
      default: stop_temp<=0;
              
   endcase
  end

end       
 
endmodule
