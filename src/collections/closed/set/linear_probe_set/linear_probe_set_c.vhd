library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library set_lib;
use set_lib.pkg.all;

architecture linear_probe_set_c of set is

  signal memory_c, memory_r : T_MEMORY  := (others => (data => (others => '0'), is_set => false));
  signal full_ff            : std_logic := '0';
  signal already_in_ff      : std_logic := '0';

  pure function hash_con(
    object : std_logic_vector(DATA_WIDTH-1 downto 0))
    return integer is
  begin
    if (DATA_WIDTH <= ADDRESS_WIDTH) then
      return to_integer(unsigned(object));
    else
      return to_integer(unsigned(object)) mod CAPACITY;
    end if;
  end function;

  type t_state is (IDLE, S0, WAIT_FUNC);
  signal state_c, state_r : t_state;

  signal start_func, done_func : std_logic;
  signal index_of_result       : T_INDEX;
  signal index_r, index_c      : T_INDEX;
begin

  FUNC : entity set_lib.function_set_index_of(automaton)
    generic map (CAPACITY => 2**ADDRESS_WIDTH)
    port map(
      reset_n  => reset_n,
      clk      => clk,
      go       => start_func,
      done     => done_func,
      memory   => memory_r,
      object   => data_in,
      hash     => hash_con(data_in),
      index_of => index_of_result
      );

  --------------------------------------------------------------------------------
  tick : process(reset_n, clk)
  begin
    if reset_n = '0' then
      state_r <= IDLE;
      for idx in 0 to CAPACITY-1 loop
        memory_r(idx).is_set <= false;
      end loop;
      index_r <= (0,false,false);
    elsif rising_edge(clk) then
      if reset = '1' then
        state_r <= IDLE;
        for idx in 0 to CAPACITY-1 loop
          memory_r(idx).is_set <= false;
        end loop;
        index_r <= (0,false,false);
      else
        state_r  <= state_c;
        memory_r <= memory_c;
        index_r  <= index_c;
      end if;
    end if;
  end process;

  next_state : process(add_enable, data_in, full_ff, reset, state_r)
  begin
    start_func <= '0';
    full_ff    <= '0';                  --Cip?
    memory_c   <= memory_r;
    index_c    <= index_r;
    case state_r is
      when IDLE =>
        if add_enable = '1' and full_ff = '0' then
          state_c    <= WAIT_FUNC;
          start_func <= '1';
        end if;
      when WAIT_FUNC =>
        if done_func = '1' then
          index_c <= index_of_result;
          if index_c.is_valid then
            if index_c.is_found then
              already_in_ff <= '1';
            else
              memory_c(index_c.ptr) <= (data => data_in, is_set => true);
              already_in_ff       <= '0';
            end if;
          else
            full_ff <= '1';
          end if;
        end if;
        state_c <= S0;

      when others =>
        null;
    end case;

  end process;

  -- add_handler : process (clk) is
  --       variable index : T_INDEX;
  --   begin
  --       if rising_edge(clk) then
  --           if reset = '1' then
  --               for idx in 0 to CAPACITY-1 loop
  --                           memory(idx).is_set <= false;
  --               end loop;
  --           else
  --               if add_enable = '1' and full_ff = '0' then
  --                   index := index_of(memory, data_in, hash_con(data_in));
  --                   if index.is_valid then
  --                       if index.is_found then
  --                           already_in_ff <= '1';
  --                       else
  --                           memory(index.ptr) <= (data => data_in, is_set => true);
  --                           already_in_ff <= '0';
  --                       end if;
  --                   else
  --                       full_ff <= '1';
  --                   end if;
  --               end if;
  --           end if;
  --       end if;
  --   end process;

  add_error <= '1' when add_enable = '1' and full_ff = '1' else '0';

  is_in <= already_in_ff;

  -- connect full
  is_full <= full_ff;

end architecture;
