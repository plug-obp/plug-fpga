vsim -voptargs=+acc work.exhaustive_mc_tb_dfs
log * -r 
run 20 ms


add wave -position insertpoint \
sim:/exhaustive_mc_tb_dfs/* \
sim:/exhaustive_mc_tb_dfs/mc_top/open_empty \
sim:/exhaustive_mc_tb_dfs/mc_top/start \
sim:/exhaustive_mc_tb_dfs/mc_top/next_inst/semantics_inst/state_r \
sim:/exhaustive_mc_tb_dfs/mc_top/ask_next \
sim:/exhaustive_mc_tb_dfs/mc_top/t_ready \
sim:/exhaustive_mc_tb_dfs/mc_top/target \
sim:/exhaustive_mc_tb_dfs/mc_top/next_inst/has_next \
sim:/exhaustive_mc_tb_dfs/mc_top/t_is_last \
sim:/exhaustive_mc_tb_dfs/mc_top/schedule_en \
sim:/exhaustive_mc_tb_dfs/mc_top/ask_push \
sim:/exhaustive_mc_tb_dfs/mc_top/t_out \
sim:/exhaustive_mc_tb_dfs/mc_top/is_scheduled \
sim:/exhaustive_mc_tb_dfs/mc_top/ask_src \
sim:/exhaustive_mc_tb_dfs/mc_top/s_ready \
sim:/exhaustive_mc_tb_dfs/mc_top/source_in \
sim:/exhaustive_mc_tb_dfs/mc_top/open_is_empty \
sim:/exhaustive_mc_tb_dfs/mc_top/pop_en \
sim:/exhaustive_mc_tb_dfs/mc_top/pop_ctrl_inst/state_c \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/state_c.memory \

add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/add_enable
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/data_in
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/hash_funct/hash_key \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/hash_funct/hash_ok
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/hash_funct/hash_en
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/hash_funct/data



add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/controler/add_enable
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/controler/state_c
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/controler/rf_p_w_addr \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/controler/rf_p_r_addr
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/controler/rf_p_r_ok
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/is_in \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/is_full \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/is_done
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/rf_p_r_data \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/rf_p_w_data \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/rf_p_w_addr
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/reg_file_isFilled/d_out
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/reg_file_isFilled/r_ok
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/reg_file_isFilled/addr_r
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/reg_file_isFilled/re
add wave -position insertpoint  \
sim:/exhaustive_mc_tb_dfs/mc_top/closed_inst/reg_file_isFilled/we

