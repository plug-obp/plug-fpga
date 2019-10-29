open_project -reset hls_output
set_top murmur3_32
add_files src/murmur3.c
add_files src/murmur3.h
open_solution -reset 'hlsSolution'
create_clock -period 10 -name default 
set_part {xc7z020clg484-1} -tool vivado

csynth_design 

exit 
