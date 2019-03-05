library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture linear_probe_set_b of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_SET_ELEMENT is record
        data : std_logic_vector(DATA_WIDTH-1 downto 0);
        is_set : boolean;
    end record;
    type T_MEMORY is array (0 to CAPACITY - 1) of T_SET_ELEMENT;
    signal memory : T_MEMORY := (others => (data => (others => '0'), is_set => FALSE));

    type T_ADD_STATE is record
        base : unsigned(CAPACITY-1 downto 0);
        offset : unsigned(CAPACITY-1 downto 0);
        is_full : boolean;
        is_in : boolean;
        is_handling : boolean;
        index_found : boolean;
    end record;

    signal state : T_ADD_STATE := (base => (others => '0'), offset => (others => '0'), is_full => false, is_in => false, is_handling => false, index_found => false);
    
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
state_update : process (clk)
    variable address : integer;
	variable element : T_SET_ELEMENT;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                memory <= (others => (data => (others => '0'), is_set => FALSE));
                state <= (base => (others => '0'), offset => (others => '0'), is_full => false, is_in => false, is_handling => false, index_found => false);
            elsif add_enable = '1' and not state.is_full then 
                if state.offset = CAPACITY then    --no more space
                    state.is_full <= true;
                    state.is_handling <= false;
                else                                    
                    if not state.is_handling then -- we did not start yet
                        state.base <= hash_con(data_in) mod CAPACITY;
                        state.offset <= (others => '0');
                        state.is_handling <= true;
                    end if;
                    address := to_integer((state.base + state.offset) mod CAPACITY);
                    element := memory(address);
                    if not element.is_set then          -- empty space found
                        state.index_found <= true;
                        memory(address) <= (data => data_in, is_set => true);
                        state.is_handling <= false;
                    elsif element.data = data_in then   -- the data_in is in the set
                        state.index_found <= true;
                        state.is_in <= true;
                        state.is_handling <= false;
                    else
                        state.offset <= state.offset + 1; -- the space is ocupied go to the next space
                    end if;
                end if;
            end if;
        end if;
    end process;

    --output
    is_in     <= '1' when state.index_found and state.is_in else '0';
    add_ok    <= '1' when state.index_found else '0';
    add_error <= '1' when add_enable = '1' and state.is_full else '0';
    is_full   <= '1' when state.is_full else '0';

end architecture;