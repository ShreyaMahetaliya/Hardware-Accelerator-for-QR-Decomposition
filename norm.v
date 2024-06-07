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


module norm
  ( input               clk_i
  , input               reset_i
  , input               done_acc
  , input        [15:0] A
  , input               v_i
  , output              ready_o

  , output logic [15:0] data_o
  
  , output        v_o
  , input               yumi_i
  //, input               new_a
  );

  typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;

  state_e  state_n, state_r;
  logic        v_o_norm;
  logic [15:0] A_n, A_r;
  logic [31:0] accum;
  assign ready_o = state_r == eWAIT;
  assign     v_o_norm = state_r == eDONE;
  assign accum = A_r;
  
  always_comb
    begin
      state_n = state_r;
      if (ready_o & v_i) begin
        state_n = eBUSY;
      end else if ((state_r == eBUSY & done_acc == 1'b1)) begin
    //    data_o = A * A;
    //    accum = accum + data_o;
        state_n = eDONE;
      end else if (v_o_norm & yumi_i) begin
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
    assign A_n = ((state_r == eBUSY))? A_r+ A*A: A_r;
   always_ff@(posedge clk_i)
     begin
       if (reset_i)
           A_r<=0;
       else
           A_r <= A_n;
end
logic [31:0]in;
assign in= accum << 16;


SqrtCORDIC s1 (.Start(v_o_norm), .clk(clk_i), .InpNum(in), .rst(reset_i), .Result(data_o), .Stop(v_o));

endmodule
