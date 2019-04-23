vsim -voptargs=+acc work.exhaustive_mc_tb_hashmap_hls
log * -r 
run -all 


add wave -position insertpoint \
sim:/exhaustive_mc_tb_hashmap_hls/* \

add wave -position insertpoint  \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/start \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/is_bounded \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/sim_end \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/previous_is_added \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/target \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/t_ready \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/t_is_last \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/c_is_full \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/ask_push \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/t_out \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/target_is_known \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/s_ready \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/is_scheduled \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/ask_src \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/source_in \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/swap \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/src_is_last \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/ask_next \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/schedule_en \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/open_is_empty \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/pop_en \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/bound_is_reached \
sim:/exhaustive_mc_tb_hashmap_pp_e/mc_top/open_is_full


