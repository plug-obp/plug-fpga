

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.bloom_filter_components.all;

architecture bloom_filter_c of set is
	constant hash_num : integer := 16; 
	constant HASH_WIDTH : integer := 32;
	type t_config_array is array(hash_num-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0); 
	
	signal add_enable_s : std_logic_vector(16 downto 0);
	signal data_in_s    : t_config_array; 
	
	type hash_array_t is array(hash_num-1 downto 0) of std_logic_vector(HASH_WIDTH-1 downto 0);
	
	signal hash_s       : hash_array_t;
	signal hash_ok_s    : std_logic_vector(hash_num-1 downto 0 );
	
	
	signal rf_p_r      : std_logic;
	signal rf_p_w      : std_logic;
	signal rf_p_clear  : std_logic;
	signal rf_p_r_data : std_logic_vector(0 downto 0);
	signal rf_p_w_data : std_logic_vector(0 downto 0);
	signal rf_p_r_addr : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	signal rf_p_w_addr : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	
	signal rf_p_r_ok   : std_logic;
	type t_fifo is record
		data : std_logic_vector(DATA_WIDTH -1 downto 0);
		is_in : std_logic; 
	end record t_fifo;
	type t_fifo_array is array(hash_num-1 downto 0) of t_fifo;
	
	shared variable FIFO : t_fifo_array; 
	
	type t_config_hash is record
		slot_empty : boolean; 
		config : std_logic_vector(DATA_WIDTH-1 downto 0);
		hash : std_logic_vector(HASH_WIDTH-1 downto 0); 
	end record t_config_hash;
	
	
	type t_config_hash_array is array(hash_num-1 downto 0) of t_config_hash; 
	signal config_hash_array : t_config_hash_array; 
	
	
	signal add_enable_ctrl : std_logic;
	signal data_in_ctrl : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal hash_ok_ctrl : std_logic;
	signal hash_ctrl : std_logic_vector(HASH_WIDTH - 1 downto 0);
	signal write_index_in_fifo : integer := 0; 
	
	signal hash_processing : std_logic_vector(hash_num-1 downto 0); 
	
begin

--	add_enable_s <= add_enable;
--	data_in_s    <= data_in;

	hash_in_fifo : process (clk, reset_n) is
		begin
		if reset_n = '0' then
			FIFO := (others => (data => (others => '0'), is_in => '0'))	; 
		elsif rising_edge(clk) then
			if add_enable = '1' then 
				FIFO(write_index_in_fifo) := (data => data_in, is_in => '1'); 
				write_index_in_fifo <= write_index_in_fifo + 1 ; 
			end if; 
		end if;
	end process hash_in_fifo;
	

	hash_gen : for i in 0 to hash_num -1 generate
	
		process (clk, reset_n) is
		begin
			if reset_n = '0' then
				data_in_s(i) <= (others => '0'); 
				add_enable_s(i) <= '0';
				config_hash_array(i) <= (hash => (others => '0'), config => (others => '0'), slot_empty => true); 
			elsif rising_edge(clk) then
				if FIFO(i).is_in = '1' then 
 					data_in_s(i) <= FIFO(i).data; 
					add_enable_s(i) <= '1'; 
					FIFO(i).is_in := '0';
					hash_processing(i) <= '1'; 
				else 
					add_enable_s(i) <= '0'; 
				end if; 
				if hash_processing(i) = '1' and hash_ok_s(i) = '1' then
					config_hash_array(i).hash <= hash_s(i);  
					config_hash_array(i).config <= FIFO(i).data; 
					config_hash_array(i).slot_empty <= false; 
				end if; 
			end if;
		end process ;
		
		
		hash_funct : entity work.hash(murmur3_wrapper)
			generic map(
				DATA_WIDTH => DATA_WIDTH,
				HASH_WIDTH => HASH_WIDTH,
				WORD_WIDTH => 8
			)
			port map(
				clk      => clk,
				reset    => reset,
				reset_n  => reset_n,
				data     => data_in_s(i),
				hash_en  => add_enable_s(i),
				hash_key => hash_s(i),
				hash_ok  => hash_ok_s(i)
			);
			
--			buf_config : process (clk, reset_n) is
--				variable config : std_logic_vector(DATA_WIDTH-1  downto 0):= (others => '0');
--				variable hash : std_logic_vector(HASH_WIDTH -1 downto 0); 
--				variable hash_idle : boolean := true; 
--			begin
--				if reset_n = '0' then
--					config := (others => '0'); 
--					hash_idle := true; 
--				elsif rising_edge(clk) then
--					if add_enable_s(i) = '1' then
--						config := data_in_s(i); 
--						hash_idle := false; 
--					elsif not hash_idle and hash_ok_s(i) = '1' then 
--						hash := hash_s(i); 
--						hash_idle := true; 
--					elsif config_hash_array(i).slot_empty then 
--						
--					end if;
--					
--				end if;
--			end process buf_config;
			
		--config_hash_array(i).config <= config; 
		--config_hash_array(i).hash <= hash_s(i); 
			
			
		
	end generate hash_gen;

--
--	hash_fifo_out : process (clk, reset_n) is
--		
--	begin
--		if reset_n = '0' then
--			config_hash_array <= (others => (slot_empty => true, config => (others => '0'), hash => (others => '0'))); 
--		elsif rising_edge(clk) then
--		
--		for i in 0 to config_hash_array'length-1 loop
--			if not config_hash_array(i).slot_empty then 
--				add_enable_ctrl <= '1'; 
--				data_in_ctrl <= config_hash_array(i).config; 
--				hash_ctrl <= config_hash_array(i).hash; 
--				hash_ok_ctrl <= '1'; 
--			end if; 
--		end loop;
--				
--			
--		end if;
--	end process hash_fifo_out;

--	
--	
--	controler : controler_cmp
--		generic map(
--			HAS_OUTPUT_REGISTER => HAS_OUTPUT_REGISTER,
--			HASH_WIDTH          => HASH_WIDTH,
--			ADDR_WIDTH          => ADDRESS_WIDTH,
--			DATA_WIDTH          => DATA_WIDTH
--		)
--		port map(
--			clk         => clk,
--			reset       => reset,
--			reset_n     => reset_n,
--			add_enable  => add_enable_ctrl,
--			data        => data_in_ctrl,
--			clear_table => clear_table,
--			isIn        => is_in,
--			isFull      => is_full,
--			isDone      => is_done,
--			hash_ok     => hash_ok_ctrl,
--			hash        => hash_ctrl,
--			rf_p_r      => rf_p_r,
--			rf_p_w      => rf_p_w,
--			rf_p_clear  => rf_p_clear,
--			rf_p_w_data => rf_p_w_data,
--			rf_p_r_data => rf_p_r_data,
--			rf_p_w_addr => rf_p_w_addr,
--			rf_p_r_addr => rf_p_r_addr,
--			rf_p_r_ok   => rf_p_r_ok
--		);
--
--	reg_file_isFilled : reg_file_ssdpRAM_cmp
--		generic map(
--			MEM_TYPE   => "block",
--			DATA_WIDTH => 1,
--			ADDR_WIDTH => ADDRESS_WIDTH
--		)
--		port map(
--			clk     => clk,
--			reset_n => reset_n,
--			clear   => rf_p_clear,
--			we      => rf_p_w,
--			addr_w  => rf_p_w_addr,
--			d_in    => rf_p_w_data,
--			re      => rf_p_r,
--			addr_r  => rf_p_r_addr,
--			d_out   => rf_p_r_data,
--			r_ok    => rf_p_r_ok
--		);

end architecture;

