
synth_dir=murmur3.prj/solution1/impl/ip/hdl/vhdl

all: ../murmur3.vhd


../murmur3.vhd : $(synth_dir)/murmur3.vhd 
	$(shell mv $(synth_dir)/murmur3.vhd .. ) 



$(synth_dir)/murmur3.vhd : 
	$(SHELL vivado_hls -f make.tcl)
