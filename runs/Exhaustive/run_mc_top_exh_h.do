vsim -voptargs=+acc work.mc_top_exh_h_tb
log * -r 
run -all 


add wave -position insertpoint \
sim:/mc_top_exh_h_tb/* \
sim:/mc_top_exh_h_tb/mc_top/open_is_empty \
sim:/mc_top_exh_h_tb/mc_top/next_inst/semantics_inst/state_r \
sim:/mc_top_exh_h_tb/mc_top/ask_next \
sim:/mc_top_exh_h_tb/mc_top/t_ready \
sim:/mc_top_exh_h_tb/mc_top/target \
sim:/mc_top_exh_h_tb/mc_top/next_inst/has_next \
sim:/mc_top_exh_h_tb/mc_top/t_is_last \
sim:/mc_top_exh_h_tb/mc_top/schedule_en \
sim:/mc_top_exh_h_tb/mc_top/ask_push \
sim:/mc_top_exh_h_tb/mc_top/t_out \
sim:/mc_top_exh_h_tb/mc_top/is_scheduled \
sim:/mc_top_exh_h_tb/mc_top/ask_src \
sim:/mc_top_exh_h_tb/mc_top/s_ready \
sim:/mc_top_exh_h_tb/mc_top/source_in \
sim:/mc_top_exh_h_tb/mc_top/open_is_empty \
sim:/mc_top_exh_h_tb/mc_top/pop_en \
sim:/mc_top_exh_h_tb/mc_top/pop_ctrl_inst/state_c \

add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/add_enable
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/data_in
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/hash_funct/hash_key \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/hash_funct/hash_ok
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/hash_funct/hash_en
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/hash_funct/data



add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/controler/add_enable
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/controler/state_c
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/controler/rf_p_w_addr \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/controler/rf_p_r_addr
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/controler/rf_p_r_ok
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/is_in \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/is_full \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/is_done
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/rf_p_r_data \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/rf_p_w_data \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/rf_p_w_addr
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/reg_file_isFilled/d_out
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/reg_file_isFilled/r_ok
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/reg_file_isFilled/addr_r
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/reg_file_isFilled/re
add wave -position insertpoint  \
sim:/mc_top_exh_h_tb/mc_top/closed_inst/reg_file_isFilled/we

