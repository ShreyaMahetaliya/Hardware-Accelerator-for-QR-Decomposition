//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 07:30:02 AM
// Design Name: 
// Module Name: modified_fifo
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


module modified_fifo #(parameter DATA_WIDTH=32, ADDR_WIDTH=2, VECTOR_LEN=3)
            (clk, reset, rd, wr, empty, full, w_data, r_data);

	input  logic clk, reset, rd, wr;
	output logic empty, full;
	input  logic [DATA_WIDTH-1:0] w_data;
	output logic [DATA_WIDTH-1:0] r_data;
	
	// signal declarations
	logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	logic w_en;
	
	// enable write only when FIFO is not full
	// or if reading and writing simultaneously
	assign w_en = wr & (~full | rd);
	
	// instantiate FIFO controller and register file
	fifo_ctrl #(ADDR_WIDTH,VECTOR_LEN) c_unit (.*);
	reg_file #(DATA_WIDTH, ADDR_WIDTH) r_unit (.*);
endmodule  // fifo
