vsim -voptargs=+acc work.hash(a)

add wave -position insertpoint  \
sim:/hash/clk \
sim:/hash/reset \
sim:/hash/reset_n \
sim:/hash/data \
sim:/hash/hash_en \
sim:/hash/hash_key \
sim:/hash/hash_ok \
sim:/hash/state_c \
sim:/hash/output_c \
sim:/hash/state_r


force -freeze sim:/hash/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/hash/reset 0 0
force -freeze sim:/hash/reset_n 0 0
force -freeze sim:/hash/hash_en 0 0
run 100 ns 
force -freeze sim:/hash/reset_n 1 0

run 200ns 
force -freeze sim:/hash/data 32'h0000000 0
force -freeze sim:/hash/hash_en 1 0
run 100ns 
force -freeze sim:/hash/hash_en 0 0
run 200ns 
