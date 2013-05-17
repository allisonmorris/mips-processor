/*

Control bundle:

 0 = reg_write_en
 1 = reg_write_data_mux_sel -- wrdata mux ^^ writeback
 2 = ram_read_en
 3 = ram_write_en
 4 = ram_data_size
 5 = 
 6 = ram_data_signed
 7 = skip_ram_mux_sel -- data mem mux ^^ memory
 8 = alu_func 
 9 =
10
11  
12
13        ^^ execute
14 = reg_write_dest_mux_sel -- instr mux
15
16 = alu_in_a_mux_sel -- shift mux
17 = alu_in_b_mux_sel -- alu mux
18 = skip_imm_upshift_mux_sel -- lui mux
19 = imm_signed_mux_sel -- extender mux
20 = jump_branch_mux_sel
21 = branch_mux_sel
22 = jump_mux_sel
23 = jump_imm_reg_mux_sel  
24 = reg_write_en
25 = reg_write_data_mux_sel  ^^ decode/writeback
26 = pc_inc_en
27 = instr_nop_mux_sel  ^^ fetch


Data bundle = 

 0 = pc_next_seq
 1 = reg_write_num
 2 = reg_write_data
 3 = 


*/