vsim -voptargs=+acc work.exhaustive_mc_tb


add wave -position insertpoint \
sim:/exhaustive_mc_tb/* \
sim:/exhaustive_mc_tb/mc_top/open_empty \
sim:/exhaustive_mc_tb/mc_top/start \
sim:/exhaustive_mc_tb/mc_top/next_inst/semantics_inst/state_r \
sim:/exhaustive_mc_tb/mc_top/ask_next \
sim:/exhaustive_mc_tb/mc_top/t_ready \
sim:/exhaustive_mc_tb/mc_top/target \
sim:/exhaustive_mc_tb/mc_top/next_inst/has_next \
sim:/exhaustive_mc_tb/mc_top/t_is_last \
sim:/exhaustive_mc_tb/mc_top/schedule_en \
sim:/exhaustive_mc_tb/mc_top/ask_push \
sim:/exhaustive_mc_tb/mc_top/t_out \
sim:/exhaustive_mc_tb/mc_top/is_scheduled \
sim:/exhaustive_mc_tb/mc_top/ask_src \
sim:/exhaustive_mc_tb/mc_top/s_ready \
sim:/exhaustive_mc_tb/mc_top/source_in \
sim:/exhaustive_mc_tb/mc_top/open_is_empty \
sim:/exhaustive_mc_tb/mc_top/pop_en \
sim:/exhaustive_mc_tb/mc_top/pop_ctrl_inst/state_c \
sim:/exhaustive_mc_tb/mc_top/closed_inst/state_c.memory \

