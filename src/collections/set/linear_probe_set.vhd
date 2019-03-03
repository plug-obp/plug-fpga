library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture linear_set of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_SET_ELEMENT is record
        data : std_logic_vector(DATA_WIDTH-1 downto 0);
        is_set : boolean;
    end record;
    type T_MEMORY is array (0 to CAPACITY - 1) of T_SET_ELEMENT;
    signal memory : T_MEMORY := (others => (data => (others => '0'), is_set => FALSE));
    signal write_ptr : integer range 0 to CAPACITY-1 := 0; -- write pointer
    signal full_ff : std_logic := '0';
    signal already_in_ff : std_logic := '0';

pure function index_of(
    memory : T_MEMORY;
    object : std_logic_vector(DATA_WIDTH - 1 downto 0);
    hash : unsigned(HASH_WIDTH-1 downto 0))
return unsigned(2**ADDRESS_WIDTH-1 downto 0) is
    variable index, start : integer;
    variable first : boolean := TRUE;
begin
    index := hash mod CAPACITY;
    while first or start /= index loop
        element := memory(index);
        if element.is_set = false or element.data = object then
            return index;
        end if;
        if first then
            start := index;
            first := false;
        end if;
        index := (index + 1) mod CAPACITY;
    end loop;

end function;

pure function is_included(
    memory : T_MEMORY; 
    data_in: std_logic_vector(DATA_WIDTH- 1 downto 0); 
    last_idx : integer) 
return boolean is
    variable idx : integer := 0;
begin
    for idx in 0 to CAPACITY loop
        if idx > last_idx then exit; end if;
        if memory(idx) = data_in then
            return true;
        end if;
    end loop;
    return false;
end;

begin 
-- add
add_handler : process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                write_ptr <= 0;
            else 
                if add_enable = '1' and full_ff = '0' then 
                    if (is_included(memory, data_in, write_ptr)) then
                        already_in_ff <= '1';
                    else
                        write_ptr <= (write_ptr + 1) mod CAPACITY;
                        memory(write_ptr) <= data_in;
                        already_in_ff <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

add_error <= '1' when add_enable = '1' and full_ff = '1' else '0';

-- status
full_ff  <= '1' when (write_ptr = CAPACITY)     else '0';

already_in <= already_in_ff;

-- connect full 
is_full <= full_ff;

end architecture;