library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture b of fifo is 

type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
constant CAPACITY :integer := 2**ADDRESS_WIDTH;
signal memory : T_MEMORY := (others => (others => '0'));
attribute ram_style : string;
attribute ram_style of memory : signal is "block";

signal read_ptr, write_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- read and write pointers
signal full_ff, empty_ff : std_logic;

begin 
-- push
push_handler : process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                write_ptr <= 0;
            else 
                if push_enable = '1' and full_ff = '0' then 
                    write_ptr <= (write_ptr + 1) mod CAPACITY;
                    memory(write_ptr) <= data_in;
                end if;
            end if;
        end if;
    end process;

push_error <= '1' when push_enable = '1' and full_ff = '1' else '0';

-- pop
pop_handler : process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                read_ptr <= 0;
            else 
                if pop_enable = '1' and empty_ff = '0' then 
                    read_ptr <= (read_ptr + 1) mod CAPACITY;
                end if;
            end if;
        end if;
    end process;

data_out <= memory(read_ptr);

pop_error <= '1' when pop_enable = '1' and empty_ff = '1' else '0';

-- status
full_ff  <= '1' when (write_ptr + 1 = read_ptr)     else '0';
empty_ff <= '1' when read_ptr = write_ptr         else '0';

-- connect full and empty
is_full <= full_ff;
is_empty <= empty_ff;

end architecture;
