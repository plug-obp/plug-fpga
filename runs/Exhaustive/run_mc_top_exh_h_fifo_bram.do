vsim -voptargs=+acc work.mc_top_exh_h_fifo_bram_tb
log * -r 
run -all 


add wave -position insertpoint sim:/mc_top_exh_h_fifo_bram_tb/mc_top/*
