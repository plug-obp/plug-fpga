library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture linear_probe_set of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_SET_ELEMENT is record
        data : std_logic_vector(DATA_WIDTH-1 downto 0);
        is_set : boolean;
    end record;
    type T_MEMORY is array (0 to CAPACITY - 1) of T_SET_ELEMENT;
    signal memory : T_MEMORY := (others => (data => (others => '0'), is_set => FALSE));
    signal full_ff : std_logic := '0';
    signal already_in_ff : std_logic := '0';

    type T_INDEX is record
        ptr : integer range 0 to CAPACITY-1;
        is_valid : boolean;
        is_found : boolean;
    end record;

    pure function index_of(
        memory : T_MEMORY;
        object : std_logic_vector(DATA_WIDTH - 1 downto 0);
        hash : integer)
    return T_INDEX is
        variable index, start : unsigned(CAPACITY - 1 downto 0);
        variable first : boolean := TRUE;
    begin
        index := hash mod CAPACITY;
        while first or start /= index loop
            element := memory(index);
            if (element.is_set = false) then
                return (index => index, is_valid => true, is_found => false);
            elsif (element.data = object) then
                return (index => index, is_valid => true, is_found => true);
            end;
            if first then
                start := index;
                first := false;
            end if;
            index := (index + 1) mod CAPACITY;
        end loop;
        return (index => 0, is_valid => false, is_found => false); -- no space left
    end function;

    pure function hash(
        object : std_logic_vector(DATA_WIDTH - 1 downto 0)) 
    return integer is
        constant NB_CHUNKS : integer := ((DATA_WIDTH + (ADDRESS_WIDTH/2))/ ADDRESS_WIDTH);
        variable hash : integer := 0;
        variable data : std_logic_vector(resize(unsigned(object), NB_CHUNKS*ADDRESS_WIDTH));
    begin
        if (DATA_WIDTH <= ADDRESS_WIDTH) then
            return to_integer(unsigned(object));
        else
            for i in 0 to NB_CHUNKS - 1 loop
                hash := hash xor (data(i*ADDRESS_WIDTH to i*ADDRESS_WIDTH + ADDRESS_WIDTH - 1));
            end loop;
            return hash;
        end if;
    end;

begin 
-- add
add_handler : process (clk) is
        variable index : T_INDEX;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                write_ptr <= 0;
            else 
                if add_enable = '1' and full_ff = '0' then 
                    index := index_of(memory, data_in, hash(data_in));
                    if index.is_valid then 
                        if index.is_found then
                            already_in_ff <= '1';
                        else
                            memory(index.ptr) <= (data => data_in, is_set => true);
                            already_in_ff <= '0';
                        end if;
                    else 
                        full_ff <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

add_error <= '1' when add_enable = '1' and full_ff = '1' else '0';

already_in <= already_in_ff;

-- connect full 
is_full <= full_ff;

end architecture;