


SHELL=/bin/bash

set options = -g 
ghdl -a src/mc/mc_components_pkg.vhd

while IFS=, read -r col1 col2
do
    printf 'Building file : %s\n' "$col2"

    ghdl -a  $col2

done < compilation_order.csv
	ghdl -e tb_stack_a
	ghdl -r tb_stack_a --wave=out.ghw --stop-time=1000ns 
	gtkwave out.ghw out.sav
