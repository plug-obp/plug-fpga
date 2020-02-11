

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bloom_filter_components.all;
use work.murmur3;
--use work.bf_reg_file; 
use work.bloom_filter_controler;

architecture pipelined_hash_e of set is
	constant hash_num   : integer := 12;
	constant HASH_WIDTH : integer := 32;
	type t_config_array is array (hash_num - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);

	type hash_array_t is array (hash_num - 1 downto 0) of std_logic_vector(HASH_WIDTH - 1 downto 0);

	signal hash_s    : hash_array_t;
	signal hash_ok_s : std_logic_vector(hash_num - 1 downto 0);

	signal hash_key : hash_array_t;

	type t_config_hash is record
		data_read  : std_logic;
		config_rdy : std_logic;
		hash_rdy   : std_logic;
		config     : std_logic_vector(DATA_WIDTH - 1 downto 0);
		hash       : std_logic_vector(HASH_WIDTH - 1 downto 0);
	end record t_config_hash;

	type t_config_hash_array is array (hash_num - 1 downto 0) of t_config_hash;

	signal write_index_in_fifo : integer := 0;

	type t_input is record
		start  : std_logic;
		config : std_logic_vector(DATA_WIDTH - 1 downto 0);
	end record;
	type t_inputs is array (hash_num - 1 downto 0) of t_input;

	signal seed : std_logic_vector(31 downto 0);

	type ctrl_state_t is (s_idle, rcvd_config, processing, sending_resp);
	type state_t is record
		ctrl_state : ctrl_state_t;
		config     : std_logic_vector(DATA_WIDTH - 1 downto 0);
		hash       : std_logic_vector(HASH_WIDTH - 1 downto 0);
	end record;

	constant DEFAULT_STATE : state_t := (ctrl_state => s_idle, config => (others => '0'), hash => (others => '0'));

	type state_t_array is array (hash_num - 1 downto 0) of state_t;

	signal state_c_ar : state_t_array;
	signal state_r_ar : state_t_array;

	type output_t is record
		h_start      : std_logic;
		h_config     : std_logic_vector(DATA_WIDTH - 1 downto 0);
		h_config_vld : std_logic;

	end record;
	constant DEFAULT_OUTPUT : output_t := (h_start => '0', h_config => (others => '0'), h_config_vld => '0');
	type output_t_array is array (hash_num - 1 downto 0) of output_t;

	signal output_c_ar : output_t_array;

	type input_t is record
		hash_en : std_logic;
		data    : std_logic_vector(DATA_WIDTH - 1 downto 0);
		--		h_done : std_logic; 
		--		hash : std_logic_vector(HASH_WIDTH-1 downto 0); 
	end record;

	constant DEFAULT_INPUTS : input_t := (hash_en => '0', data => (others => '0'));
	signal h_done           : std_logic_vector(hash_num - 1 downto 0);

	type hash_ar_t is array (hash_num - 1 downto 0) of std_logic_vector(31 downto 0);
	signal h_hash : hash_ar_t;

	type input_t_array is array (hash_num - 1 downto 0) of input_t;
	signal inputs_c : input_t_array;

	signal rf_p_r      : std_logic;
	signal rf_p_w      : std_logic;
	signal rf_p_clear  : std_logic := '0';
	signal rf_p_w_data : std_logic_vector(0 downto 0);
	signal rf_p_r_data : std_logic_vector(0 downto 0);
	signal rf_p_w_addr : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	signal rf_p_r_addr : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	signal rf_p_r_ok   : std_logic;

	type config_array_t is array (hash_num - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);

	signal add_en_out_ar : std_logic_vector(hash_num - 1 downto 0);
	signal config_out_ar : config_array_t;
	signal hash_out_ar   : hash_array_t;

	signal add_en_ctrl : std_logic;
	signal config_ctrl : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal hash_ctrl   : std_logic_vector(HASH_WIDTH - 1 downto 0);

	signal add_en_ctrl_tmp : std_logic_vector(hash_num - 1 downto 0);
	signal config_ctrl_tmp : config_array_t;
	signal hash_ctrl_tmp   : hash_array_t;

	signal data_h_inputs    : config_array_t;
	signal hash_en_h_inputs : std_logic_vector(hash_num - 1 downto 0);

	type glob_ctrl_t is (s_idle, s1);
	signal glob_ctrl : glob_ctrl_t;

	signal idle_tmp : std_logic_vector(hash_num - 1 downto 0);

begin
	seed <= std_logic_vector(to_unsigned(42, 32));

	hash_in_fifo : process(clk, reset_n, write_index_in_fifo) is
	begin
		if reset_n = '0' then
			glob_ctrl                             <= s_idle;
			write_index_in_fifo                   <= 0;
			inputs_c(write_index_in_fifo).data    <= (others => '0');
			inputs_c(write_index_in_fifo).hash_en <= '0';
			data_h_inputs                         <= (others => (others => '0'));
			hash_en_h_inputs                      <= (others => '0');
		elsif rising_edge(clk) then

			case glob_ctrl is
				when s_idle =>
					if add_enable = '1' then
						if not (state_r_ar(write_index_in_fifo).ctrl_state = s_idle) then
							report "failure, overflow" severity failure;
						end if;

						--inputs_c(write_index_in_fifo).data <= data_in; 
						--inputs_c(write_index_in_fifo).hash_en <= '1'; 
						data_h_inputs(write_index_in_fifo)    <= data_in;
						hash_en_h_inputs(write_index_in_fifo) <= '1';

						write_index_in_fifo <= (write_index_in_fifo + 1) mod hash_num;
						glob_ctrl           <= s1;
					end if;
				when s1 =>
					if add_enable = '1' then
						if not (state_r_ar(write_index_in_fifo).ctrl_state = s_idle) then
							report "failure, overflow" severity failure;
						end if;

						--inputs_c(write_index_in_fifo).data <= data_in; 
						--inputs_c(write_index_in_fifo).hash_en <= '1'; 
						data_h_inputs(write_index_in_fifo)    <= data_in;
						hash_en_h_inputs(write_index_in_fifo) <= '1';

						write_index_in_fifo <= (write_index_in_fifo + 1) mod hash_num;
						glob_ctrl           <= s1;
					else
						glob_ctrl <= s_idle;
					end if;

					hash_en_h_inputs((write_index_in_fifo - 1 + hash_num) mod hash_num) <= '0';

			end case;
		end if;
	end process hash_in_fifo;
	--	

	hash_gen : for k in 0 to hash_num - 1 generate

		state_update : process(clk, reset_n) is
		begin
			if reset_n = '0' then
				state_r_ar(k) <= DEFAULT_STATE;
			elsif rising_edge(clk) then
				state_r_ar(k) <= state_c_ar(k);
			end if;
		end process;

		next_update : process(h_done(k), state_r_ar(k), inputs_c(k), data_h_inputs(k), hash_en_h_inputs(k), h_hash) is
			variable o : output_t := DEFAULT_OUTPUT;
			variable c : state_t  := DEFAULT_STATE;
			--variable i : input_t := DEFAULT_INPUTS; 
		begin
			c := state_r_ar(k);
			o := DEFAULT_OUTPUT;
			--i := inputs_c(k); 
			--i := (hash_en => hash_en_h_inputs(k), data => data_h_inputs(k)); 

			case (c.ctrl_state) is
				when s_idle =>
					if hash_en_h_inputs(k) = '1' then
						c.config     := data_h_inputs(k);
						c.ctrl_state := rcvd_config;
					end if;
					add_en_out_ar(k) <= '0';
					config_out_ar(k) <= (others => '0');
					hash_out_ar(k)   <= (others => '0');

				when rcvd_config =>
					c.ctrl_state     := processing;
					o.h_config       := c.config;
					o.h_config_vld   := '1';
					o.h_start        := '1';
					add_en_out_ar(k) <= '0';
					config_out_ar(k) <= (others => '0');
					hash_out_ar(k)   <= (others => '0');

				when processing =>
					if h_done(k) = '1' then
						--	      		report "blabla" severity failure;

						c.hash       := h_hash(k);
						o.h_start    := '0';
						c.ctrl_state := sending_resp;
					else
						o.h_config     := c.config;
						o.h_config_vld := '1';
						o.h_start      := '1';
					end if;

					add_en_out_ar(k) <= '0';
					config_out_ar(k) <= (others => '0');
					hash_out_ar(k)   <= (others => '0');

				when sending_resp =>

					add_en_out_ar(k) <= '1';
					config_out_ar(k) <= c.config;
					hash_out_ar(k)   <= c.hash;
					c.ctrl_state     := s_idle;
			end case;

			--set the state_c
			state_c_ar(k)  <= c;
			--set the outputs
			output_c_ar(k) <= o;

		end process;

		hash_inst : entity murmur3(behav)
			port map(
				ap_clk      => clk,     -- : IN STD_LOGIC;
				ap_rst_n    => reset_n, -- : IN STD_LOGIC;
				ap_start    => output_c_ar(k).h_start, -- : IN STD_LOGIC;
				ap_done     => h_done(k), -- : OUT STD_LOGIC;
				ap_idle     => open,    -- : OUT STD_LOGIC;
				ap_ready    => open,    -- : OUT STD_LOGIC;
				seed_ap_vld => '1',     -- : IN STD_LOGIC;
				key_ap_vld  => output_c_ar(k).h_config_vld, -- : IN STD_LOGIC;
				key         => output_c_ar(k).h_config(31 downto 0), -- : IN STD_LOGIC_VECTOR (31 downto 0);
				seed        => seed,    -- : IN STD_LOGIC_VECTOR (31 downto 0);
				ap_return   => h_hash(k) -- : OUT STD_LOGIC_VECTOR (31 downto 0) );
			);

	end generate hash_gen;

	add_en_ctrl_tmp(0) <= add_en_out_ar(0);
	config_ctrl_tmp(0) <= config_out_ar(0);
	hash_ctrl_tmp(0)   <= hash_out_ar(0);
	idle_tmp(0)        <= '1' when state_r_ar(0).ctrl_state = s_idle else '0';

	gen : for i in 1 to hash_num - 1 generate
		add_en_ctrl_tmp(i) <= add_en_ctrl_tmp(i - 1) or add_en_out_ar(i);
		config_ctrl_tmp(i) <= config_ctrl_tmp(i - 1) or config_out_ar(i);
		hash_ctrl_tmp(i)   <= hash_ctrl_tmp(i - 1) or hash_out_ar(i);
		idle_tmp(i)        <= '1' when state_r_ar(i).ctrl_state = s_idle and idle_tmp(i - 1) = '1' else '0';
	end generate;

	add_en_ctrl <= add_en_ctrl_tmp(hash_num - 1);
	config_ctrl <= config_ctrl_tmp(hash_num - 1);
	hash_ctrl   <= hash_ctrl_tmp(hash_num - 1);
	idle        <= idle_tmp(hash_num - 1);

	controler : entity work.bloom_filter_controler(b)
		generic map(
			HAS_OUTPUT_REGISTER => false,
			HASH_WIDTH          => HASH_WIDTH,
			ADDR_WIDTH          => ADDRESS_WIDTH,
			DATA_WIDTH          => DATA_WIDTH
		)
		port map(
			clk         => clk,
			reset       => reset,
			reset_n     => reset_n,
			add_enable  => add_en_ctrl,
			data        => config_ctrl,
			clear_table => clear_table,
			isIn        => is_in,
			isFull      => is_full,
			isDone      => is_done,
			data_out    => data_out,
			hash_ok     => add_en_ctrl,
			hash        => hash_ctrl,
			rf_p_r      => rf_p_r,
			rf_p_w      => rf_p_w,
			rf_p_clear  => open,
			rf_p_w_data => rf_p_w_data,
			rf_p_r_data => rf_p_r_data,
			rf_p_w_addr => rf_p_w_addr,
			rf_p_r_addr => rf_p_r_addr,
			rf_p_r_ok   => rf_p_r_ok
		);

	reg_file_isFilled : entity work.reg_file_ssdpRAM
		generic map(
			MEM_TYPE   => "block",
			DATA_WIDTH => 1,
			ADDR_WIDTH => ADDRESS_WIDTH
		)
		port map(
			clk     => clk,
			reset_n => reset_n,
			clear   => rf_p_clear,
			we      => rf_p_w,
			addr_w  => rf_p_w_addr,
			d_in    => rf_p_w_data,
			re      => rf_p_r,
			addr_r  => rf_p_r_addr,
			d_out   => rf_p_r_data,
			r_ok    => rf_p_r_ok
		);

end architecture;

