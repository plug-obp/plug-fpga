set outputDir ~/vv_output
file mkdir $outputDir

read_vhdl ../src/mc/mc_top_wrapper.vhd
read_vhdl ../src/model/semantics_components_pkg.vhd
read_vhdl ../src/utils/cycle_counter.vhd
read_vhdl ../src/collections/open/open_pkg.vhd
read_vhdl ../src/model/semantics_controler.vhd
read_vhdl ../src/random/hash/hash.vhd
read_vhdl ../src/collections/utils/reg_file.vhd
read_vhdl ../src/mc/terminaison_checker/normal_terminaison_check.vhd
read_vhdl ../src/mc/terminaison_checker/term_components_pkg.vhd
read_vhdl ../src/collections/open/open.vhd
read_vhdl ../src/collections/closed/bloom_filter/bloom_filter_controler.vhd
read_vhdl ../src/mc/controlers/scheduler.vhd
read_vhdl ../src/collections/open/open_controler.vhd
read_vhdl ../src/collections/closed/set.vhd
read_vhdl ../src/mc/mc_top.vhd
read_vhdl ../src/collections/closed/bloom_filter/bloom_filter_pkg.vhd
read_vhdl ../src/mc/controlers/pop_controler.vhd
read_vhdl ../src/mc/mc_components_pkg.vhd
read_vhdl ../src/random/hash/murmur3/murmur3.vhd
read_vhdl ../src/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_bram/pingpong_fifo_e.vhd
read_vhdl ../src/mc/terminaison_checker/terminaison_checker.vhd
read_vhdl ../src/random/hash/murmur3/murmur3_wrapper.vhd
read_vhdl ../src/mc/terminaison_checker/terminaison_fsm.vhd
read_vhdl ../src/model/next_stream.vhd
read_vhdl ../src/collections/closed/bloom_filter/bloom_filter_controler_a.vhd
read_vhdl ../src/collections/closed/bloom_filter/bloom_filter_b.vhd
read_vhdl ../src/mc/terminaison_checker/bound_checker.vhd
read_vhdl ../src/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_bram/pingpong_fifo_controler_b.vhd
read_vhdl ../src/mc/mc_top_a.vhd
read_vhdl ../src/mc/configs/Exhaustive/BFS/mc_top_exh_bf_fifo_bram_config.vhd
read_vhdl ../src/mc/mc_top_wrapper_mc_top_exh_bf_fifo_bram_config.vhd




# synth_design -top mc_top_wrapper -part xc7z020clg484-1