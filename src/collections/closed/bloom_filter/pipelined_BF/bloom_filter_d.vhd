

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.bloom_filter_components.all;
use work.murmur3;

 
architecture pipelined_hash of set is
	constant hash_num : integer := 16; 
	constant HASH_WIDTH : integer := 32;
	type t_config_array is array(hash_num-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0); 
	
	signal hash_en : std_logic_vector(16 downto 0);
	signal data_in_s    : t_config_array; 
	
	type hash_array_t is array(hash_num-1 downto 0) of std_logic_vector(HASH_WIDTH-1 downto 0);
	
	signal hash_s       : hash_array_t;
	signal hash_ok_s    : std_logic_vector(hash_num-1 downto 0 );
	

	signal hash_key : hash_array_t; 
	
	
	type t_config_hash is record
		data_read : std_logic; 
		config_rdy : std_logic;
		hash_rdy : std_logic;  
		config : std_logic_vector(DATA_WIDTH-1 downto 0);
		hash : std_logic_vector(HASH_WIDTH-1 downto 0); 
	end record t_config_hash;
	
	
	type t_config_hash_array is array(hash_num-1 downto 0) of t_config_hash; 
	signal config_hash_array : t_config_hash_array; 
	
	
	signal write_index_in_fifo : integer := 0; 
	
	type t_input is record 
		start : std_logic; 		
		config : std_logic_vector(DATA_WIDTH -1 downto 0); 
	end record; 
	type t_inputs is array(hash_num -1 downto 0) of t_input;
	
	signal hash_is_done : std_logic_vector(hash_num-1 downto 0); 
	
	signal hash_inputs : t_inputs; 
	signal seed : std_logic_vector(31 downto 0);
	signal hash_done : std_logic_vector(hash_num-1 downto 0);
	
	type state_t is (s0, s1, s2, s3);
	type state_t_array is array(hash_num-1 downto 0) of state_t; 
	
	signal states_ar : state_t_array; 
	
begin		
	seed  <= std_logic_vector(to_unsigned(42, 32));
	


	hash_in_fifo : process (clk, reset_n) is
		begin
		if reset_n = '0' then
			hash_inputs <= (others =>  ( start => '0', config => (others => '0'))); 
			write_index_in_fifo <= 0; 
		elsif rising_edge(clk) then
			if add_enable = '1' and hash_is_done(write_index_in_fifo) = '1' then 
				hash_inputs(write_index_in_fifo).config <= data_in; 
				hash_inputs(write_index_in_fifo).start <= '1'; 
				write_index_in_fifo <= (write_index_in_fifo + 1) mod hash_num; 
			end if; 
		end if;
	end process hash_in_fifo;
--	

	hash_gen : for i in 0 to hash_num -1 generate
	
	process (clk, reset_n) is
		variable state : state_t; 
		variable config : std_logic_vector(DATA_WIDTH -1 downto 0); 
		variable hash : std_logic_vector(HASH_WIDTH -1 downto 0); 
		variable hash_en_i : std_logic; 
		
	begin
			state := states_ar(i);
			hash_en_i := hash_en(i); 
			
			 
			if reset_n = '0' then
				data_in_s(i) <= (others => '0'); 
				hash_en(i) <= '0';
				config_hash_array(i) <= (hash => (others => '0'), config => (others => '0'), hash_rdy => '0', config_rdy => '0', data_read => '1'); 
				hash_is_done(i) <= '1'; 
				state := s0; 
				
			elsif rising_edge(clk) then
--				case state is 
--					when s0 => 		-- idle
--						if hash_en_i = '1' then  
--						
--						
--						end if; 
--					when s1 =>
--						null;
--					when s2 =>
--						null;
--					when s3 =>
--						null;
--				end case;
				
				
				if config_hash_array(i).config_rdy = '1' and config_hash_array(i).hash_rdy = '1' then --and config_hash_array(i).data_read = '1' then 
					config_hash_array(i).config_rdy <= '0'; 
					config_hash_array(i).hash_rdy <= '0'; 
					hash_is_done(i) <= '1'; 
					hash_en(i) <= '0'; 
				elsif hash_en_i = '0' and hash_inputs(i).start = '1' then 
					hash_is_done(i) <= '0'; 
					config_hash_array(i).config <= hash_inputs(i).config; 
					config_hash_array(i).config_rdy <= '1'; 
					hash_en(i) <= '1'; 
					config_hash_array(i).data_read <= '0'; 
				elsif hash_en(i) = '1' and hash_done(i) = '1' then 
					config_hash_array(i).hash <= hash_key(i); 
					config_hash_array(i).hash_rdy <= '1'; 
					hash_en(i) <= '0'; 

				else 
					hash_en(i) <= hash_en(i); 
				end if; 
			end if;
			states_ar(i) <= state; 
		end process ;
		
		
		
		hash_inst : entity murmur3(behav)
			port map(
			ap_clk => clk,						-- : IN STD_LOGIC;
			ap_rst_n => reset_n, 						-- : IN STD_LOGIC;
			ap_start =>	hash_en(i), 					-- : IN STD_LOGIC;
			ap_done => hash_done(i), 						-- : OUT STD_LOGIC;
			ap_idle => 	open, 					-- : OUT STD_LOGIC;
			ap_ready => open, 				-- : OUT STD_LOGIC;
			key => 	config_hash_array(i).config(31 downto 0), 				-- : IN STD_LOGIC_VECTOR (31 downto 0);
			key_ap_vld => config_hash_array(i).config_rdy,  					-- : IN STD_LOGIC;
			seed => seed, 		-- : IN STD_LOGIC_VECTOR (31 downto 0);
			seed_ap_vld => '1', 					-- : IN STD_LOGIC;
			ap_return => hash_key(i)			-- : OUT STD_LOGIC_VECTOR (31 downto 0) );
		); 
		
	end generate hash_gen;


end architecture;

