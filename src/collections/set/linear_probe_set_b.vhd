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
    signal full_ff : std_logic := '0';
    signal already_in_ff : std_logic := '0';

    signal start, index, next_index : unsigned(CAPACITY-1 downto 0);
    signal found : boolean := FALSE;

    
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
sync : process (clk)
        variable idx : unsigned(CAPACITY-1 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                memory <= (others => (data => (others => '0'), is_set => FALSE));
                full_ff <= '0';
                already_in_ff <= '0';
                index <= (others => '0');
                start <= (others => '0');
            else
                if add_enable = '1' and full_ff = '0' and not found then 
                    idx := hash_con(data_in) mod CAPACITY;
                    index <= idx;
                    next_index <= idx;
                end if;
            end if;
        end if;
    end process;

next_state : process (index)
        variable idx : integer;
    begin
        if add_enable = '1' and full_ff = '0' then
            if not found then -- while not found 
                if index = next_index then -- begin search starting at hash % capacity
                    start <= index;
                    next_index <= (index + 1) mod CAPACITY;
                elsif next_index /= start then  -- if collision go to the next element
                    index <= next_index;
                    next_index <= (index + 1) mod CAPACITY;
                else -- if next_index == start then the fifo is full
                    full_ff <= '1';
                end if;
            else
                -- the element was found reinitialize for the next request
                found <= false;
            end if;
        end if;
    end process;

set_output : process (index)
        variable element : T_SET_ELEMENT;
    begin
        --handle add
        if add_enable = '1' and full_ff = '0' then
            element := memory(to_integer(index));
            if (element.is_set = false) then
                found <= true;
                memory(to_integer(index)) <= (data => data_in, is_set => true);
                already_in_ff <= '0';
            elsif (element.data = data_in) then
                found <= true;
                already_in_ff <= '1';
            end if;
        end if;
    end process;

add_error <= '1' when add_enable = '1' and full_ff = '1' else '0';

is_in <= already_in_ff;

-- connect full 
is_full <= full_ff;

end architecture;