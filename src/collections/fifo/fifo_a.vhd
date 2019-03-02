library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture a of fifo is 

    type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    signal memory : T_MEMORY := (others => (others => '0'));
    signal read_ptr, write_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- read and write pointers
    signal full_ff, empty_ff : std_logic;

begin 
-- push
--[Synth 8-27] else clause after check for clock not supported ["fifo.vhd":34]
write_ptr <= (write_ptr + 1) mod CAPACITY     when rising_edge(clk) and reset = '0' and push_enable = '1' and full_ff ='0' else 
            0                                 when rising_edge(clk) and reset = '1' else
            write_ptr; --[XSIM 43-3211] Waveform unaffected is not supported.


memory(write_ptr) <= data_in when rising_edge(clk) and reset = '0' and push_enable = '1' and full_ff = '0' else
                    memory(write_ptr); --unaffected not supported

push_error <= '1' when push_enable = '1' and full_ff = '1' else '0';

-- pop
read_ptr <= (read_ptr + 1) mod CAPACITY     when rising_edge(clk) and reset = '0' and pop_enable = '1' and empty_ff='0' else 
            0                               when rising_edge(clk) and reset = '1' else
            read_ptr; --unaffected not supported

data_out <= memory(read_ptr);

pop_error <= '1' when pop_enable = '1' and empty_ff = '1' else '0';

-- status
full_ff  <= '1' when (write_ptr + 1 = read_ptr)     else '0';
empty_ff <= '1' when read_ptr = write_ptr         else '0';

-- connect full and empty
is_full <= full_ff;
is_empty <= empty_ff;

end architecture;