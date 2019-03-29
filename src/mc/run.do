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
run 10000ns