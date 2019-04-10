library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  
use work.all; 



entity exhaustive_mc_tb is 
end entity; 


architecture exhaustive_mc_tb_arch of exhaustive_mc_tb is
	constant CLK_PERIOD : time := 10 ns; 
	constant DATA_WIDTH : integer := 6; 
	constant OPEN_ADDRESS_WIDTH : integer := 4; 
	constant CLOSED_ADDRESS_WIDTH : integer := 4; 
	signal clk : std_logic := '0';
	signal reset : std_logic := '0'; 
	signal reset_n : std_logic := '0'; 
	signal start : std_logic; 
	signal simulation_end : std_logic := '0'; 


begin


    clk <= not clk after CLK_PERIOD/2 when not simulation_end  = '1' else '0';


process 
begin 
	wait until rising_edge(clk); 
	wait for CLK_PERIOD / 4; 
	reset_n <= '0'; 
	wait for CLK_PERIOD / 2; 
	reset_n <= '1'; 
	wait; 
end process; 



process 
begin 	
	start <= '0'; 
	wait for CLK_PERIOD*4; 
	wait until rising_edge(clk); 
	start <= '1'; 
	wait until rising_edge(clk); 
	start <= '0'; 
	wait; 

end process; 


mc_top : configuration work.mc_top_v2_exhaustive(mc_top_v1_exhaustive)
	generic map (
		DATA_WIDTH => DATA_WIDTH, 
		OPEN_ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, 
		CLOSED_ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH
		)
	port map (
		clk => clk, 
		reset => reset, 
		reset_n => reset_n, 
		start => start, 
		sim_end => simulation_end
	); 





end exhaustive_mc_tb_arch;