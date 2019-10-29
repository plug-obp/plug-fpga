library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity set is
	generic(
		HAS_OUTPUT_REGISTER : boolean := true;
		ADDRESS_WIDTH       : integer := 8; -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
		DATA_WIDTH          : integer := 16 -- data width in bits, the size of a configuration
	);
	port(
		reset_n     : in  std_logic;
		clk         : in  std_logic;    -- clock
		reset       : in  std_logic;    -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
		add_enable  : in  std_logic;    -- write enable 
		data_in     : in  std_logic_vector(DATA_WIDTH - 1 downto 0); -- the data that is added when write_enable
		clear_table : in  std_logic;
		is_in       : out std_logic;    -- already_in is asserted if the last data_in handled was already in the set
		is_full     : out std_logic;    -- is_full is asserted when data_count == CAPACITY
		is_done     : out std_logic
	);
end entity set;
