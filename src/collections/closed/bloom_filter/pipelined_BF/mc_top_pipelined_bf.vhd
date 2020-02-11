library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library model;
--use model.all;

library work;
use work.all;

entity pipelined_pbf_fifo_bram_tb is
end entity pipelined_pbf_fifo_bram_tb;

architecture RTL of pipelined_pbf_fifo_bram_tb is
	signal clk                    : std_logic                     := '0';
	signal reset                  : std_logic                     := '0';
	signal reset_n                : std_logic                     := '0';
	signal start                  : std_logic                     := '0';
	signal is_bounded             : std_logic                     := '0';
	signal sim_end                : std_logic                     := '0';
	signal end_code               : std_logic_vector(7 downto 0)  := (others => '0');
	signal i_en_next              : std_logic                     := '0';
	signal n_en_next              : std_logic                     := '0';
	signal source_next            : std_logic_vector(31 downto 0) := (others => '0');
	signal target_out_next        : std_logic_vector(31 downto 0) := (others => '0');
	signal t_ready_next           : std_logic                     := '0';
	signal has_next_next          : std_logic                     := '0';
	signal t_done_next            : std_logic                     := '0';
	constant DATA_WIDTH           : integer                       := 32;
	constant OPEN_ADDRESS_WIDTH   : integer                       := 5;
	constant CLOSED_ADDRESS_WIDTH : integer                       := 5;

begin

	clk_p : process(clk) is
	begin
		clk <= not clk after 10 ns;
	end process clk_p;

	reset_p : process is
	begin
		reset_n <= '0';
		wait for 100 ns;
		reset_n <= '1';
		wait;
	end process reset_p;

	main_p : process is
	begin
		wait for 200 ns;
		wait until falling_edge(clk);
		start <= '1';
		wait until falling_edge(clk);
		start <= '0';

		wait until sim_end = '1';
		wait;
	end process main_p;

	a : entity work.mc_top_wrapper(Behavioral_mc_top_bf_fifo_bram_config)
		generic map(
			DATA_WIDTH           => DATA_WIDTH,
			OPEN_ADDRESS_WIDTH   => OPEN_ADDRESS_WIDTH,
			CLOSED_ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH
		)
		port map(
			clk             => clk,
			reset           => reset,
			reset_n         => reset_n,
			start           => start,
			is_bounded      => is_bounded,
			sim_end         => sim_end,
			end_code        => end_code,
			i_en_next       => i_en_next,
			n_en_next       => n_en_next,
			source_next     => source_next,
			target_out_next => target_out_next,
			t_ready_next    => t_ready_next,
			has_next_next   => has_next_next,
			t_done_next     => t_done_next
		);

	m : entity work.semantics(semantics_wrapper)
		generic map(
			CONFIG_WIDTH => DATA_WIDTH
		)
		port map(
			clk            => clk,
			reset          => reset,
			reset_n        => reset_n,
			initial_enable => i_en_next,
			next_enable    => n_en_next,
			source_in      => source_next,
			target_out     => target_out_next,
			target_ready   => t_ready_next,
			has_next       => has_next_next,
			is_done        => t_done_next
		);

end architecture RTL;
