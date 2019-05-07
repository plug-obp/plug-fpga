vsim -voptargs=+acc work.bounded_mc_tb
log * -r 


add wave -position insertpoint \
sim:/bounded_mc_tb/* \
sim:/bounded_mc_tb/mc_top/open_empty \
sim:/bounded_mc_tb/mc_top/start \
sim:/bounded_mc_tb/mc_top/next_inst/semantics_inst/state_r \
sim:/bounded_mc_tb/mc_top/ask_next \
sim:/bounded_mc_tb/mc_top/t_ready \
sim:/bounded_mc_tb/mc_top/target \
sim:/bounded_mc_tb/mc_top/next_inst/has_next \
sim:/bounded_mc_tb/mc_top/t_is_last \
sim:/bounded_mc_tb/mc_top/schedule_en \
sim:/bounded_mc_tb/mc_top/ask_push \
sim:/bounded_mc_tb/mc_top/t_out \
sim:/bounded_mc_tb/mc_top/is_scheduled \
sim:/bounded_mc_tb/mc_top/ask_src \
sim:/bounded_mc_tb/mc_top/s_ready \
sim:/bounded_mc_tb/mc_top/source_in \
sim:/bounded_mc_tb/mc_top/src_is_last \
sim:/bounded_mc_tb/mc_top/open_is_empty \
sim:/bounded_mc_tb/mc_top/pop_en \
sim:/bounded_mc_tb/mc_top/pop_ctrl_inst/state_c \
sim:/bounded_mc_tb/mc_top/closed_inst/state_c.memory \

