//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 07:36:59 AM
// Design Name: 
// Module Name: mul_dot
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


module mul_dot(
input start,
input clk,
input reset,
input [15:0] q1_l, q2_l, q3_l,
input [15:0] dot_val,
output [31:0] d1_mul, d2_mul, d3_mul,
output stop  );

logic [31:0] d1_mul_temp, d2_mul_temp, d3_mul_temp;
logic stop_temp;

assign stop = stop_temp;
assign d1_mul = d1_mul_temp;
assign d2_mul = d2_mul_temp;
assign d3_mul = d3_mul_temp;

always_ff @(posedge clk)
begin
  if(reset)
    begin
    stop_temp <= 0;
    d1_mul_temp <=0;
    d2_mul_temp <=0;
    d3_mul_temp <=0;   
    end
  else if (start)
    begin 
    d1_mul_temp <= dot_val * q1_l;
    d2_mul_temp <= dot_val * q2_l;
    d3_mul_temp <= dot_val * q3_l;
    stop_temp <= 1'b1;
    end
  else
   begin
    stop_temp <= 0;
   end

end


endmodule


/*module mul_dot(
input start,
input clk,
input reset,
input [15:0] q1_l, q2_l, q3_l,
input [15:0] dot_val,
output [15:0] d1_mul, d2_mul, d3_mul,
output stop,
  //, input               done_acc
output              ready_o);
  

  typedef enum logic [1:0] {eWAIT, eBUSY, eBWAIT, eDONE} state_e;

  state_e  state_n, state_r;

  logic [15:0] d1_n, d2_n, d3_n, d1_r, d2_r, d3_r;

  assign ready_o = state_r == eWAIT;
  assign     stop = state_r == eDONE;
  assign d1_mul = d1_r;
  assign d2_mul = d2_r;
  assign d3_mul = d3_r;
  
  always_comb
    begin
      state_n = state_r;
      if (ready_o & start) begin
        state_n = eBUSY;
      end else if ((state_r == eBUSY)) begin
    //    data_o = A * A;
    //    accum = accum + data_o;
        state_n = eBWAIT;
      end
      else if ((state_r == eBWAIT)) begin
    //    data_o = A * A;
    //    accum = accum + data_o;
        state_n = eDONE;
      end 
      else if (stop) begin
        state_n = eWAIT;
      end
    end

  always_ff @(posedge clk)
    begin
      if (reset)
          state_r <= eWAIT;
      else
          state_r <= state_n;
    end
    assign d1_n = ((state_r == eBUSY) |(state_r == eBWAIT) )? q1_l * dot_val: d1_r;
    assign d2_n = ((state_r == eBUSY) |(state_r == eBWAIT) )? q2_l * dot_val: d1_r;
    assign d3_n = ((state_r == eBUSY) |(state_r == eBWAIT) )? q3_l * dot_val: d1_r;
    
   always_ff@(posedge clk)
     begin
       if (reset)
           begin
           d1_r <=0;
           d2_r <=0;
           d3_r <=0;
           end
       else
           begin
           d1_r <= d1_n;
           d2_r <= d2_n;
           d3_r <= d3_n;
           end
end
endmodule */
