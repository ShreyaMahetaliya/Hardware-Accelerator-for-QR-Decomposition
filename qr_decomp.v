//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 03:31:57 PM
// Design Name: 
// Module Name: qr_decomp
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


module qr_decomp #(parameter DATA_WIDTH=16, ADDR_WIDTH=4)(
input [DATA_WIDTH-1:0] A,
input clk,reset, start,
output done,
output [DATA_WIDTH-1:0] q1out,
output [DATA_WIDTH-1:0] q2out,
output  [DATA_WIDTH-1:0] q3out
    );
   
    logic load_input;
    logic done_load;
    logic oc_eq_zero;
    logic done_norm_state;
    logic done_dot;
    logic done_sub;
    logic done_dot_mul;
    logic dot_mul;
    logic sub;
    logic incr_oc;
    logic oc_lt_n;
    logic ic_eq_0;
    logic load_q;
    logic oc_eq_one;
    logic dot;
    logic incr_ic;
    logic ic_eq_one;
    logic store_modified;
    logic ic_lt_n_minus_oc;
    logic ic_eq_zero;
    logic read_input; // needs to be defined, tells that data needs to be read
    logic read_modified ;
    logic read_input_ds; // needs to be defined, tells that data needs to be read
    logic read_modified_ds ;
    logic done_load_buff_sub_dot;
    logic norm;
    logic s_norm;
    logic s_dot;
    logic s_sub;
    
    controller c1(.*);
    datapath #(DATA_WIDTH, ADDR_WIDTH) d1(.*);
    assign done=done_load;
endmodule



//`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 05/19/2024 03:54:09 PM
//// Design Name: 
//// Module Name: qr_decomp_tb
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
//module qrdecomp_tb;
//
//logic [15:0] A;
//logic clk,reset, start, done;
//logic [15:0] q1out;
//logic [15:0] q2out;
//logic [15:0] q3out;
//
//initial begin
//$fsdbDumpfile("waveform.fsdb");
//$fsdbDumpvars();
//
//end
//
////initial begin
////    clk = 0;
////    forever #25 clk = ~clk;
////end
//
//parameter clk_period=20000;
//initial begin
//    clk <= 0;
//    forever #(clk_period/2)clk <= ~clk;
//end
//
//initial begin
//  //  reset = 1;
//  reset <= 0;
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
// reset<=1;
//  
//    A <= 0;
//    start<=0;
//	@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//@(negedge clk);
//
//   reset = 0;
//   start=1;
//        @(negedge clk);
//		  @(negedge clk);
//     A=1;  
//@(negedge clk);	  
//    A = 2;
//	 @(negedge clk);
//    A=3; 
//@(negedge clk);	 
//    A=4;
//	 @(negedge clk);
//    A=5;
//	 @(negedge clk);
//    A=6;
//	 @(negedge clk);
//    A=7;
//	 @(negedge clk);
//    A=8;
//	 @(negedge clk);
//    A=9;
//
//    
// 
//   repeat (30000)	  
// @(posedge clk);  
////    @(posedge clk);
//    $finish();
//end
//
//qr_decomp qr(.*);
//initial begin
//$monitor("q1=%h, q2=%h, q3=%h", q1out, q2out, q3out);
//end
//endmodule
