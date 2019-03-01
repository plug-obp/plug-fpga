library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo is
	generic
	(
		ADDRESS_WIDTH	: integer	:= 4;								-- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
		DATA_WIDTH 		: integer	:= 24 								-- data width in bits, the size of a configuration
	);
	port 
	( 
		clk 			: in  std_logic;								-- clock
		reset 			: in  std_logic;								 -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
		pop_enable 	    : in  std_logic; 								    -- read enable 
		push_enable	    : in  std_logic; 								    -- write enable 
		data_in 		: in  std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is added when write_enable
		data_out		: out std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is read if read_enable
		is_empty 		: out std_logic; 								-- is_empty is asserted when no elements are in
		is_full			: out std_logic; 								-- is_full is asserted when data_count == CAPACITY
		push_error		: out std_logic := 0;
		pop_error		: out std_logic := 0
	);
end fifo;
architecture a of fifo is 

type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
constant CAPACITY :integer := 2**ADDRESS_WIDTH;
signal memory : T_MEMORY := (others => (others => '0'));
signal read_ptr, write_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- read and write pointers
signal full_ff, empty_ff : std_logic;

begin 
-- push
write_ptr <= (write_ptr + 1) mod CAPACITY 	when rising_edge(clk) and reset = '0' else 
			0 								when rising_edge(clk) and reset = '1' else
			unaffected;

memory(write_ptr) <= data_in when rising_edge(clk) and reset = '0' and push_enable = '1' and full_ff = '0' else
					unaffected;

push_error <= '1' when push_enable = '1' and full_ff = '1' else '0';

-- pop
read_ptr <= (read_ptr + 1) mod CAPACITY 	when rising_edge(clk) and reset = '0' else 
			0 								when rising_edge(clk) and reset = '1' else
			unaffected;

data_out <= memory(read_ptr);

pop_error <= '1' when pop_enable = '1' and empty_ff = '1' else '0';

-- status
full_ff  <= '1' when (write_ptr + 1 = read_ptr) 	else '0';
empty_ff <= '1' when read_ptr = write_ptr 		else '0';

-- connect full and empty
is_full <= full_ff;
is_empty <= empty_ff;

end architecture;