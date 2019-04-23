vsim -voptargs=+acc work.bf_mc_tb
log * -r 


add wave -noupdate /bf_mc_tb/clk
add wave -noupdate /bf_mc_tb/reset
add wave -noupdate /bf_mc_tb/reset_n
add wave -noupdate /bf_mc_tb/start
add wave -noupdate /bf_mc_tb/simulation_end
add wave -noupdate /bf_mc_tb/clk
add wave -noupdate /bf_mc_tb/reset
add wave -noupdate /bf_mc_tb/reset_n
add wave -noupdate /bf_mc_tb/start
add wave -noupdate /bf_mc_tb/simulation_end
add wave -noupdate /bf_mc_tb/mc_top/target
add wave -noupdate /bf_mc_tb/mc_top/t_ready
add wave -noupdate /bf_mc_tb/mc_top/ask_push
add wave -noupdate /bf_mc_tb/mc_top/t_out
add wave -noupdate /bf_mc_tb/mc_top/target_is_known
add wave -noupdate /bf_mc_tb/mc_top/source_in
add wave -noupdate /bf_mc_tb/mc_top/src_is_last
add wave -noupdate /bf_mc_tb/mc_top/ask_next
add wave -noupdate /bf_mc_tb/mc_top/open_is_empty
add wave -noupdate /bf_mc_tb/mc_top/pop_en
add wave -noupdate /bf_mc_tb/mc_top/next_inst/semantics_inst/state_c.source_index
add wave -noupdate /bf_mc_tb/mc_top/next_inst/ctrl_inst/state_c
add wave -noupdate /bf_mc_tb/mc_top/schedule_en
add wave -noupdate /bf_mc_tb/mc_top/sched_inst/is_scheduled
add wave -noupdate /bf_mc_tb/mc_top/t_out
add wave -noupdate /bf_mc_tb/mc_top/sched_inst/state_c
add wave -noupdate /bf_mc_tb/mc_top/sched_inst/t_ready
add wave -noupdate /bf_mc_tb/mc_top/sched_inst/schedule_en
add wave -noupdate /bf_mc_tb/mc_top/sched_inst/is_scheduled