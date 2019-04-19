library ieee;
use ieee.std_logic_1164.all;
use work.hash_table_components.all; 


architecture hash_table_a of set is
	constant HASH_WIDTH : integer := 16; 

	signal add_enable_s : std_logic; 
	signal hash_s : std_logic_vector(HASH_WIDTH-1 downto 0); 
	signal hash_ok_s : std_logic; 
	signal data_in_s : std_logic_vector(DATA_WIDTH -1 downto 0); 

	signal rf_c_r		 	: std_logic; 
	signal rf_c_w		 	: std_logic; 
	signal rf_c_r_data		: std_logic_vector(DATA_WIDTH-1 downto 0); 
	signal rf_c_w_data		: std_logic_vector(DATA_WIDTH-1 downto 0); 
	signal rf_c_r_addr		: std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
	signal rf_c_w_addr		: std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
	signal rf_c_r_ok 		: std_logic; 

	signal rf_p_r		 	: std_logic; 
	signal rf_p_w		 	: std_logic; 
	signal rf_p_r_data		: std_logic_vector(0 downto 0); 
	signal rf_p_w_data		: std_logic_vector(0 downto 0); 
	signal rf_p_r_addr		: std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
	signal rf_p_w_addr		: std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
	signal rf_p_r_ok 		: std_logic; 
begin

	add_enable_s <= add_enable; 
	data_in_s  <= data_in; 

	hash_funct : hash_block_cmp
		generic map(
			DATA_WIDTH => DATA_WIDTH, 
			HASH_WIDTH => HASH_WIDTH, 
			WORD_WIDTH => 8 
		)
		port map (
			clk => clk, 
			reset => reset, 
			reset_n => reset_n, 
			data => data_in_s, 
			hash_en => add_enable_s, 
			hash_key => hash_s, 
			hash_ok => hash_ok_s
		); 

	controler : controler_cmp
		generic map (
			HAS_OUTPUT_REGISTER => false, 
			HASH_WIDTH 	=> HASH_WIDTH, 
			ADDR_WIDTH => ADDRESS_WIDTH, 
			DATA_WIDTH => DATA_WIDTH
		)
		port map (
			clk 		=> clk, 
			reset 		=> reset, 
			reset_n 	=> reset_n, 

			add_enable 	=> add_enable_s, 
			data 		=> data_in_s, 

			clear_table => clear_table, 
			isIn 		=> is_in, 
			isFull 		=> is_full, 
			isDone 		=> is_done, 

			hash_ok 	=> hash_ok_s, 
			hash 		=> hash_s, 

			rf_c_r			 => rf_c_r, 
			rf_c_w			 => rf_c_w, 
			rf_c_r_data		 => rf_c_r_data, 
			rf_c_w_data		 => rf_c_w_data, 
			rf_c_r_addr		 => rf_c_r_addr, 
			rf_c_w_addr		 => rf_c_w_addr, 
			rf_c_r_ok		 => rf_c_r_ok,

			 
			rf_p_r		 	 => rf_p_r, 
			rf_p_w		 	 => rf_p_w, 
			rf_p_r_data		 => rf_p_r_data, 
			rf_p_w_data		 => rf_p_w_data, 
			rf_p_r_addr		 => rf_p_r_addr, 
			rf_p_w_addr		 => rf_p_w_addr, 
			rf_p_r_ok		 => rf_p_r_ok
		); 


	reg_file_configs : reg_file_ssdpRAM_cmp
		generic map(
			MEM_TYPE => "block", 
			DATA_WIDTH => DATA_WIDTH, 
			ADDR_WIDTH => ADDRESS_WIDTH
		)
		port map(
			clk => clk, 
			reset => reset_n, 
			
			we 		=> rf_c_w,
			addr_w 	=> rf_c_w_addr, 
			d_in 	=> rf_c_w_data, 

			re 		=> rf_c_r, 
			addr_r 	=> rf_c_r_addr,
			d_out 	=> rf_c_r_data, 
			r_ok	=> rf_c_r_ok
		); 


	reg_file_isFilled : reg_file_ssdpRAM_cmp
		generic map(
			MEM_TYPE => "block", 
			DATA_WIDTH => 1, 
			ADDR_WIDTH => ADDRESS_WIDTH
		)
		port map(
			clk => clk, 
			reset => reset_n, 
			
			we 		=> rf_p_w,
			addr_w 	=> rf_p_w_addr, 
			d_in 	=> rf_p_w_data, 

			re 		=> rf_p_r, 
			addr_r 	=> rf_p_r_addr,
			d_out 	=> rf_p_r_data,
			r_ok 	=> rf_p_r_ok
		); 


end architecture;


