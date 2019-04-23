vsim -voptargs=+acc work.mc_top_exh_h_dfs_tb
log * -r 
run -all 


add wave -position insertpoint sim:/mc_top_exh_h_dfs_tb/mc_top/*
