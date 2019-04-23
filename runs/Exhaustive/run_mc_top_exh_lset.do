vsim -voptargs=+acc work.mc_top_exh_lset_tb
log * -r 
run -all 


add wave -position insertpoint \
sim:/mc_top_exh_lset_tb/* \
sim:/mc_top_exh_lset_tb/mc_top/open_is_empty \
sim:/mc_top_exh_lset_tb/mc_top/next_inst/semantics_inst/state_r \
sim:/mc_top_exh_lset_tb/mc_top/ask_next \
sim:/mc_top_exh_lset_tb/mc_top/t_ready \
sim:/mc_top_exh_lset_tb/mc_top/target \
sim:/mc_top_exh_lset_tb/mc_top/next_inst/has_next \
sim:/mc_top_exh_lset_tb/mc_top/t_is_last \
sim:/mc_top_exh_lset_tb/mc_top/schedule_en \
sim:/mc_top_exh_lset_tb/mc_top/ask_push \
sim:/mc_top_exh_lset_tb/mc_top/t_out \
sim:/mc_top_exh_lset_tb/mc_top/is_scheduled \
sim:/mc_top_exh_lset_tb/mc_top/ask_src \
sim:/mc_top_exh_lset_tb/mc_top/s_ready \
sim:/mc_top_exh_lset_tb/mc_top/source_in \
sim:/mc_top_exh_lset_tb/mc_top/open_is_empty \
sim:/mc_top_exh_lset_tb/mc_top/pop_en \
sim:/mc_top_exh_lset_tb/mc_top/pop_ctrl_inst/state_c \


