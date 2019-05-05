use WORK.ALL;
configuration mc_top_v2_bounded of mc_top_v2 is
    for mc_top_v2_a
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_c);
        end for;

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(b)
            generic map(CONFIG_WIDTH => CONFIG_WIDTH);
            for b 
		for semantics_inst : work.semantics_components_v2.semantics
                    use entity work.explicit_interpreter(b)
			        generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for;
                for ctrl_inst : work.semantics_components_v2.semantics_controler
                    use entity work.semantics_controler_v2(b)
			        generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for; 
            end for; 
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a)
            generic map(CONFIG_WIDTH => CONFIG_WIDTH);
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.pingpong_fifo(d)
            generic map(ADDRESS_WIDTH => 5, DATA_WIDTH => CONFIG_WIDTH);
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

use work.model_structure.all; 

configuration mc_top_v2_exhaustive of mc_top_v2 is 
    for mc_top_v2_a
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_c);
        end for;

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(b)
			generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
            for b 
        for semantics_inst : work.semantics_components_v2.semantics
                use entity work.explicit_interpreter(b)
			        generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for;
                for ctrl_inst : work.semantics_components_v2.semantics_controler
                    use entity work.semantics_controler_v2(b)
			            generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for; 
            end for; 
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a)
			generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.fifo(d)
		generic map(ADDRESS_WIDTH => 5, DATA_WIDTH => CONFIG_WIDTH); 
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




use work.model_structure.all; 

configuration mc_top_v2_BF of mc_top_v2 is 
    for mc_top_v2_a
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(bloom_filter) 
            generic map(DATA_WIDTH => CONFIG_WIDTH); 
            for bloom_filter
                for hash_add : work.mc_components.hash
                    use entity work.simple_hash(a)
                    generic map(DATA_WIDTH => CONFIG_WIDTH); 
                end for; 
            end for; 
        end for;

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(b)
			generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
            for b 
        for semantics_inst : work.semantics_components_v2.semantics
                use entity work.explicit_interpreter(b)
			        generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for;
                for ctrl_inst : work.semantics_components_v2.semantics_controler
                    use entity work.semantics_controler_v2(b)
			            generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for; 
            end for; 
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a)
			generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.pingpong_fifo(d)
		generic map(ADDRESS_WIDTH => 5, DATA_WIDTH => CONFIG_WIDTH); 
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




use work.model_structure.all; 

configuration mc_top_v2_exhaustive_hashmap of mc_top_v2 is 
    for mc_top_v2_a
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(hash_table_a); 
		for hash_table_a 
            for hash_funct : work.hash_table_components.hash_block_cmp
                use entity work.simple_hash(a); 
            end for; 
            for controler : work.hash_table_components.controler_cmp
                use entity work.hash_table_controler(a); 
            end for; 
            for reg_file_configs : work.hash_table_components.reg_file_ssdpRAM_cmp
                use entity work.reg_file_ssdpRAM(rtl); 
            end for; 
            for reg_file_isFilled : work.hash_table_components.reg_file_ssdpRAM_cmp
                use entity work.reg_file_ssdpRAM(rtl); 
            end for; 
		end for; 
        end for;

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(b)
			generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
            for b 
        for semantics_inst : work.semantics_components_v2.semantics
                use entity work.explicit_interpreter(b)
			        generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for;
                for ctrl_inst : work.semantics_components_v2.semantics_controler
                    use entity work.semantics_controler_v2(b)
			            generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
                end for; 
            end for; 
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a)
			generic map(CONFIG_WIDTH => CONFIG_WIDTH); 
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.pingpong_fifo(d)
        generic map(ADDRESS_WIDTH => 5, DATA_WIDTH => CONFIG_WIDTH); 
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
