//`timescale 1ns/1ps
module normalization
  ( input               clk_i
  , input               reset_i
  //, input               
  , input        [15:0] A
  , input               v_i
  , output              ready_norm

  , output logic [15:0] data_out, data_norm
  
  , output logic        v_o, v_o_norm
  , input               yumi_i_norm
 , input               done_acc,
   output	o_overflow
  );
  
  
  logic [7:0] int_bits, fract_bits;
  logic [15:0] data_in_div;
  
  norm n1 (.clk_i( clk_i), .reset_i(reset_i), .done_acc(done_acc), .A(A), .v_i(v_i), 
             .ready_o(ready_norm), .data_o(data_norm), .v_o(v_o_norm), .yumi_i(1'b1));
				 
				 
				 assign int_bits=data_norm[15:8];
				 assign fract_bits= data_norm[7:0];
				 
				 always @* begin
				 
				 if (fract_bits >= 8'b10000000) // 0.5 in 8-bit fixed-point representation
            data_in_div = int_bits + 1; // Round up
        else
            data_in_div = int_bits; // Round down
    end
				 
				 
  qdiv #(.Q(8), .N(16)) d1 (.i_dividend(16'b0000000000000001), .i_divisor(data_in_div), .i_start(v_o_norm), .i_clk(clk_i),
 .i_reset(reset_i),
         .o_quotient_out(data_out), .o_complete(v_o), .o_overflow(o_overflow));
			
			
endmodule


//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 05/17/2024 08:36:34 AM
//// Design Name: 
//// Module Name: normalization
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////
//
//
//`timescale 1ns/1ps
//module normalization
//  ( input               clk
//  , input               reset
//  //, input               
//  , input        [15:0] A
//  , input               v_i
//  , output              ready_norm
//
//  , output logic [15:0] data_out
//  
//  , output logic        v_o
// , input   logic             done_acc
//  );
//  
//  
//  logic [7:0] int_bits, fract_bits;
//  logic [15:0] data_in_div;
//  logic [15:0] data_norm;
//  logic overflow, v_o_norm;
//  
//  norm n1 (.clk_i( clk), .reset_i(reset), .done_acc(done_acc), .A(A), .v_i(v_i), 
//             .ready_o(ready_norm), .data_o(data_norm), .v_o(v_o_norm), .yumi_i(yumi_i_norm));
//				 
//				 
//				 assign int_bits=data_norm[15:8];
//				 assign fract_bits=data_norm[7:0];
//				 
//				 always @* begin
//				 
//				 if (fract_bits >= 8'b10000000) // 0.5 in 8-bit fixed-point representation
//            data_in_div = int_bits + 1; // Round up
//        else
//            data_in_div = int_bits; // Round down
//    end
//				 
//				 
//  qdiv #(.Q(8), .N(16)) d1 (.i_dividend(16'b0000000000000001), .i_divisor(data_in_div), .i_start(v_o_norm), .i_clk(clk),
//         .o_quotient_out(data_out), .o_complete(v_o), .o_overflow(o_overflow), .i_reset(reset));
//			
//			
//endmodule
