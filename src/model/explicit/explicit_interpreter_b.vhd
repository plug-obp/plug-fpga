use work.model_structure.all; 
use work.explicit_params.all; 
use work.explicit_structure.all; 
use work.model.all; 



architecture b of explicit_interpreter is
  type T_CONTROL is (
    S0, WAIT_INIT, SEARCH_SOURCE, WAIT_NEXT
    );
  type T_STATE is record
    ctrl_state    : T_CONTROL;
    source        : std_logic_vector(p.configuration_width-1 downto 0);
    source_index  : integer;
    fanout_size   : integer;
    target_base   : integer;
    target_offset : integer;
  end record;
  constant DEFAULT_STATE : T_STATE := (S0, (others => '0'), 0, 0, 0, 0);

  type T_OUTPUT is record
    target       : std_logic_vector(p.configuration_width-1 downto 0);
    target_ready : boolean;
    has_next     : boolean;
    is_done      : boolean;
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := ((others => '0'), false, false, false);

  --next state
  signal state_c  : T_STATE  := DEFAULT_STATE;
  signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

  --registers
  signal state_r : T_STATE := DEFAULT_STATE;
begin

  state_update : process (clk, reset_n) is
  begin
    if reset_n = '0' then
      state_r <= DEFAULT_STATE;
    elsif rising_edge(clk) then
      if reset = '1' then
        state_r <= DEFAULT_STATE;
      else
        state_r <= state_c;
      end if;
    end if;
  end process;

  next_update : process (initial_enable, next_enable, source_in, state_r) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current    : T_STATE  := DEFAULT_STATE;
  begin
    current    := state_r;
    the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
      when S0 =>
        -- initial request
        if initial_enable = '1' and next_enable = '0' then
          current.target_offset := 0;
          if p.nb_initial = 0 then
            current.ctrl_state      := S0;
            the_output.target_ready := false;
            the_output.has_next     := false;
            the_output.is_done      := true;
          else
            the_output.target       := initial_at(model, current.target_offset);
            the_output.target_ready := true;
            the_output.is_done      := true;
            if p.nb_initial = 1 then
              the_output.has_next := false;
              current.ctrl_state  := S0;
            else
              the_output.has_next   := true;
              current.ctrl_state    := WAIT_INIT;
              current.target_offset := 1;
            end if;
          end if;
        end if;
        --next request
        if initial_enable = '0' and next_enable = '1' then
          current.source       := source_in;
          current.source_index := 0;
          if current.source = state_at(model, current.source_index) then
            current.target_base   := model.fanout_base(current.source_index);
            current.target_offset := 0;
            current.fanout_size   := fanout_size(model, current.source_index);
            if current.fanout_size = 0 then  --deadlock
              the_output.target_ready := false;
              the_output.has_next     := false;
              the_output.is_done      := true;
              current.ctrl_state      := S0;
            else
              the_output.target       := target_at(model, current.target_base + current.target_offset);
              the_output.target_ready := true;
              the_output.is_done      := true;
              if current.fanout_size > 1 then
                the_output.has_next   := true;
                current.ctrl_state    := WAIT_NEXT;
                current.target_offset := 1;
              else
                the_output.has_next := false;
                current.ctrl_state  := S0;
              end if;
            end if;
          else                               -- find source
            the_output.target_ready := false;
            the_output.is_done      := false;
            current.source_index    := 1;
            current.ctrl_state      := SEARCH_SOURCE;
          end if;
        end if;
      when WAIT_INIT =>
        if initial_enable = '1' then
          the_output.target       := initial_at(model, current.target_offset);
          the_output.target_ready := true;
          the_output.is_done      := true;

          if current.target_offset + 1 < p.nb_initial then
            the_output.has_next   := true;
            current.target_offset := current.target_offset + 1;
            current.ctrl_state    := WAIT_INIT;
          else
            the_output.has_next   := false;
            current.target_offset := 0;
            current.ctrl_state    := S0;
          end if;
        end if;
      when SEARCH_SOURCE =>
        if current.source_index >= p.nb_states then  --source not found, produce deadlock
          the_output.target_ready := false;
          the_output.has_next     := false;
          the_output.is_done      := true;
          current.ctrl_state      := S0;
        elsif current.source = state_at(model, current.source_index) then  --source found
          current.target_base   := model.fanout_base(current.source_index);
          current.target_offset := 0;
          current.fanout_size   := fanout_size(model, current.source_index);
          if current.fanout_size = 0 then            --deadlock
            the_output.target_ready := false;
            the_output.has_next     := false;
            the_output.is_done      := true;
            current.ctrl_state      := S0;
          else
            the_output.target       := target_at(model, current.target_base + current.target_offset);
            the_output.target_ready := true;
            the_output.is_done      := true;
            if current.fanout_size > 1 then
              the_output.has_next   := true;
              current.ctrl_state    := WAIT_NEXT;
              current.target_offset := 1;
            else
              the_output.has_next := false;
              current.ctrl_state  := S0;
            end if;
          end if;
        else                            -- continue looking up the source
          the_output.target_ready := false;
          the_output.is_done      := false;
          current.source_index    := current.source_index + 1;
          current.ctrl_state      := SEARCH_SOURCE;
        end if;
      when WAIT_NEXT =>
        if next_enable = '1' then
          the_output.target       := target_at(model, current.target_base + current.target_offset);
          the_output.target_ready := true;
          the_output.is_done      := true;
          if current.target_offset + 1 < current.fanout_size then
            the_output.has_next   := true;
            current.ctrl_state    := WAIT_NEXT;
            current.target_offset := current.target_offset + 1;
          else
            the_output.has_next := false;
            current.ctrl_state  := S0;
          end if;
        end if;
    end case;

    --set the state_c
    state_c  <= current;
    --set the outputs
    output_c <= the_output;
  end process;

  out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
      procedure reset_output is
      begin
        target_out   <= (others => '0');
        target_ready <= '0';
        has_next     <= '0';
        is_done      <= '0';
      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          target_out <= output_c.target;

          if output_c.target_ready then
            target_ready <= '1';
          else
            target_ready <= '0';
          end if;

          if output_c.has_next then
            has_next <= '1';
          else
            has_next <= '0';
          end if;

          if output_c.is_done then
            is_done <= '1';
          else
            is_done <= '0';
          end if;



--          target_ready <= '1' when output_c.target_ready else '0';
--          has_next     <= '1' when output_c.has_next     else '0';
--          is_done <= '1' when output_c.is_done else '0';
        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
    target_out   <= output_c.target;
    target_ready <= '1' when output_c.target_ready else '0';
    has_next     <= '1' when output_c.has_next     else '0';
    is_done      <= '1' when output_c.is_done      else '0';
  end generate;

end architecture;
