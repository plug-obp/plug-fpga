library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use WORK.mc_components.ALL;

architecture bloom_filter_a of set is   -- @suppress "Unused port: clear_table is not used in work.set(bloom_filter_a)"
	constant HASH_LENGTH : natural := 16;

	signal w_en  : std_logic;
	signal w_key : std_logic_vector(HASH_LENGTH - 1 downto 0);

	signal w_ok_s : std_logic;

	-- non assigned signals 

	signal is_done_s : std_logic;

begin                                   -- architecture bloom_filter

	hash_add : hash
		generic map(
			DATA_WIDTH => DATA_WIDTH,
			HASH_WIDTH => HASH_LENGTH,
			WORD_WIDTH => DATA_WIDTH)
		port map(
			clk      => clk,
			reset    => reset,
			reset_n  => reset_n,
			data     => data_in,
			hash_en  => add_enable,
			hash_key => w_key,
			hash_ok  => w_en);

	reg : entity work.bf_reg_file
		generic map(
			ADDR_WIDTH => ADDRESS_WIDTH)
		port map(
			clk     => clk,
			reset   => reset,
			reset_n => reset_n,
			w_en    => w_en,
			w_addr  => w_key(ADDRESS_WIDTH - 1 downto 0),
			w_ok    => w_ok_s,
			w_done  => is_done_s,
			r_addr  => (others => '0'),
			r_en    => '0',
			r_ret   => open);

	is_in   <= '1' when w_ok_s = '0' and is_done_s = '1' else '0';
	is_done <= is_done_s;
	is_full <= '0';

end architecture;
