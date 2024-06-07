//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2024 02:49:02 PM
// Design Name: 
// Module Name: norm
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


module dot_product
  ( input               clk_i
  , input               reset_i
  , input               done_acc
  , input        [15:0] A
  , input        [15:0] B
  , input               A_v_i
  , input               B_v_i
  , output              ready_o

  , output logic [15:0] accum
  , output logic        v_o
  , input               yumi_i
  );

  typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;

  state_e  state_n, state_r;
  logic [15:0] As;
  logic [31:0] A_n, A_r;

  assign ready_o = state_r == eWAIT;
  assign     v_o = state_r == eDONE;
  assign accum = A_r[23:8];
  //assign As= A<<8;
  always_comb
    begin
      state_n = state_r;
      if (ready_o & A_v_i & B_v_i) begin
        state_n = eBUSY;
      end else if ((state_r == eBUSY & done_acc==1'b1)) begin
    //    data_o = A * A;
    //    accum = accum + data_o;
        state_n = eDONE;
      end else if (v_o & yumi_i) begin
        state_n = eWAIT;
      end
    end

  always_ff @(posedge clk_i)
    begin
      if (reset_i)
       state_r <= eWAIT;
     else
        state_r <= state_n;
   end
    assign A_n = (state_r == eBUSY)? A_r+ A*B: A_r;
   always_ff@(posedge clk_i)
     begin
      if (reset_i)
           A_r<=0;
      else
           A_r <= A_n;
end
endmodule
