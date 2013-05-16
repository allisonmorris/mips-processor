/*

Control bundle:

 0 = reg_write_en
 1 = reg_write_data_mux_sel -- wrdata mux ^^ writeback
 2 = ram_read_en
 3 = ram_write_en
 4 = ram_data_size
 5 = ram_data_signed
 6 = skip_ram_mux_sel -- data mem mux ^^ memory
 7 = alu_func 
 8 =
 9
10  
11
12        ^^ execute
13 = reg_write_dest_mux_sel -- instr mux
14
15 = alu_in_a_mux_sel -- shift mux
16 = alu_in_b_mux_sel -- alu mux
17 = skip_imm_upshift_mux_sel -- lui mux
18 = imm_signed_mux_sel -- extender mux
19 = jump_branch_mux_sel
20 = branch_mux_sel
21 = jump_mux_sel
22 = jump_imm_reg_mux_sel  
23 = reg_write_en
24 = reg_write_data_mux_sel  ^^ decode/writeback
25 = pc_inc_en
26 = instr_nop_mux_sel  ^^ fetch


Data bundle = 

 0 = pc_next_seq
 1 = reg_write_num
 2 = reg_write_data
 3 = 


*/