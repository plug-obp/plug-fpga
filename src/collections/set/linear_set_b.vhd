library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture linear_set_b of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_MEMORY is array (0 to CAPACITY - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal memory : T_MEMORY := (others => (others => '0'));
    signal write_ptr : unsigned(CAPACITY downto 0);
    signal current_ptr : unsigned(CAPACITY-1 downto 0);
    signal s_is_full : boolean := false;
    signal s_is_added_ok : boolean := false;
    signal s_is_in : boolean := false;
begin 
-- add
add_handler : process (clk) is
        variable element : std_logic_vector (DATA_WIDTH - 1 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                memory <= (others => (others => '0'));
                write_ptr <= (others => '0');
                current_ptr <= (others => '0');
                s_is_added_ok <= false;
                s_is_in <= false;
            else
                if add_enable = '1' and s_is_full = '0' then 
                    if memory(to_integer(current_ptr)) = data_in then
                        s_is_in <= true;
                        s_is_added_ok <= true;
                        current_ptr <= (others => '0');
                    elsif current_ptr + 1 = write_ptr then
                        write_ptr <= write_ptr + 1;
                        memory(write_ptr) <= data_in;
                        s_is_in <= false;
                        s_is_added_ok <= true;
                        current_ptr <= (others => '0')
                    else
                        current_ptr <= current_ptr + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    s_is_full <= true when write_ptr = CAPACITY else false;

    --output
    is_in     <= '1' when s_is_added_ok and s_is_in else '0';
    add_ok    <= '1' when s_is_added_ok else '0';
    add_error <= '1' when add_enable = '1' and s_is_full else '0';
    is_full   <= '1' when s_is_full else '0';

end architecture;