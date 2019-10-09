# STEP#1: define the output directory area.
#
set outputDir ~/vv_output
file mkdir $outputDir

set codeDir ~/repositories/plug-fpga/src

# STEP#2: setup design sources and constraints
#
read_vhdl -vhdl2008 $codeDir/collections/open/open.vhd

#-- for open DRAM
#read_vhdl -vhdl2008 $codeDir/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_dram/ping_pong_fifo_d.vhd
#read_vhdl -vhdl2008 $codeDir/mc/controlers/pop_controler.vhd
#-- end open DRAM

#-- for open BRAM
read_vhdl -vhdl2008 $codeDir/collections/open/open_pkg.vhd
read_vhdl -vhdl2008 $codeDir/collections/open/open_controler.vhd
read_vhdl -vhdl2008 $codeDir/collections/utils/reg_file.vhd
read_vhdl -vhdl2008 $codeDir/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_bram/pingpong_fifo_controler_b.vhd
read_vhdl -vhdl2008 $codeDir/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_bram/pingpong_fifo_e.vhd
#pop controler used to mediate the connection between open and next_controler
read_vhdl -vhdl2008 $codeDir/mc/controlers/pop_controler.vhd
#-- end open BRAM

read_vhdl -vhdl2008 $codeDir/collections/closed/set.vhd 
#--for closed DRAM
#--linear set : an array with linear time lookup
#read_vhdl -vhdl2008 $codeDir/collections/closed/set/linear_set/linear_set_c.vhd
#--for closed DRAM

#--for closed BRAM
#-- linear probe set : amortized constant lookup in BRAM
#need reg file but it was already read for open
#read_vhdl -vhdl2008 $codeDir/collections/utils/reg_file.vhd
read_vhdl -vhdl2008 $codeDir/random/hash/hash.vhd
read_vhdl -vhdl2008 $codeDir/random/rng/xorshift.vhd
read_vhdl -vhdl2008 $codeDir/collections/closed/set/hash_table/hash_table_pkg.vhd
read_vhdl -vhdl2008 $codeDir/collections/closed/set/hash_table/hash_table.vhd
read_vhdl -vhdl2008 $codeDir/collections/closed/set/hash_table/hash_table_controler.vhd
read_vhdl -vhdl2008 $codeDir/collections/closed/set/hash_table/hash_table_controler_a.vhd
#--for closed BRAM

#-- scheduler
read_vhdl -vhdl2008 $codeDir/mc/controlers/scheduler.vhd
#-- scheduler

#-- semantics controler
read_vhdl -vhdl2008 $codeDir/model/next_stream.vhd
read_vhdl -vhdl2008 $codeDir/model/semantics_components_pkg.vhd
read_vhdl -vhdl2008 $codeDir/model/semantics_controler.vhd
#--semantics controler

#-- terminaison checker
read_vhdl -vhdl2008 $codeDir/mc/terminaison_checker/term_components_pkg.vhd
read_vhdl -vhdl2008 $codeDir/mc/terminaison_checker/terminaison_checker.vhd
read_vhdl -vhdl2008 $codeDir/mc/terminaison_checker/bound_checker.vhd
read_vhdl -vhdl2008 $codeDir/mc/terminaison_checker/normal_terminaison_check.vhd
read_vhdl -vhdl2008 $codeDir/mc/terminaison_checker/terminaison_fsm.vhd
#-- terminaison checker

#-- top
read_vhdl -vhdl2008 $codeDir/mc/mc_components_pkg.vhd
read_vhdl -vhdl2008 $codeDir/mc/mc_top.vhd
read_vhdl -vhdl2008 $codeDir/mc/mc_top_a.vhd
#-- top

read_vhdl -vhdl2008 $codeDir/mc/configs/Exhaustive/BFS/mc_top_exh_h_fifo_bram_config.vhd

#-- for Vivado IP creation
read_vhdl -vhdl2008 $codeDir/mc/mc_top_wrapper_mc_top_exh_h_fifo_bram_config.vhd

synth_design -top mc_top_wrapper -part xc7k70tfbg676-2