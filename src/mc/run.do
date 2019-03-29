restart -f
force -freeze sim:/mc_sem_and_closed/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/mc_sem_and_closed/reset 0 0
force -freeze sim:/mc_sem_and_closed/reset_n 0 0
force -freeze sim:/mc_sem_and_closed/start 0 0
run 100ns
force -freeze sim:/mc_sem_and_closed/reset_n 1 0
run 100ns
force -freeze sim:/mc_sem_and_closed/start 1 0
run 100ns
force -freeze sim:/mc_sem_and_closed/start 0 0
run 10000ns