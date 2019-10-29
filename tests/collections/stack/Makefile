



options= -g 

SRC_FILES=/home/fourniem/Playground/GVE/Hardware/plug-fpga/src/collections/open/stack



all : tb_stack_a 
	ghdl -e tb_stack_a
	ghdl -r tb_stack_a --wave=out.ghw --stop-time=1000ns 
	gtkwave out.ghw out.sav

tb_stack_a:
	ghdl -a ${options} tb_stack_a.vhd


fasthash64_mul_64s_64s_64_5_1 : 
	ghdl -a $(options)  $(SRC_FILES)/fasthash64_mul_64s_64s_64_5_1.vhd




