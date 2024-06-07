//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2024 08:09:54 AM
// Design Name: 
// Module Name: buffer_3
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


module buffer_3 #(parameter DATA_WIDTH=16, ADDR_WIDTH=2)(

input [DATA_WIDTH-1:0] A_i,
input clk,reset,
input start_write,
input start_read,
output done_load,
output done_read_vector,
output [DATA_WIDTH-1:0] A_o
    );
 logic rd,wr; 
 logic [0:1] count_read;
 logic [0:1] count_write;
 logic [DATA_WIDTH-1:0] r_data, w_data;
 logic full, empty, done_temp_read, done_temp_write;  
 
 
assign w_data = A_i;
assign A_o = r_data;
assign done_read_vector = done_temp_read;

assign done_load = done_temp_write;
always_ff @(posedge clk)
begin
//all loads will happen in one go

if(reset)
  begin
  done_temp_read <=0;
  done_temp_write <=0;
  count_read <=0;
  count_write <= 0;
 wr<=0;
  rd<=0;
  end
else
 begin
 
if (~start_write)
begin
count_write<= 0;
wr<=0;
done_temp_write <=0;
end
else if (count_write == 2'b11)//once 9 values are written(one in every cycle)
  begin
  done_temp_write <= 1'b1;  //you are done writing
  wr<=1'b0;
  end
else if (start_write)  
 begin                  
 count_write <= count_write+ 1'b1;
 wr<=1'b1;
 end
else     //reset counter
 begin
 count_write<= 0;
 wr<=0;
 end

  
  //if value is being requested, then counter will increment 
// till 3, until the 
if (~start_read)
 begin
 count_read<= 0;
 rd<=0;
 done_temp_read <=0;
 end
else if (count_read == 2'b10)
  begin
  done_temp_read <= 1'b1;
  count_read <= count_read+ 1'b1;
  rd <= 1'b1;
  end
else if (count_read ==3) // to enable rd for one more cycle so that it points to
  begin                  // the next address before it reads again
   done_temp_read <= 1'b1;
   rd <= 0;
   end
else if (start_read && count_read !=2'b11)   
  begin                 
 count_read <= count_read+ 1'b1;
  rd <= 1'b1;
 end
else //reset counter
 begin
 count_read <= 0;
 rd <= 0;
 done_temp_read <=0;
 end
 
// read is asserted until
//if (start_read && ~done_temp_read )
  // rd<=1'b1;
//else
 // begin
 // rd<=1'b0;
 // end
end
end
fifo   #(DATA_WIDTH,ADDR_WIDTH) in_buffer (.*);
endmodule

