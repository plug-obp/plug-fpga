library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture linear_probe_set_c of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_SET_ELEMENT is record
        data : std_logic_vector(DATA_WIDTH-1 downto 0);
        is_set : boolean;
    end record;
    type T_MEMORY is array (0 to CAPACITY - 1) of T_SET_ELEMENT;
    signal memory : T_MEMORY := (others => (data => (others => '0'), is_set => FALSE));

    signal base : unsigned(CAPACITY-1 downto 0) := (others => '0');
    type T_ADD_STATE is record
        offset : unsigned(CAPACITY-1 downto 0);
        is_full : boolean;
        is_in : boolean;
        is_handling : boolean;
        index_found : boolean;
    end record;

    signal c_state, n_state : T_ADD_STATE := (offset => (others => '0'), is_full => false, is_in => false, is_handling => false, index_found => false);
    
    pure function hash_con(
        object : std_logic_vector(DATA_WIDTH-1 downto 0)) 
    return unsigned is
    begin
        if (DATA_WIDTH <= ADDRESS_WIDTH) then
            return resize(unsigned(object), ADDRESS_WIDTH);
        else
            return unsigned(object) mod CAPACITY;
        end if;
    end function;

begin 

-- index_of
c_state_update : process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                c_state <= (offset => (others => '0'), is_full => false, is_in => false, is_handling => false, index_found => false);
            elsif add_enable = '1' and not c_state.is_full then 
                c_state <= n_state;
            end if;
        end if;
    end process;
    
base_update : process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
	             base <= (others => '0');
            elsif add_enable = '1' and not c_state.is_full and not c_state.is_handling then 
                 base <= hash_con(data_in) mod CAPACITY;
            end if;
        end if;
    end process;

n_state_update : process (base, c_state, add_enable, data_in, memory)
        variable element : T_SET_ELEMENT;
    begin
        n_state <= c_state;
        if add_enable = '1' and not c_state.is_full then
            if not c_state.is_handling then -- we did not start yet
                n_state.offset <= (others => '0');
                n_state.is_handling <= true;
            elsif c_state.index_found then  -- the index was found, prepare for the next request
                n_state <= (offset => (others => '0'), is_full => c_state.is_full, is_in => false, is_handling => false, index_found => false);
            elsif c_state.offset = CAPACITY then    --no more space
                n_state.is_full <= true;
            else                                    -- element lookup
                element := memory(to_integer((base + c_state.offset) mod CAPACITY));
                if not element.is_set then          -- empty space found
                    n_state.index_found <= true;
                elsif element.data = data_in then   -- the data_in is in the set
                    n_state.index_found <= true;
                    n_state.is_in <= true;
                else
                    n_state.offset <= c_state.offset + 1; -- the space is ocupied go to the next space
                end if;
            end if;
        end if;
    end process;
memory_update : process (clk)
	begin
	if rising_edge(clk) then
            if reset = '1' then
                memory <= (others => (data => (others => '0'), is_set => FALSE));
            elsif add_enable = '1' and not c_state.is_full and c_state.index_found and not c_state.is_in then 
                memory(to_integer((base + c_state.offset) mod CAPACITY)) <= (data => data_in, is_set => true);
            end if;
	end if;
	end process;

    --output
    is_in     <= '1' when c_state.index_found and c_state.is_in else '0';
    add_ok    <= '1' when c_state.index_found else '0';
    add_error <= '1' when add_enable = '1' and c_state.is_full else '0';
    is_full   <= '1' when c_state.is_full else '0';

end architecture;