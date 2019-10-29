

all : clean 
	vivado_hls -f ./run_hls.tcl 
	cp build/solution1/impl/vhdl/*.vhd .
clean : 
	rm -rf build
	rm -f vivado*.log
	rm -f ./fasthash64*.vhd