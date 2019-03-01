library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture linear_set of set is
    type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    signal memory : T_MEMORY := (others => (others => '0'));
    signal write_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- read and write pointers
    signal full_ff : std_logic;

pure function is_included(memory : T_MEMORY, data_in: std_logic_vector(DATA_WIDTH- 1 downto 0), last_idx : integer) return boolean is
    variable idx : integer := 0;
begin
	for idx in 0 to last_idx loop
        if memory(idx) = data_in then
            return true;
        end if;
    end for;
    return false;
end;

begin 
-- push
push_handler : process (clk) is
	begin
		if rising_edge(clk) then
			if reset = '1' then
				write_ptr <= 0;
			else 
				if add_enable = '1' and full_ff = '0' then 
                    if (is_included(memory, data_in, write_ptr)) then
                        already_in <= '1';
                    else
					    write_ptr <= (write_ptr + 1) mod CAPACITY;
					    memory(write_ptr) <= data_in;
                        already_in <= '0';
                    end if;
				end if;
			end if;
		end if;
	end process;

push_error <= '1' when push_enable = '1' and full_ff = '1' else '0';

-- status
full_ff  <= '1' when (write_ptr = CAPACITY) 	else '0';

-- connect full and empty
is_full <= full_ff;

end architecture;