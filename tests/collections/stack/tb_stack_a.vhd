library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mc_components.all;
use work.open_components.all;

entity tb_stack_a is
end entity tb_stack_a;

architecture RTL of tb_stack_a is
	constant DATA_WIDTH    : integer := 32;
	constant ADDRESS_WIDTH : integer := 5;

	signal clk          : std_logic := '0';
	signal reset        : std_logic;
	signal reset_n      : std_logic;
	signal is_pingpong  : std_logic;
	signal pop_enable   : std_logic;
	signal push_enable  : std_logic;
	signal data_in      : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal mark_last    : std_logic;
	signal data_out     : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal data_ready   : std_logic;
	signal is_empty     : std_logic;
	signal is_full      : std_logic;
	signal is_last      : std_logic;
	signal pop_is_done  : std_logic;
	signal push_is_done : std_logic;
	signal is_swapped   : std_logic;
	signal beuhh : std_logic;

	--	for stack_inst : open_stream use configuration work.tb_stack_a_config;

begin

	process(clk) is
	begin
		clk <= not clk after 10 ns;
	end process;

	process is
	begin
		reset_n <= '0';
		reset   <= '1';
		wait for 100 ns;
		reset   <= '0';
		reset_n <= '1';
		wait;
	end process;

	is_pingpong <= '0';

	process is
	begin
		data_in     <= (others => '0');
		push_enable <= '0';
		pop_enable  <= '0';
		wait for 150 ns;
		wait until falling_edge(clk);
		data_in     <= std_logic_vector(to_unsigned(42, 32));
		push_enable <= '1';
		wait until falling_edge(clk);
		push_enable <= '0';
		data_in     <= (others => '0');

		wait for 50 ns;
		wait until falling_edge(clk);
		pop_enable <= '1';
		wait until falling_edge(clk);
		pop_enable <= '0';
		wait for 100 ns; 
		wait;
	end process;

	stack_inst : entity work.pingpong_fifo(stack_a)
		generic map(
			ADDRESS_WIDTH => ADDRESS_WIDTH,
			DATA_WIDTH    => DATA_WIDTH
		)
		port map(
			clk          => clk,
			reset        => reset,
			reset_n      => reset_n,
			is_pingpong  => is_pingpong,
			pop_enable   => pop_enable,
			push_enable  => push_enable,
			data_in      => data_in,
			mark_last    => mark_last,
			data_out     => data_out,
			data_ready   => data_ready,
			is_empty     => is_empty,
			is_full      => is_full,
			is_last      => is_last,
			pop_is_done  => pop_is_done,
			push_is_done => push_is_done,
			is_swapped   => is_swapped
		);

	process(clk, data_ready)
	begin
		
		beuhh <= data_ready; 
	end process;

end architecture RTL;
