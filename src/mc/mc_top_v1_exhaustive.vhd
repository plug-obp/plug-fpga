use WORK.ALL;
configuration mc_top_v1_exhaustive of mc_top_v1 is
    for mc_top_v1_a
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_c);
        end for;

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(a);
            for a
                for semantics_inst : work.semantics_components.semantics
                    use entity work.explicit_interpreter(b);
                end for;
            end for;
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a);
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.fifo(c);
        end for;
    end for;
end configuration;