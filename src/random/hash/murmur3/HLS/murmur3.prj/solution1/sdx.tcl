# ==============================================================
# File generated on Thu Oct 10 14:59:24 CEST 2019
# Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# ==============================================================
add_files -tb ../../src/murmur3_tb.c -cflags { -Wno-unknown-pragmas}
add_files src/murmur3.c
add_files src/murmur3.h
set_part xc7z020clg484-1
create_clock -name default -period 10
set_clock_uncertainty 12.5% default
config_compile -no_signed_zeros=0
config_compile -unsafe_math_optimizations=0
config_export -format=ip_catalog
config_export -rtl=vhdl
config_export -vivado_phys_opt=place
config_export -vivado_report_level=0
config_rtl -auto_prefix=0
config_rtl -encoding=onehot
config_rtl -mult_keep_attribute=0
config_rtl -reset=control
config_rtl -reset_async=1
config_rtl -reset_level=low
config_rtl -verbose=0
config_sdx -optimization_level=none
config_sdx -target=none
config_bind -effort=medium
config_schedule -effort=medium
config_schedule -relax_ii_for_timing=0
set_directive_interface murmur3 
set_directive_interface murmur3 
set_directive_pipeline murmur3 
