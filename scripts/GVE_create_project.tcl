


set plug_repo /home/fourniem/Playground/GVE/Hardware/plug-fpga

set open_type $::env(OPEN_TYPE)
set closed_type $::env(CLOSED_TYPE)
set project_name $::env(PROJ_NAME)
set project_directory $::env(PROJ_DIR)
set hwdef_directory $::env(HWDEF_DIR)

set hdf_name hdf_${open_type}_${closed_type}.hdf

# Create project 
create_project -force $project_name $project_directory/$project_name -part xc7z020clg484-1
# Set board 
set_property board_part em.avnet.com:zed:part0:1.4 [current_project]
# Set language : VHDL 
set_property target_language VHDL [current_project]
# Add constraint file 
import_files -fileset constrs_1 -force -norecurse /home/fourniem/Playground/utils/diligent_xdc/digilent-xdc-master/Zedboard-Master.xdc
# Osef 
# set_property compxlib.modelsim_compiled_library_dir /home/fourniem/Playground/Zynq/GVE_mb_v2/GVE_mb_v2.cache/compile_simlib [current_project]


# Import VHDL Files 

set ctrl 0

# Open 

#open entity definition 
read_vhdl $plug_repo/src/collections/open/open.vhd

# Open architectures : 

if { $open_type == "fifo" } then {
	read_vhdl  $plug_repo/src/collections/open/open_pkg.vhd
	read_vhdl  $plug_repo/src/collections/open/open_controler.vhd
	read_vhdl  $plug_repo/src/collections/utils/reg_file.vhd
	read_vhdl  $plug_repo/src/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_bram/pingpong_fifo_controler_b.vhd
	read_vhdl  $plug_repo/src/collections/open/fifo/ping_pong_fifo/ping_pong_fifo_bram/pingpong_fifo_e.vhd
} elseif { $open_type == "stack" } then { 
	puts "test";puts "test";puts "test";puts "test";puts "test";puts "test";puts "test";puts "test";puts "test";
	read_vhdl $plug_repo/src/collections/open/open_pkg.vhd
	read_vhdl $plug_repo/src/collections/open/open_controler.vhd
	read_vhdl $plug_repo/src/collections/utils/reg_file.vhd
	read_vhdl $plug_repo/src/collections/open/stack/stack_controler_a.vhd
	read_vhdl $plug_repo/src/collections/open/stack/stack_a.vhd
	incr ctrl 1 
}	



if { $closed_type == "bf" } then {
	read_vhdl $plug_repo/src/collections/closed/set.vhd
	read_vhdl $plug_repo/src/random/hash/hash.vhd
	read_vhdl $plug_repo/src/collections/closed/bloom_filter/bloom_filter_controler.vhd
	read_vhdl $plug_repo/src/collections/closed/bloom_filter/bloom_filter_pkg.vhd
	read_vhdl $plug_repo/src/random/hash/murmur3/murmur3.vhd
	read_vhdl $plug_repo/src/random/hash/murmur3/murmur3_wrapper.vhd
	read_vhdl $plug_repo/src/collections/closed/bloom_filter/bloom_filter_controler_a.vhd
	read_vhdl $plug_repo/src/collections/closed/bloom_filter/bloom_filter_b.vhd


} elseif { $closed_type == "hashtable" } then {
	read_vhdl $plug_repo/src/collections/closed/set.vhd
	read_vhdl $plug_repo/src/collections/closed/set/hash_table/hash_table_pkg.vhd
	read_vhdl $plug_repo/src/collections/closed/set/hash_table/hash_table.vhd

	read_vhdl $plug_repo/src/collections/closed/set/hash_table/hash_table_controler.vhd
	read_vhdl $plug_repo/src/collections/closed/set/hash_table/hash_table_controler_a.vhd
	
	read_vhdl $plug_repo/src/random/hash/hash.vhd
	read_vhdl $plug_repo/src/random/hash/murmur3/murmur3.vhd
	read_vhdl $plug_repo/src/random/hash/murmur3/murmur3_wrapper.vhd

	incr ctrl 2
}

puts $ctrl 
#pop controler used to mediate the connection between open and next_controler
read_vhdl $plug_repo/src/mc/controlers/pop_controler.vhd


#-- scheduler
read_vhdl $plug_repo/src/mc/controlers/scheduler.vhd
#-- scheduler

#-- semantics controler
read_vhdl $plug_repo/src/model/next_stream.vhd
read_vhdl $plug_repo/src/model/semantics_components_pkg.vhd
read_vhdl $plug_repo/src/model/semantics_controler.vhd
#--semantics controler

#-- terminaison checker
read_vhdl $plug_repo/src/mc/terminaison_checker/term_components_pkg.vhd
read_vhdl $plug_repo/src/mc/terminaison_checker/terminaison_checker.vhd
read_vhdl $plug_repo/src/mc/terminaison_checker/bound_checker.vhd
read_vhdl $plug_repo/src/mc/terminaison_checker/normal_terminaison_check.vhd
read_vhdl $plug_repo/src/mc/terminaison_checker/terminaison_fsm.vhd
read_vhdl $plug_repo/src/utils/cycle_counter.vhd

#-- terminaison checker

#-- top
read_vhdl $plug_repo/src/mc/mc_components_pkg.vhd
read_vhdl $plug_repo/src/mc/mc_top.vhd
read_vhdl $plug_repo/src/mc/mc_top_a.vhd
read_vhdl $plug_repo/src/mc/mc_top_wrapper.vhd
#-- top




switch $ctrl {
	0 { 			# Fifo and bloom filter 
		read_vhdl $plug_repo/src/mc/configs/Exhaustive/BFS/mc_top_bf_fifo_bram_config.vhd
		read_vhdl $plug_repo/src/mc/mc_top_wrapper_mc_top_bf_fifo_bram_config.vhd
		add_files -fileset sim_1 -norecurse $plug_repo/tests/mc/exhaustive/mc_top_wrapper_bf_fifo_bram_tb.vhd
	}
	1 {			# Stack and bloom_filter 
		read_vhdl $plug_repo/src/mc/configs/Exhaustive/DFS/mc_top_bf_stack_bram_config.vhd
		read_vhdl $plug_repo/src/mc/mc_top_wrapper_mc_top_bf_stack_bram_config.vhd
	}
	2 {			# Fifo and hashtable 
		read_vhdl $plug_repo/src/mc/configs/Exhaustive/BFS/mc_top_h_fifo_bram_config.vhd
		read_vhdl $plug_repo/src/mc/mc_top_wrapper_mc_top_h_fifo_bram_config.vhd
		add_files -fileset sim_1 -norecurse $plug_repo/tests/mc/exhaustive/mc_top_wrapper_h_fifo_bram_tb.vhd
	}
	3 {			# Stack and hashtable
		read_vhdl $plug_repo/src/mc/configs/Exhaustive/DFS/mc_top_h_stack_bram_config.vhd
		read_vhdl $plug_repo/src/mc/mc_top_wrapper_mc_top_h_stack_bram_config.vhd
		add_files -fileset sim_1 -norecurse $plug_repo/tests/mc/exhaustive/mc_top_wrapper_h_stack_bram_tb.vhd

	}
	default { puts "Error, shouldn't happen "; exit}
}

# VHDL explicit model sources for simulation 

add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/explicit_params.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/semantics.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/semantics_components_pkg.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/alice_bob/alice_bob_structure.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/explicit_structure.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/alice_bob/alice_bob_model.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/explicit_interpreter.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/explicit_interpreter_b.vhd
add_files -fileset sim_1 -norecurse $plug_repo/src/model/explicit/explicit_wrapper.vhd

update_compile_order -fileset sources_1



create_bd_design "design_1"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]


source /home/fourniem/Playground/Zynq/utils/load_ip_repos.tcl

# startgroup
# create_bd_cell -type ip -vlnv user.org:user:AXI4_testIP:1.0 AXI4_testIP_0
# create_bd_cell -type ip -vlnv user.org:user:AXI4_sem_in_frontend:1.1 AXI4_sem_in_frontend_0
# endgroup

# startgroup
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/AXI4_testIP_0/S00_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins AXI4_testIP_0/S00_AXI]
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/AXI4_sem_in_frontend_0/S00_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins AXI4_sem_in_frontend_0/S00_AXI]
# endgroup


# create_bd_cell -type module -reference mc_top_wrapper mc_top_wrapper_0

# group_bd_cells ps [get_bd_cells processing_system7_0] [get_bd_cells rst_ps7_0_100M] [get_bd_cells ps7_0_axi_periph]

# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/is_done] [get_bd_pins mc_top_wrapper_0/t_done_next]
# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/target_out] [get_bd_pins mc_top_wrapper_0/target_out_next]
# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/target_has_next] [get_bd_pins mc_top_wrapper_0/has_next_next]
# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/target_ready] [get_bd_pins mc_top_wrapper_0/t_ready_next]
# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/next_enable] [get_bd_pins mc_top_wrapper_0/n_en_next]
# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/source_in] [get_bd_pins mc_top_wrapper_0/source_next]
# connect_bd_net [get_bd_pins AXI4_sem_in_frontend_0/initial_enable] [get_bd_pins mc_top_wrapper_0/i_en_next]
# connect_bd_net [get_bd_pins mc_top_wrapper_0/clk] [get_bd_pins ps/FCLK_CLK0]
# connect_bd_net [get_bd_pins mc_top_wrapper_0/reset_n] [get_bd_pins ps/S00_ARESETN]

# connect_bd_net [get_bd_pins AXI4_testIP_0/o_sl_3] [get_bd_pins mc_top_wrapper_0/reset]

# connect_bd_intf_net [get_bd_intf_pins AXI4_testIP_0/gve_ctrl] [get_bd_intf_pins mc_top_wrapper_0/user_GVE_ctrl]

# group_bd_cells adapter_ps [get_bd_cells AXI4_sem_in_frontend_0] [get_bd_cells AXI4_testIP_0]
# save_bd_design
# startgroup
# set_property -dict [list CONFIG.OPEN_ADDRESS_WIDTH {16} CONFIG.CLOSED_ADDRESS_WIDTH {16}] [get_bd_cells mc_top_wrapper_0]
# endgroup


# save_bd_design


# generate_target all [get_files  ${project_directory}/${project_name}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd]

# catch { config_ip_cache -export [get_ips -all design_1_processing_system7_0_0] }
# catch { config_ip_cache -export [get_ips -all design_1_rst_ps7_0_100M_0] }
# catch { config_ip_cache -export [get_ips -all design_1_xbar_0] }
# catch { config_ip_cache -export [get_ips -all design_1_AXI4_sem_in_frontend_0_0] }
# catch { config_ip_cache -export [get_ips -all design_1_AXI4_testIP_0_0] }
# catch { config_ip_cache -export [get_ips -all design_1_auto_pc_0] }
# export_ip_user_files -of_objects [get_files ${project_directory}/${project_name}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
# create_ip_run [get_files -of_objects [get_fileset sources_1] ${project_directory}/${project_name}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd]
# launch_runs -jobs 8 {design_1_mc_top_wrapper_0_0_synth_1 design_1_processing_system7_0_0_synth_1 design_1_rst_ps7_0_100M_0_synth_1 design_1_xbar_0_synth_1 design_1_AXI4_sem_in_frontend_0_0_synth_1 design_1_AXI4_testIP_0_0_synth_1 design_1_auto_pc_0_synth_1}
# # export_simulation -of_objects [get_files ${project_directory}/${project_name}/project_1.srcs/sources_1/bd/design_1/design_1.bd] -directory ${project_directory}/${project_name}/project_1.ip_user_files/sim_scripts -ip_user_files_dir ${project_directory}/${project_name}/project_1.ip_user_files -ipstatic_source_dir ${project_directory}/${project_name}/project_1.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/fourniem/Playground/Zynq/GVE_mb_v2/GVE_mb_v2.cache/compile_simlib} {questa=/tmp/test/5/project_gve_dfs_bf/project_1.cache/compile_simlib/questa} {ies=/tmp/test/5/project_gve_dfs_bf/project_1.cache/compile_simlib/ies} {xcelium=/tmp/test/5/project_gve_dfs_bf/project_1.cache/compile_simlib/xcelium} {vcs=/tmp/test/5/project_gve_dfs_bf/project_1.cache/compile_simlib/vcs} {riviera=/tmp/test/5/project_gve_dfs_bf/project_1.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet

# make_wrapper -files [get_files ${project_directory}/${project_name}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd] -top
# add_files -norecurse ${project_directory}/${project_name}/${project_name}.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd
# set_property top design_1_wrapper [current_fileset]

# update_compile_order -fileset sources_1


# write_hwdef -force -file ${hwdef_directory}/${hdf_name}




# launch_runs -jobs 8 synth_1 
# wait_on_run synth_1

# launch_runs -jobs 8 impl_1 -to_step write_bitstream 
# wait_on_run impl_1


