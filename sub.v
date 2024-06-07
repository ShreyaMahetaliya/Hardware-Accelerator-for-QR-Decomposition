//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 08:27:55 AM
// Design Name: 
// Module Name: sub
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


module sub(
   input start,
   output stop,
   input reset,
   input clk,
   input [15:0] sub1,
   input [15:0] d1_mul, d2_mul, d3_mul,
   output [15:0] sub_o,
   output start_w
    );
    
logic stop_temp; 
logic start_w_temp; 
logic [15:0] sub_o_temp; 

assign stop = stop_temp;
assign sub_o = sub_o_temp;
assign start_w = start_w_temp;

logic [3:0] count;
counter cd(.clk(clk),
             .reset(reset),
             .enable(start & (~stop_temp)),
             .counter(count));

always_ff @(posedge clk)
begin
if (reset)
  begin
  stop_temp <=  0;
  sub_o_temp <= 0;
  start_w_temp <= 0;
  end 
else
  begin
  case(count)
      4'b0000: begin
               start_w_temp <= start;
               end
      4'b0001: begin
               sub_o_temp <= sub1 - d1_mul;
               start_w_temp <= 1'b1;
               end
      4'b0010: begin
              sub_o_temp <= sub1 - d2_mul;
              start_w_temp <= 1'b1;
              end
      4'b0011: begin
              sub_o_temp <= sub1 - d3_mul;
              stop_temp <= 1'b1;
              start_w_temp<=1;
              end
      default: begin
              sub_o_temp <=0;
              stop_temp <=0;
              start_w_temp <=0;
             end
   endcase
  end

end       
    
    
endmodule
