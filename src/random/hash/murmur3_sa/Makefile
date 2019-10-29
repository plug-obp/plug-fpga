options = -g 

all : clean 
	vivado_hls -f ./run_hls.tcl 
	cp build/solution1/impl/vhdl/*.vhd .

run : murmur3_tb murmur3_32
	ghdl -e tb 
	ghdl -r tb --wave=out.ghw --stop-time=1000ns 
	gtkwave out.ghw out.sav 

murmur3_tb : murmur3_32
	ghdl -a ${options} murmur3_tb.vhd

murmur3_32 : 
	ghdl -a ${options} murmur3_32.vhd


clean : 
	rm -rf build
	rm -f vivado*.log
	rm -f ./fasthash64*.vhd