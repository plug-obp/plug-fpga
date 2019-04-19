vsim -voptargs=+acc work.exhaustive_mc_tb_hashmap_hls
log * -r 
run -all 


add wave -position insertpoint \
sim:/exhaustive_mc_tb_hashmap_hls/* \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/start \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/next_inst/semantics_inst/state_r \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/ask_next \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/t_ready \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/target \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/next_inst/has_next \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/t_is_last \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/schedule_en \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/ask_push \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/t_out \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/is_scheduled \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/ask_src \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/s_ready \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/source_in \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/open_is_empty \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/pop_en \
sim:/exhaustive_mc_tb_hashmap_hls/mc_top/pop_ctrl_inst/state_c \


