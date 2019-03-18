architecture a of explicit_interpreter is
    signal started_init : boolean := false;
    signal source : std_logic_vector(p.configuration_width-1 downto 0) := (others => '0');
    signal source_index : integer := 0;
    signal source_found : boolean := false;
    signal target_base : integer := 0;
    signal target_offset : integer := 0;
    signal has_nxt : boolean := false;
begin

update : process (clk, reset_n) is
        type T_STATE is (START_INIT, PRODUCE_INIT, END_INIT, 
                START_NEXT, LOAD_SOURCE, NO_SOURCE, PRODUCE_NEXT, END_NEXT,
                DO_NOTHING);
        variable state : T_STATE;
        variable fanout_size : integer := 0;
        procedure reset_state is 
        begin
            started_init <= false;
            source <= (others => '0');
            source_index <= 0;
            source_found <= false;
            target_base <= 0;
            target_offset <= 0;
            has_nxt <= false;
	    target_out <= (others => '0');
	    target_ready <= '0';
        end;
    begin
        if reset_n = '0' then
            reset_state;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_state;
            else
                if initial_enable = '1' and next_enable = '1' then
                    state := DO_NOTHING;
                elsif initial_enable = '1' then
                    if not started_init then
                        state := START_INIT;
                    elsif has_nxt then
                        state := PRODUCE_INIT;
                    else
                        state := END_INIT;
                    end if;
                elsif next_enable = '1' then
                    if source /= source_in then
                        if p.nb_states > 0 then
                            state := START_NEXT;
                        else
                            state := NO_SOURCE;
                        end if;
                    elsif not source_found then
                        if p.nb_states > 0 and source_index < p.nb_states then
                            state := LOAD_SOURCE;
                        else 
                            state := NO_SOURCE;
                        end if;
                    elsif has_nxt then
                        state := PRODUCE_NEXT;
                    else
                        state := END_NEXT;
                    end if;
                else
                    state := DO_NOTHING;
                end if;

                case state is
                when START_INIT =>
                    started_init <= true;
                    if p.nb_initial = 0 then
                        has_nxt <= false;
                    else
                        target_out <= config2lv(model.states(model.initial(0)));
                        target_ready <= '1';
                        target_offset <= 1;
                        if p.nb_initial > 1 then
                            has_nxt <= true;
                        else
                            has_nxt <= false;
                        end if;
                    end if;
                when PRODUCE_INIT => 
                    target_out <= config2lv(model.states(model.initial(target_offset)));
                    target_ready <= '1';
                    target_offset <= target_offset + 1;
                    if target_offset + 1 < p.nb_initial then
                        has_nxt <= true;
                    else
                        has_nxt <= false;
                    end if;
                when END_INIT =>
                    started_init <= false;
                when START_NEXT =>
                    source <= source_in;
                    source_found <= false;
                    if source_in = config2lv(model.states(0)) then
                        source_found <= true;
                        source_index <= 0;
                        target_base <= model.fanout_base(0);
                        fanout_size := model.fanout(1) - model.fanout_base(0);
                        if fanout_size > 0 then
                            target_out <= config2lv(model.states(model.fanout(model.fanout_base(0) + 0)));
                            target_ready <= '1';
                            target_offset <= 1;
                            if fanout_size > 1 then
                                has_nxt <= true;
                            else
                                has_nxt <= false;
                            end if;
                        else -- no fanout / deadlock
                            has_nxt <= false;
                        end if;
                    else 
                        source_found <= false;
                        source_index <= 1;
                    end if;
                when LOAD_SOURCE =>
                    if source_in = config2lv(model.states(source_index)) then
                        source_found <= true;
                        target_base <= model.fanout_base(source_index);
                        fanout_size := model.fanout_base(source_index + 1) - model.fanout_base(source_index);
                        if fanout_size > 0 then
                            target_out <= config2lv(model.states(model.fanout(model.fanout_base(source_index) + 0)));
                            target_ready <= '1';
                            target_offset <= 1;
                            if fanout_size > 1 then
                                has_nxt <= true;
                            else
                                has_nxt <= false;
                            end if;
                        else
                            has_nxt <= false;
                        end if;
                    else
                        source_found <= false;
                        source_index <= source_index + 1;
                    end if;
                when PRODUCE_NEXT =>
                    target_out <= config2lv(model.states(model.fanout(target_base + target_offset)));
                    target_ready <= '1';
                    target_offset <= target_offset + 1;
                    fanout_size := model.fanout_base(source_index + 1) - model.fanout_base(source_index);
                    if target_offset + 1 < fanout_size then
                        has_nxt <= true;
                    else
                        has_nxt <= false;
                    end if;
                when NO_SOURCE | END_NEXT | DO_NOTHING => null;
                end case;

            end if;
        end if;
    end process;

has_next <= '1' when has_nxt else '0';
end;