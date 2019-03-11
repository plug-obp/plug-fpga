library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_b_testbench is end entity;

architecture test1 of fifo_b_testbench is
    constant CLK_PERIOD : time := 100 ns;
    constant ADDRESS_WIDTH : integer := 2;
    constant DATA_WIDTH : integer := 4;
    signal clk, rst : std_logic;
    signal push_enable, pop_enable : std_logic;
    signal is_empty, is_full : std_logic;
    signal push_error, pop_error : std_logic;
    signal data_in : (DATA_WIDTH - 1 downto 0);
    signal data_out : (DATA_WIDTH - 1 downto 0);

    signal simulation_end : std_logic := '0';
begin

    clk <= not clk after CLK_PERIOD/2 when not simulation_end else '0';

dut : entity work.fifo(fifo_b)    
    generic map (ADDRESS_WIDTH => ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
	port map ( 
		clk => clk,
		reset => rst,
		pop_enable => do_pop,
		push_enable	=> do_push,
		data_in => data_in,
		data_out => data_out,
		is_empty => is_empty,
		is_full	=> is_full,
		push_error => push_error,
		pop_error => pop_error
	);


end architecture;