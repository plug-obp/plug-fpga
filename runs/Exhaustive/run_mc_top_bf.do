vsim -voptargs=+acc work.mc_top_bf_tb
log * -r 
run -all 


add wave -position insertpoint sim:/mc_top_bf_tb/mc_top/*
