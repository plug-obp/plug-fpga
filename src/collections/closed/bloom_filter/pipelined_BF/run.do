vsim -voptargs=+acc work.pipelined_bf_tb
add log -r /*
add wave -position insertpoint  \
sim:/pipelined_bf_tb/clk \
sim:/pipelined_bf_tb/reset \
sim:/pipelined_bf_tb/add_enable \
sim:/pipelined_bf_tb/data_in \
sim:/pipelined_bf_tb/clear_table \
sim:/pipelined_bf_tb/is_in \
sim:/pipelined_bf_tb/is_full \
sim:/pipelined_bf_tb/is_done \
sim:/pipelined_bf_tb/set_i/state_r_ar \
sim:/pipelined_bf_tb/set_i/inputs_c \
sim:/pipelined_bf_tb/set_i/controler/* \



run 500ns


