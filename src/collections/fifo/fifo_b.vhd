library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture b of fifo is 
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_MEMORY is array (0 to CAPACITY - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal memory : T_MEMORY := (others => (others => '0'));
    attribute ram_style : string;
    attribute ram_style of memory : signal is "block";

    signal read_ptr, write_ptr : integer range 0 to CAPACITY-1 := 0; -- read and write pointers
    signal full: boolean := false; 
    signal empty : boolean := true;

begin 
-- push
push_handler : process (clk, reset_n) is
	variable idx : integer;
    begin
	if reset_n = '0' then
		write_ptr <= 0;
		memory <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if reset = '1' then
                write_ptr <= 0;
		memory <= (others => (others => '0'));
            else 
                if push_enable = '1' and not full then 
		    idx := (write_ptr + 1) mod CAPACITY;
                    write_ptr <= idx;
                    memory(write_ptr) <= data_in;
		    
                end if;
            end if;
        end if;
    end process;

process (write_ptr, read_ptr) is
begin
	if read_ptr'event then
		if read_ptr = write_ptr then
			empty <= true;
			full <= false;
		    else
			empty <= false;
			full <= false;
		    end if;
	elsif write_ptr'event then
		if read_ptr = write_ptr then
			empty <= false;
			full <= true;
		    else
			empty <= false;
			full <= false;
		    end if;
	end if;
end process;

-- pop
pop_handler : process (clk, reset_n) is
	variable idx : integer;
    begin
	if reset_n = '0' then
		read_ptr <= 0;
		data_ready <= '0';
        elsif rising_edge(clk) then
            if reset = '1' then
                read_ptr <= 0;
		data_ready <= '0';
            else 
                if pop_enable = '1' and not empty then 
		    idx := (read_ptr + 1) mod CAPACITY;
                    read_ptr <= idx;
		    data_ready <= '1';
		else 
		    data_ready <= '0';
                end if;
            end if;
        end if;
    end process;

data_out <= memory(read_ptr);

-- status
--full  <= true when (write_ptr + 1 = read_ptr)   else false;
--empty <= true when read_ptr = write_ptr         else false;

-- connect full and empty
is_full <= '1' when full else '0';
is_empty <= '1' when empty else '0';

end architecture;
