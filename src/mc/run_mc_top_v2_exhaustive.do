vsim -voptargs=+acc work.mc_top_v2_exhaustive
log * -r


add wave -position insertpoint  \
sim:/mc_top_v1/clk \
sim:/mc_top_v1/open_empty \
sim:/mc_top_v1/start \
sim:/mc_top_v1/next_inst/semantics_inst/state_r \
sim:/mc_top_v1/ask_next \
sim:/mc_top_v1/t_ready \
sim:/mc_top_v1/target \
sim:/mc_top_v1/next_inst/has_next \
sim:/mc_top_v1/t_is_last \
sim:/mc_top_v1/schedule_en \
sim:/mc_top_v1/ask_push \
sim:/mc_top_v1/t_out \
sim:/mc_top_v1/is_scheduled \
sim:/mc_top_v1/ask_src \
sim:/mc_top_v1/s_ready \
sim:/mc_top_v1/source_in \
sim:/mc_top_v1/src_is_last \
sim:/mc_top_v1/open_is_empty \
sim:/mc_top_v1/pop_en \
sim:/mc_top_v1/pop_ctrl_inst/state_c \
sim:/mc_top_v1/closed_inst/state_c.memory \
sim:/mc_top_v1/bound_is_reached \

restart -f
force -freeze sim:/mc_top_v1/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/mc_top_v1/reset 0 0
force -freeze sim:/mc_top_v1/reset_n 0 0
force -freeze sim:/mc_top_v1/start 0 0
run 100ns
force -freeze sim:/mc_top_v1/reset_n 1 0
run 100ns
force -freeze sim:/mc_top_v1/start 1 0
run 100ns
force -freeze sim:/mc_top_v1/start 0 0
run 20000ns