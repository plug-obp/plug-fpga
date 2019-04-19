	library ieee; 
	use ieee.std_logic_1164.all; 
	
	entity stack_controler is 
		generic (
			HAS_OUTPUT_REGISTER : boolean := true; 
			ADDR_WIDTH : integer := 8; 
			DATA_WIDTH : integer := 64 
		); 
		port (
      		clk          : in  std_logic;     	-- clock
      		reset        : in  std_logic;  		-- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
      		reset_n      : in  std_logic;
      		is_pingpong  : in  std_logic; 
      		pop_enable   : in  std_logic;     	-- read enable 
      		push_enable  : in  std_logic;     	-- write enable 
      		data_in      : in  std_logic_vector(DATA_WIDTH- 1 downto 0);  -- the data that is added when write_enable
      		mark_last    : in  std_logic;
      		data_out     : out std_logic_vector(DATA_WIDTH- 1 downto 0);  -- the data that is read if read_enable
      		data_ready   : out std_logic;
      		is_empty     : out std_logic;  		-- is_empty is asserted when no elements are in
      		is_full      : out std_logic;  		-- is_full is asserted when data_count == CAPACITY
      		is_last      : out std_logic;
      		pop_is_done  : out std_logic;
      		push_is_done : out std_logic; 
      		is_swapped   : out std_logic; 


			-- I/Os for config reg file 
			rf_c_r 		: out std_logic; 
			rf_c_w 		: out std_logic; 
			rf_c_w_data : out std_logic_vector(DATA_WIDTH -1 downto 0);  
			rf_c_r_data : in  std_logic_vector(DATA_WIDTH -1 downto 0);
			rf_c_w_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0);  
			rf_c_r_addr : out  std_logic_vector(ADDR_WIDTH -1 downto 0);
			rf_c_r_ok 	: in std_logic 

		); 

	end entity; 
