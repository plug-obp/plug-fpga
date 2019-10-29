options= -g 

SRC_FILES=../../../../src/random/hash/fasthash/


all : fast_hash_tb 
	ghdl -e tb
	ghdl -r tb --wave=out.ghw --stop-time=1000ns 
	gtkwave out.ghw out.sav

fast_hash_tb: fasthash64_mul_63ns_56ns_64_5_1 fasthash64_mul_63ns_64s_64_5_1 fasthash64_mul_64s_64s_64_5_1 fasthash64
	ghdl -a ${options} fast_hash_tb.vhd

fasthash64 : fasthash64_mul_63ns_56ns_64_5_1 fasthash64_mul_63ns_64s_64_5_1 fasthash64_mul_64s_64s_64_5_1
	ghdl -a $(options) $(SRC_FILES)/fasthash64.vhd

fasthash64_mul_63ns_56ns_64_5_1 : 
	ghdl -a $(options)  $(SRC_FILES)/fasthash64_mul_63ns_56ns_64_5_1.vhd

fasthash64_mul_63ns_64s_64_5_1 : 
	ghdl -a $(options)  $(SRC_FILES)/fasthash64_mul_63ns_64s_64_5_1.vhd

fasthash64_mul_64s_64s_64_5_1 : 
	ghdl -a $(options)  $(SRC_FILES)/fasthash64_mul_64s_64s_64_5_1.vhd




