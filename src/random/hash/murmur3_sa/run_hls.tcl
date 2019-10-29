open_project -reset build
set_top murmur3_32
add_files src/murmur3.c
add_files src/murmur3.h
add_files -tb src/murmur3_tb.c
open_solution -reset "solution1"
set_part {xc7z020clg484-1}
create_clock -period 10 -name default
config_compile -no_signed_zeros=0 -unsafe_math_optimizations=0
config_sdx -optimization_level none -target none
config_bind -effort medium
config_schedule -effort medium -relax_ii_for_timing=0
set_clock_uncertainty 12.5%

#csim_design
csynth_design
# cosim_design
# export_design -format ip_catalog


exit