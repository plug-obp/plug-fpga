library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Ping pong FIFO implemented using as a circular buffer.
-- The barrier pointer gets the value of the write_ptr if the read_ptr = barrier_ptr, in that case swapped is asserted
entity pingpong_fifo is
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
		swapped			: out std_logic;
		is_error		: out std_logic_vector(1 downto 0) := B"00"
	);
end pingpong_fifo;
architecture a of pingpong_fifo is 

type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
constant CAPACITY :integer := 2**ADDRESS_WIDTH;
signal memory : T_MEMORY := (others => (others => '0'));
signal read_ptr, write_ptr, barrier_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- read and write pointers
signal full_ff, empty_ff : std_logic;

begin 

update: process (clk) 
	begin
		if rising_edge(clk) then
			if reset = '1' then
				read_ptr <= 0;
				write_ptr <= 0;
				barrier_ptr <= 0;
				is_error <= B"00";
			else
				if push_enable = '1' then
					if full_ff = '0' then
						if write_ptr < CAPACITY - 1 then 
							write_ptr <= write_ptr + 1;
						else 
							write_ptr <= 0;
						end if;
						memory(write_ptr) <= data_in;
						is_error <= (others => '0');
					else
						is_error <= B"01"; -- write when full
					end if;
				end if;

				if pop_enable = '1' then
					if empty_ff = '0' then
						if read_ptr < CAPACITY - 1 then
							read_ptr <= read_ptr + 1;
						else 
							read_ptr <= 0;
						end if;
						is_error <= (others => '0');
					else 
						is_error <= B"10"; --read when empty
					end if;
				end if;
			end if;
		end if;
	end process;

data_out <= memory(read_ptr);

full_ff  <= '1' when (write_ptr + 1 = read_ptr) 	else '0';
empty_ff <= '1' when read_ptr = write_ptr 		else '0';
barrier_ptr <= write_ptr when read_ptr = barrier_ptr else barrier_ptr; -- handle the barrier_ptr

-- connect full and empty
is_full <= full_ff;
is_empty <= empty_ff;
swapped  <= '1' when barrier_ptr'EVENT else '0';

end architecture;