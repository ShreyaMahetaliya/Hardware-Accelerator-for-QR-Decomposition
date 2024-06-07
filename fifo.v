//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 04:20:58 PM
// Design Name: 
// Module Name: FIFO
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


//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 01:16:32 PM
// Design Name: 
// Module Name: fifo
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


/* FIFO buffer FWFT implementation for specified data and address
 * bus widths based on internal register file and FIFO controller.
 * Inputs: 1-bit rd removes head of buffer and 1-bit wr writes
 * w_data to the tail of the buffer.
 * Outputs: 1-bit empty and full indicate the status of the buffer
 * and r_data holds the value of the head of the buffer (unless empty).
 */
module fifo #(parameter DATA_WIDTH=32, ADDR_WIDTH=2, VECTOR_LEN=1)
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
	fifo_ctrl #(ADDR_WIDTH, VECTOR_LEN) c_unit (.*);
	reg_file #(DATA_WIDTH, ADDR_WIDTH) r_unit (.*);
	
endmodule  // fifo


/* FIFO controller to manage a register file as a circular queue.
 * Manipulates output read and write addresses based on 1-bit
 * read (rd) and write (wr) requests and current buffer status
 * signals empty and full.
 */
module fifo_ctrl #(parameter ADDR_WIDTH=4, VECTOR_LEN=1)
                 (clk, reset, rd, wr, empty, full, w_addr, r_addr);
	
	input  logic clk, reset, rd, wr;
	output logic empty, full;
	output logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	
	
	// signal declarations
	logic [ADDR_WIDTH-1:0] rd_ptr, rd_ptr_next;
	logic [ADDR_WIDTH-1:0] wr_ptr, wr_ptr_next;
	logic empty_next, full_next;
	logic vector_increment = VECTOR_LEN;
	
	// output assignments
	assign w_addr = wr_ptr;
	assign r_addr = rd_ptr;
	
	// fifo controller logic
	always_ff @(posedge clk) begin
		if (reset)
			begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				full   <= 0;
				empty  <= 1;
                            
			end
		else
			begin
				wr_ptr <= wr_ptr_next;
				rd_ptr <= rd_ptr_next;
				full   <= full_next;
				empty  <= empty_next;
                           
			end
	end  // always_ff
	
	// next state logic
	always_comb begin
		// default to keeping the current values
		rd_ptr_next = rd_ptr;
		wr_ptr_next = wr_ptr;
		empty_next = empty;
		full_next = full;
		case ({rd, wr})
			2'b11:  // read and write
				begin
					rd_ptr_next = rd_ptr + 1'b1;
					wr_ptr_next = wr_ptr + 1'b1;
				end
			2'b10:  // read
				if (~empty)
					begin
						rd_ptr_next = rd_ptr + 1'b1;
						if (rd_ptr_next == wr_ptr)
							empty_next = 1;
						full_next = 0;
					end
			2'b01:  // write
				if (~full)
					begin
						wr_ptr_next = wr_ptr + 1'b1;
						empty_next = 0;
						if (wr_ptr_next == rd_ptr)
							full_next = 1;
					end
			2'b00: ; // no change
		endcase
	end  // always_comb
	
endmodule  // fifo_ctrl


/* Register file module for specified data and address bus widths.
 * Asynchronous read port (r_addr -> r_data) and synchronous write
 * port (w_data -> w_addr if w_en).
 */
module reg_file #(parameter DATA_WIDTH=8, ADDR_WIDTH=2)
                (clk, w_data, w_en, w_addr, r_addr, r_data);

	input  logic clk, w_en;
	input  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	input  logic [DATA_WIDTH-1:0] w_data;
	output logic [DATA_WIDTH-1:0] r_data;
	
	// array declaration (registers)
	logic [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];
	
	// write operation (synchronous)
	always_ff @(posedge clk)
	   if (w_en)
		   array_reg[w_addr] <= w_data;
	
	// read operation (asynchronous)
	assign r_data = array_reg[r_addr];
	
endmodule  // reg_file
