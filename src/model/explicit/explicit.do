restart
force -freeze sim:/explicit_interpreter/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/explicit_interpreter/reset 0 0
force -freeze sim:/explicit_interpreter/reset_n 0 0
force -freeze sim:/explicit_interpreter/initial_enable 0 0
force -freeze sim:/explicit_interpreter/next_enable 0 0
force -freeze sim:/explicit_interpreter/source_in 6'h00 0
run 100ns
force -freeze sim:/explicit_interpreter/reset_n 1 0
run 100ns
force -freeze sim:/explicit_interpreter/initial_enable 1 0
run 300ns
force -freeze sim:/explicit_interpreter/initial_enable 0 0
run 200ns
force -freeze sim:/explicit_interpreter/next_enable 1 0
run 400ns