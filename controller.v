//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 04:11:58 AM
// Design Name: 
// Module Name: controller
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

module controller(
    input start,
    input clk,
    input reset,
    output load_input,
    input done_load,
    input done_norm_state,
    input oc_eq_zero,
    output incr_oc,
    input oc_lt_n,
    input ic_eq_zero,
    output load_q,
    input oc_eq_one,
    input done_dot,
    input done_dot_mul ,
    input done_sub,
    output dot,
    output dot_mul,
    output sub,
    output incr_ic,
    input ic_eq_one,
    input ic_lt_n_minus_oc,
    input done_load_buff_sub_dot,
    output norm,
    output ic_eq_0,
    output read_input, // needs to be defined, tells that data needs to be read
    output read_modified ,  // from input buffer
    output read_modified_ds,
    output read_input_ds,
    output s_norm,
    output s_dot,
    output s_sub
    
    );
                      ///0    1         2        3         4         5         6        7        8          9                   a
    enum logic [3:0] {S_idle,S_load_reg,S_norm, S_wait_1 ,S_incr_oc,S_wait_2, S_dot, S_dot_mul, S_incr_ic,S_load_buff_sub_dot,S_wait_3, S_done, S_eq_0, S_sub} ps,ns;
//b       c       
    
    always_ff @(posedge clk)
    if (reset)
       ps <= S_idle;
    else
       ps <= ns;
       
    always_comb
       case(ps)
           S_idle: ns = start ? S_load_reg:S_idle;
           S_load_reg: ns = done_load ? S_norm:S_load_reg;
           S_norm: ns = done_norm_state? S_wait_1:S_norm;
           S_wait_1: ns = (ic_eq_one & ic_lt_n_minus_oc)? S_load_buff_sub_dot:S_incr_oc;
           S_incr_oc: ns = oc_lt_n ? S_wait_2:S_done;
           S_wait_2: ns = S_load_buff_sub_dot;
           //S_load_buff_sub_dot: ns = done_load_buff_sub_dot ? S_dot:S_load_buff_sub_dot;
           S_load_buff_sub_dot: ns = done_load_buff_sub_dot ? S_incr_ic:S_load_buff_sub_dot;
           S_incr_ic: ns = S_dot;
           S_dot: ns = done_dot ? S_dot_mul : S_dot;
           S_dot_mul: ns = done_dot_mul ? S_sub : S_dot_mul;
           S_sub : ns = done_sub ? (ic_eq_one?S_norm:S_wait_3) : S_sub;
           S_wait_3:ns = ic_lt_n_minus_oc ? S_load_buff_sub_dot: S_incr_oc;
           S_done: ns = reset ? S_idle:S_done;
           default: ns=S_idle;
        endcase 
    assign load_input = (ps==S_load_reg);
    assign read_input= ((ps==S_norm) & oc_eq_zero);
    assign read_modified = ((ps==S_norm) & ~oc_eq_zero);
    assign incr_oc = (ps==S_incr_oc);
    assign load_q = (ps==S_wait_2) & ic_eq_zero;
    //assign dot_input = (ps==S_dot);
    assign incr_ic = (ps==S_incr_ic);
    assign ic_eq_0 = (ps==S_wait_3) & ~ic_lt_n_minus_oc;
    assign dot_mul = (ps==S_dot_mul);
    assign dot = (ps==S_dot);
    assign sub = (ps==S_sub);
    assign norm = (ps==S_norm);
    assign read_input_ds =((ps==S_load_buff_sub_dot) & oc_eq_one);
    assign read_modified_ds = ((ps==S_load_buff_sub_dot) & ~oc_eq_one);
    assign s_norm = (ps==S_norm);
    assign s_dot = (ps==S_dot);
    assign s_sub = (ps==S_sub);
    
endmodule
