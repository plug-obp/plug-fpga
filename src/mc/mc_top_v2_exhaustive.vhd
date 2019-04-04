use WORK.ALL;
configuration mc_top_v2_exhaustive of mc_top_v1 is
    for mc_top_v1_a
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_c);
        end for;

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(b);
            for b 
		for semantics_inst : work.semantics_components_v2.semantics
                    use entity work.explicit_interpreter(b);
                end for;
                for ctrl_inst : work.semantics_components_v2.semantics_controler
                    use entity work.semantics_controler_v2(b); 
                end for; 
            end for; 
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a);
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.pingpong_fifo_b(b);
        end for;

        for pop_ctrl_inst : work.mc_components.pop_controler
            use entity work.pop_controler(a); 
        end for; 
    end for;
end configuration;