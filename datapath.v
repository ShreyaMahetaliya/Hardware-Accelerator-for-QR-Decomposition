//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 08:27:04 AM
// Design Name: 
// Module Name: datapath
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


module datapath #(parameter DATA_WIDTH=16, ADDR_WIDTH=4)(
input clk,
input reset,
input [DATA_WIDTH-1:0] A, //value from the tb
input load_input, //tb values loaded into input buffer
input load_q, // load values from output q regs to input q regs for dot product
input incr_oc, // increment outer counter
input incr_ic, // increment inner counter
output done_norm_state, // normalization is done
output done_load, // values are done loading into the input buffer
input read_input, //read input buffer  
input read_modified,// read modified buffer
input dot,//  start dot product
output done_dot,// dot product is done
input  dot_mul,// start multiplication after dot product 
output done_dot_mul,// multiplication after dot product is done
input sub, // start subtraction
output done_sub,// subtraction is done
output oc_eq_zero, // outer counter equal to zero
output oc_eq_one,// outer counter equal to one
output oc_lt_n, // outer counter less than one
input ic_eq_0, // inner counter should become 0 (input)
output ic_eq_one,// inner counter equal to one
output ic_eq_zero,// inner counter equal to zero
output ic_lt_n_minus_oc, // inner counter less than n minus outer counter
output done_load_buff_sub_dot,
input read_input_ds,
input read_modified_ds,
input norm,
output [15:0]q1out, // q vector
output [15:0]q2out,
output [15:0]q3out,
input s_norm,
input s_dot,
input s_sub
    );
  
 logic done_read_ib; // Done reading 3 words from input buffer, only used to set done_acc_norm
 // once set it is enabled for entire state
 logic [DATA_WIDTH-1:0] ib_data_o; //Output data from input buffer
 logic [DATA_WIDTH-1:0] sub_data_o, mul_data_i, dot_data_i, dot_data_q, norm_data_i;
 logic [DATA_WIDTH-1:0] q1out_temp, q2out_temp, q3out_temp; // q temp values are the output of multiply
 logic [DATA_WIDTH-1:0] q1_l, q2_l, q3_l; // q register values taht would be input for dot and multiply after loading into them
 
 
 // Assigning qout values 
 assign q1out= q1out_temp;
 assign q2out= q2out_temp;
 assign q3out= q3out_temp;
 
 logic start_read_ib;
 logic [15:0] sub_data_i;
 assign start_read_ib = (read_input | read_input_ds); // reading input buffer 
 logic done_modified_write, done_modified_read, start_modified_write;
 
  parameter n = 3;
 input_buffer #(DATA_WIDTH, ADDR_WIDTH) ib(.A_i(A),
                                           .clk(clk),
                                           .reset(reset),
                                           .start_write(load_input),
                                           .start_read(start_read_ib),
                                           .done_load(done_load),
                                           .done_read_vector(done_read_ib),
                                           .A_o(ib_data_o));
                                           
 logic [15:0] modified_data_o, buffer_dot_data_i;
 
 //Assigning values to normalization unit based on whether you want to erad from input or modified buffer
 always_comb
 begin
   if (read_input)
      begin
      norm_data_i = ib_data_o;
      end
   else if (read_modified)
      norm_data_i = modified_data_o >>8;
   else
     norm_data_i = 0;
 end                                          
 
 
 logic done_acc_norm; 
 assign done_acc_norm = (done_read_ib & norm) | (done_modified_read & norm); //done_acc of norm state is set after you read 3 values from the input buffer
 
 
 
 logic [DATA_WIDTH-1:0] norm_data_div_o; // value after norm and division
logic o_overflow, yumi_i_norm, v_o_norm;
 logic [15:0] data_norm;
 
 
 logic start_norm; // only is on to just start the norm FSM, then accumalator value is found
 assign start_norm= norm & ~(done_acc_norm); //start normalization should be on only till we read all values from input
 
 normalization nm(.clk_i(clk),
                   .reset_i(reset || ~s_norm), // want to reset when norm state is over
                   .v_i(start_norm), 
                   .done_acc(done_acc_norm), 
                   .A(norm_data_i), 
                   .data_out(norm_data_div_o), 
                   .ready_norm(ready_norm),
                   .v_o(done_normalization), .o_overflow(o_overflow), .yumi_i_norm(yumi_i_norm), .v_o_norm(v_o_norm)
						 , .data_norm(data_norm));
                   
   
   
 logic done_norm_state_temp;                
 assign done_norm_state= done_norm_state_temp;
 
  logic done_load_buffer_norm;
 buffer_3 #(DATA_WIDTH, ADDR_WIDTH) buffer_norm(.A_i(norm_data_i),
                                           .clk(clk),
                                           .reset(reset),
                                           .start_write(norm),
                                           .start_read(done_normalization),
                                           .done_load(done_load_buffer_norm),
                                           .done_read_vector(done_read_buffer_norm),
                                           .A_o(mul_data_i));   
 
 logic start_mul_norm;
 multiplier_b mulb ( .i_multiplicand(norm_data_div_o),
                  .i_multiplier(mul_data_i),
                  .i_start(start_mul_norm),
                  .o_stop(done_multiply),
                  .i_clk(clk),
	              .i_reset(reset),
                  .q1out(q1out_temp),
                  .q2out(q2out_temp),
                  .q3out(q3out_temp));
                   
 assign reset_norm = reset | done_norm_state_temp;
 
 logic done_load_buffer_dot, done_read_buffer_dot, done_dot_temp;
 
 
  always_comb
 begin
   if (read_input_ds)
      buffer_dot_data_i = ib_data_o<<8;
   else if (read_modified_ds)
      buffer_dot_data_i = modified_data_o;
   else
     buffer_dot_data_i = 0;
 end 
 
 
 logic start_buff_dot_sub;
 assign start_buff_dot_sub = (read_input_ds | read_modified_ds) ;// write values into the dot and sub buffer
 
 buffer_3 #(DATA_WIDTH, ADDR_WIDTH) buffer_dot(.A_i(buffer_dot_data_i),
                                           .clk(clk),
                                           .reset(reset),
                                           .start_write(start_buff_dot_sub),
                                           .start_read(dot),
                                           .done_load(done_load_buffer_dot),
                                           .done_read_vector(done_read_buffer_dot),
                                           .A_o(dot_data_i));  

                                        
 buffer_3 #(DATA_WIDTH, ADDR_WIDTH) buffer_sub(.A_i(buffer_dot_data_i),
                                           .clk(clk),
                                           .reset(reset),
                                           .start_write(start_buff_dot_sub),
                                           .start_read(sub),
                                           .done_load(done_load_buffer_sub),
                                           .done_read_vector(done_read_buffer_sub),
                                           .A_o(sub_data_i)); 
                                           
 assign done_load_buff_sub_dot = done_load_buffer_dot |  done_load_buffer_sub;                                      
                                           
 logic done_load_q, done_o_q_i_dot; 
  
 
 load_q lq(.start(load_q),
           .q1(q1out_temp),
           .q2(q2out_temp),
           .q3(q3out_temp),
           .q1_l(q1_l),
           .q2_l(q2_l),
           .q3_l(q3_l),
           .clk(clk),
           .reset(reset),
           .stop(done_load_q)
           );
 
 o_q_i_dot oqi( .start(dot),      //values are read from the loaded q registers 
                .stop(done_o_q_i_dot),// and outputed out ine cycle at a time
                .reset(reset),
                .clk(clk),
                .q1_l(q1_l),
                .q2_l(q2_l),
                .q3_l(q3_l),
                .q_i_dot(dot_data_q)
               );
  logic [15:0] dot_product_o;
 
 logic done_acc_dot, start_dot;
 assign done_acc_dot = done_read_buffer_dot;
 assign start_dot = dot & ~(done_acc_dot);
 
 dot_product dot_p( .clk_i(clk),
                  .reset_i(reset | s_sub), // reset the accumulated
                  .done_acc(done_acc_dot),
                  .A(dot_data_i),
                  .B(dot_data_q),
                  .A_v_i(start_dot),
                  .B_v_i(start_dot),
                  .ready_o(ready_o_dot),
                  .accum(dot_product_o), 
                  .v_o(done_dot),
                  .yumi_i(1'b1));
                  
                                               
   //assign shift_mul_data_i =  mul_data_i * 2**8;
  logic [15:0] shift_mul_data_i;
                                       
 logic [31:0] d1_mul_temp, d2_mul_temp, d3_mul_temp;
 logic [15:0] d1_mul, d2_mul, d3_mul;
 
 assign d1_mul = d1_mul_temp[23:8];
 assign d2_mul = d2_mul_temp[23:8];
 assign d3_mul = d3_mul_temp[23:8]; 

 
// logic [15:0] sub_data_i;
 
                                   
  mul_dot   muld ( .start(dot_mul),
                   .clk(clk),
                   .reset(reset),
                   .q1_l(q1_l),
                   .q2_l(q2_l),
                   .q3_l(q3_l),
                   .dot_val(dot_product_o),
                   .stop(done_dot_mul),
                   .d1_mul(d1_mul_temp),
                   .d2_mul(d2_mul_temp),
                   .d3_mul(d3_mul_temp)
                 );  
                                                                     
 assign done_norm_state_temp = done_multiply & done_read_buffer_norm; //the norm state is done when multiplication is done and we read three values
 
 assign start_mul_norm = done_normalization & s_norm; // starting the multiplication after normalization                                                                    //   from the norm buffer
       
       
  logic [3:0] count_oc, count_ic;      
  assign oc_eq_zero = (count_oc==0)?1:0;
  assign oc_eq_one = (count_oc==1)?1:0;
  assign oc_lt_n = (count_oc<n)?1:0;
  
  assign ic_eq_zero = (count_ic==0)?1:0;
  assign ic_eq_one = (count_ic==1)?1:0;
  assign ic_lt_n_minus_oc = (count_ic<(n-count_oc))?1:0;
  
  
               
  oc_ic_counter oc(.clk(clk),
             .reset(reset),
             .enable(incr_oc),
             .counter(count_oc));  
             
  oc_ic_counter ic(.clk(clk),
             .reset(reset | ic_eq_0), // setting ic to 0 when ic_eq_0 is set
             .enable(incr_ic),
             .counter(count_ic)); 
  
 //logic done_modified_write, done_modified_read, start_modified_write;
 
 
  sub sub_mod( .start(sub),
           .stop(done_sub),
           .reset(reset),
           .clk(clk),
           .sub1(sub_data_i),
           .d1_mul(d1_mul), 
           .d2_mul(d2_mul),
           .d3_mul(d3_mul),
           .sub_o(sub_data_o),
           .start_w(start_modified_write));
    
 
 
 modified_buffer mod_buf( .A_i(sub_data_o),
                          .clk(clk),
                          .reset(reset),
                          .start_write(start_modified_write),
                          .start_read(read_modified | read_modified_ds),
                          .done_load(done_modified_write),
                          .done_read_vector(done_modified_read),
                          .A_o(modified_data_o));


endmodule
 
