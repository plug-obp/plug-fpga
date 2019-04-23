vsim -voptargs=+acc work.mc_top_exh_hhls_tb
log * -r 
run -all 


add wave -position insertpoint \
sim:/mc_top_exh_hhls_tb/* \

add wave -position insertpoint  \
sim:/mc_top_exh_hhls_tb/mc_top/start \
sim:/mc_top_exh_hhls_tb/mc_top/is_bounded \
sim:/mc_top_exh_hhls_tb/mc_top/sim_end \
sim:/mc_top_exh_hhls_tb/mc_top/previous_is_added \
sim:/mc_top_exh_hhls_tb/mc_top/target \
sim:/mc_top_exh_hhls_tb/mc_top/t_ready \
sim:/mc_top_exh_hhls_tb/mc_top/t_is_last \
sim:/mc_top_exh_hhls_tb/mc_top/c_is_full \
sim:/mc_top_exh_hhls_tb/mc_top/ask_push \
sim:/mc_top_exh_hhls_tb/mc_top/t_out \
sim:/mc_top_exh_hhls_tb/mc_top/target_is_known \
sim:/mc_top_exh_hhls_tb/mc_top/s_ready \
sim:/mc_top_exh_hhls_tb/mc_top/is_scheduled \
sim:/mc_top_exh_hhls_tb/mc_top/ask_src \
sim:/mc_top_exh_hhls_tb/mc_top/source_in \
sim:/mc_top_exh_hhls_tb/mc_top/swap \
sim:/mc_top_exh_hhls_tb/mc_top/src_is_last \
sim:/mc_top_exh_hhls_tb/mc_top/ask_next \
sim:/mc_top_exh_hhls_tb/mc_top/schedule_en \
sim:/mc_top_exh_hhls_tb/mc_top/open_is_empty \
sim:/mc_top_exh_hhls_tb/mc_top/pop_en \
sim:/mc_top_exh_hhls_tb/mc_top/bound_is_reached \
sim:/mc_top_exh_hhls_tb/mc_top/open_is_full


