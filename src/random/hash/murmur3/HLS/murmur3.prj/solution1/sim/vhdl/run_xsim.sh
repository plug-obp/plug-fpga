
/tools/Xilinx/Vivado/2018.3/bin/xelab xil_defaultlib.apatb_murmur3_top glbl -prj murmur3.prj -L smartconnect_v1_0 -L axi_protocol_checker_v1_1_12 -L axi_protocol_checker_v1_1_13 -L axis_protocol_checker_v1_1_11 -L axis_protocol_checker_v1_1_12 -L xil_defaultlib -L unisims -L xpm --initfile "/tools/Xilinx/Vivado/2018.3/data/xsim/ip/xsim_ip.ini" --lib "ieee_proposed=./ieee_proposed" -s murmur3 
/tools/Xilinx/Vivado/2018.3/bin/xsim --noieeewarnings murmur3 -tclbatch murmur3.tcl
