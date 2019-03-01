-------------------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
-------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity fifo_tb is
end fifo_tb;

architecture behave of fifo_tb is

 constant c_DEPTH : integer := 4;
 constant c_WIDTH : integer := 8;
 
 signal r_RESET  : std_logic := '0';
 signal r_CLOCK  : std_logic := '0';
 signal r_WR_EN  : std_logic := '0';
 signal r_WR_DATA : std_logic_vector(c_WIDTH-1 downto 0) := X"A5";
 signal w_FULL  : std_logic;
 signal r_RD_EN  : std_logic := '0';
 signal w_RD_DATA : std_logic_vector(c_WIDTH-1 downto 0);
 signal w_EMPTY  : std_logic;
	signal w_ERROR : std_logic_vector(1 downto 0);

begin

fifo_0 : entity work.fifo
  generic map
	(
		ADDRESS_WIDTH => 4,
		DATA_WIDTH 	=>	8
	)
	port map
	( 
		clk 		=>	r_CLOCK,
		reset 		=>	r_RESET,
		pop_enable 	  => r_RD_EN,
		push_enable	   => r_WR_EN,
		data_in 	=> r_WR_DATA,
		data_out	=>	w_RD_DATA,
		is_empty 	=>	w_EMPTY,
		is_full		=>	w_FULL,
		is_error	=>	w_ERROR
	);

 r_CLOCK <= not r_CLOCK after 5 ns;

 p_TEST : process is
 begin
  wait until r_CLOCK = '1';
  r_RD_EN <= '1';
  wait until r_CLOCK = '1';
  r_WR_EN <= '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  r_WR_EN <= '0';
  r_RD_EN <= '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  r_RD_EN <= '0';
  r_WR_EN <= '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  r_RD_EN <= '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  r_WR_EN <= '0';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';
  wait until r_CLOCK = '1';

 end process;

 
end behave;