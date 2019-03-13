use work.all;

configuration exhaustive_linear_set of mc_generic is
    for arch_v0
        for open_inst : work.mc_components.open_stream
            use entity work.fifo(c)
                port map (
                    clk 			=> clk,
                    reset 			=> reset,
                    reset_n			=> reset_n,
                    pop_enable 	    => pop_enable,
                    push_enable	    => push_enable,
                    data_in 		=> data_in,
                    data_out		=> data_out,
                    data_ready		=> data_ready,
                    is_empty 		=> is_empty,
                    is_full			=> is_full
                );
        end for;

        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_b);
        end for;

        for semantics_inst : work.mc_components.semantics
            use entity work.explicit_interpreter(a);
        end for;

        for checher_inst : work.mc_components.checker
            use entity work.checker(a);
        end for;

        for controler_inst : work.mc_components.controler
            use entity work.controler(a);
        end for;
    end for;
end configuration;