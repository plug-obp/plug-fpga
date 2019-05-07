library ieee;
use ieee.std_logic_1164.all;
use work.open_components.all; 


architecture a of stack is

	signal rf_c_r		 	: std_logic; 
	signal rf_c_w		 	: std_logic; 
	signal rf_c_r_data		: std_logic_vector(DATA_WIDTH-1 downto 0); 
	signal rf_c_w_data		: std_logic_vector(DATA_WIDTH-1 downto 0); 
	signal rf_c_r_addr		: std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
	signal rf_c_w_addr		: std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
	signal rf_c_r_ok 		: std_logic; 

begin


	controler : controler_cmp
		generic map (
			HAS_OUTPUT_REGISTER => false, 
			ADDR_WIDTH => ADDRESS_WIDTH, 
			DATA_WIDTH => DATA_WIDTH
		)
		port map (
			clk 			=> clk, 
			reset 			=> reset, 
			reset_n 		=> reset_n, 
			is_pingpong 	=> is_pingpong, 
			pop_enable 		=> pop_enable, 
			push_enable 	=> push_enable, 
			data_in 		=> data_in, 
			mark_last 		=> mark_last, 
			data_out 		=> open, --data_out, 
			data_ready 		=> open, --data_ready, 
			is_empty 		=> is_empty, 
			is_full 		=> is_full, 
			is_last 		=> is_last, 
			pop_is_done 	=> pop_is_done, 
			push_is_done 	=> push_is_done, 
			is_swapped 		=> is_swapped, 

			rf_c_r			=> rf_c_r, 
			rf_c_w			=> rf_c_w, 
			rf_c_r_data		=> rf_c_r_data, 
			rf_c_w_data		=> rf_c_w_data, 
			rf_c_r_addr		=> rf_c_r_addr, 
			rf_c_w_addr		=> rf_c_w_addr, 
			rf_c_r_ok		=> rf_c_r_ok
			 
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
			clear => '0', 
			
			we 		=> rf_c_w,
			addr_w 	=> rf_c_w_addr, 
			d_in 	=> rf_c_w_data, 

			re 		=> rf_c_r, 
			addr_r 	=> rf_c_r_addr,
			d_out 	=> data_out, 
			r_ok	=> data_ready
		); 


end architecture;


