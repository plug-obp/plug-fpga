

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipelined_BF_tb is
end entity pipelined_BF_tb;

architecture RTL of pipelined_BF_tb is

	constant HAS_OUTPUT_REGISTER : boolean := false;
	constant ADDRESS_WIDTH       : integer := 8;
	constant DATA_WIDTH          : integer := 32;
	constant max_i               : integer := 1;

	signal reset_n     : std_logic;
	signal clk         : std_logic                                 := '0';
	signal reset       : std_logic                                 := '0';
	signal add_enable  : std_logic                                 := '0';
	signal data_in     : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
	signal clear_table : std_logic                                 := '0';
	signal is_in       : std_logic;
	signal is_full     : std_logic;
	signal is_done     : std_logic                                 := '0';
	type int_ar is array (max_i downto 0) of integer;
	signal sample1     : int_ar                                    := (1, 0);
	signal sample2     : int_ar                                    := (1, 42);

begin

	set_i : entity work.set(pipelined_hash_e)
		generic map(
			HAS_OUTPUT_REGISTER => HAS_OUTPUT_REGISTER,
			ADDRESS_WIDTH       => ADDRESS_WIDTH,
			DATA_WIDTH          => DATA_WIDTH
		)
		port map(
			reset_n     => reset_n,
			clk         => clk,
			reset       => reset,
			add_enable  => add_enable,
			data_in     => data_in,
			clear_table => clear_table,
			is_in       => is_in,
			is_full     => is_full,
			is_done     => is_done
		);

	test_p : process is
		variable data : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
	begin
		wait until reset_n = '1';
		wait for 50 ns;
		wait until falling_edge(clk);

		for i in 0 to max_i loop
			data := std_logic_vector(to_unsigned(sample1(i), DATA_WIDTH));

			add_enable <= '1';
			data_in    <= data;
			wait until falling_edge(clk);

			--			wait until falling_edge(clk); 
			--			add_enable <= '0'; 
			--			data_in <= (others => '0');  	
		end loop;

		add_enable <= '0';
		wait until is_done = '1';
		wait until falling_edge(clk);

		for i in 0 to max_i loop
			data       := std_logic_vector(to_unsigned(sample2(i), DATA_WIDTH));
			--			wait until falling_edge(clk);
			wait until falling_edge(clk);
			add_enable <= '1';
			data_in    <= data;
			wait until falling_edge(clk);
			add_enable <= '0';
			data_in    <= (others => '0');
		end loop;

		add_enable <= '0';

		wait;

	end process;

	reset_p : process is
	begin
		reset_n <= '0';
		wait for 100 ns;
		reset_n <= '1';
		wait;
	end process;

	clk <= not clk after 5 ns;

end architecture RTL;
