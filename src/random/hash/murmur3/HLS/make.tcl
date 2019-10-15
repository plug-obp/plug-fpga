open_project murmur3.prj
set_top murmur3
add_files src/murmur3.h
add_files src/murmur3.c
add_files -tb src/murmur3_tb.c -cflags "-Wno-unknown-pragmas"
open_solution "solution1"
set_part {xc7z020clg484-1}
create_clock -period 10 -name default
config_compile -no_signed_zeros=0 -unsafe_math_optimizations=0
config_export -format ip_catalog -rtl vhdl -vivado_phys_opt place -vivado_report_level 0
config_rtl -auto_prefix=0 -encoding onehot -mult_keep_attribute=0 -reset control -reset_async -reset_level low -verbose=0
config_sdx -optimization_level none -target none
config_schedule -effort medium -relax_ii_for_timing=0
config_bind -effort medium

set_directive_interface -mode ap_vld "murmur3" key
set_directive_interface -mode ap_vld "murmur3" seed
set_directive_pipeline "murmur3"

csim_design
csynth_design
cosim_design -rtl vhdl
export_design -rtl vhdl -format ip_catalog



exit
