//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2024 09:39:02 AM
// Design Name: 
// Module Name: multiplier_b
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


module multiplier_b(
input [15:0] i_multiplier,
input [15:0] i_multiplicand,
input i_start,
input i_clk,
input i_reset,
output o_stop,
output [15:0] q1out,
output [15:0] q2out,
output [15:0] q3out
    );
logic stop_temp;   
logic [3:0] count_m;
counter cm(.clk(i_clk),
             .reset(i_reset),
             .enable(i_start & (~stop_temp)),
             .counter(count_m));
logic [15:0] q1out_temp, q2out_temp, q3out_temp;



assign q1out = q1out_temp;
assign q2out = q2out_temp;
assign q3out = q3out_temp;
assign o_stop =stop_temp;

always_ff @(posedge i_clk)
begin
  if(i_reset)
  begin
  q1out_temp <= 0;
  q2out_temp <= 0;
  q3out_temp <= 0;
  stop_temp<=0;
  end
  else
  begin
  case(count_m)
      4'b0001: q1out_temp <= i_multiplier * i_multiplicand;
      4'b0010: q2out_temp <= i_multiplier * i_multiplicand;
      4'b0011: begin
              q3out_temp <= i_multiplier * i_multiplicand;
              stop_temp <= 1'b1;
              end
	    4'b0000: stop_temp <= 0;
	   default: begin
		        q1out_temp <= q1out_temp;
               q2out_temp <= q2out_temp;
               q3out_temp <= q3out_temp;
               stop_temp <= stop_temp;
              end
   endcase
  end
end



//lways_comb
 //  begin   
   //q1out_temp=0;
   //q2out_temp=0;
   //q3out_temp=0;
   //stop_temp=0;    
   
 //  end          

endmodule
