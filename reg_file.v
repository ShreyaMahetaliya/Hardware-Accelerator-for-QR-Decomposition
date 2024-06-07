module reg_file #(parameter DATA_WIDTH=8, ADDR_WIDTH=2)
                (clk, reset, w_data, w_en, w_addr, r_addr, r_data);

	input  logic clk, w_en, reset;
	input  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	input  logic [DATA_WIDTH-1:0] w_data;
	output logic [DATA_WIDTH-1:0] r_data;
	
	// array declaration (registers)
	logic [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];
	
	// write operation (synchronous)
	always_ff @(posedge clk) begin
           if (reset) begin
           // array_reg[w_addr] <= 1;
           integer i;
           for (i=0; i<2**ADDR_WIDTH; i=i+1)
                 array_reg[i] <=0;
            end
	   else if (w_en)
		   array_reg[w_addr] <= w_data;
	end
	// read operation (asynchronous)
	assign r_data = array_reg[r_addr];
	
endmodule  // reg_file
