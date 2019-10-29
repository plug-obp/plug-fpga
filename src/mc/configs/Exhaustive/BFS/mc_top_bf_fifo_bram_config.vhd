use work.mc_components.all;
use work.open_components.all; 

use work.semantics_components_v2.all;

configuration mc_top_bf_fifo_bram_config of mc_top is

	for mc_top_a

		for closed_inst : work.mc_components.closed_stream
			use entity work.set(bloom_filter_b)
				generic map(DATA_WIDTH => DATA_WIDTH);
			for bloom_filter_b
				for hash_funct : work.bloom_filter_components.hash_block_cmp
					use entity work.hash(murmur3_wrapper)
						generic map(DATA_WIDTH => 32, HASH_WIDTH => 32, WORD_WIDTH => 32);
				end for;
				for controler : work.bloom_filter_components.controler_cmp
					use entity work.bloom_filter_controler(a);
				end for;
				for reg_file_isFilled : work.bloom_filter_components.reg_file_ssdpRAM_cmp
					use entity work.reg_file_ssdpRAM(syn);
				end for;
			end for;
		end for;

		for next_inst : work.mc_components.next_stream
			use entity work.next_stream(c)
				generic map(CONFIG_WIDTH => DATA_WIDTH);
			for c
				for ctrl_inst : work.semantics_components_v2.semantics_controler
					use entity work.semantics_controler_v2(b)
						generic map(CONFIG_WIDTH => 32);
				end for;
			end for;
		end for;

		for sched_inst : work.mc_components.scheduler
			use entity work.scheduler(a)
				generic map(CONFIG_WIDTH => 32);
		end for;

		for open_inst : work.mc_components.open_stream
			use entity work.pingpong_fifo(e)
				generic map(ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, DATA_WIDTH => 32);
			for e
				for controler : work.open_components.controler_cmp
					use entity work.open_controler(pingpong_fifo_controler_b);
				end for;
				for reg_file_configs : work.open_components.reg_file_ssdpRAM_cmp
					use entity work.reg_file_ssdpRAM(syn);
				end for;
			end for;
		end for;

		for pop_ctrl_inst : work.mc_components.pop_controler
			use entity work.pop_controler(a);
		end for;

		for term_chker_inst : work.mc_components.terminaison_checker
			use entity work.terminaison_checker(a);
			for a
				for bound_chker_inst : work.term_components_pkg.bound_check
					use entity work.bound_checker(a);
				end for;
				for term_inst : work.term_components_pkg.terminaison_fsm_comp
					use entity work.terminaison_fsm(a);
				end for;
				for normal_term_chker_inst : work.term_components_pkg.normal_term_comp
					use entity work.normal_terminaison_check(a);
				end for;
			end for;
		end for;
		for cycle_counter_inst : work.mc_components.cycle_counter
			use entity work.cycle_counter(a);
		end for;

	end for;
end configuration;
