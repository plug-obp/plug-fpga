library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all; 
use work.all; 

entity tb is 
begin
end entity; 


architecture tb_arc of tb is

	signal reset_n : std_logic := '0';
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal add_enable : std_logic := '0';
	signal data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal clear_table : std_logic := '0';
	signal is_in : std_logic := '0';
	signal is_full : std_logic := '0';
	signal is_done : std_logic := '0';



	
begin


clk <= not clk after 10 ns; 

process 
begin
	reset_n <= '0'; 
	wait for 50 ns;
	reset_n <= '1'; 
	wait; 
end process; 

process 
begin
	wait for 200 ns;
	
	add_enable <= '1'; 
	data_in <= std_logic_vector(to_unsigned(12, data_in'LENGTH)); 
	wait for 10 ns;
	add_enable <= '0'; 
	
	wait until is_done = '1'; 
	wait for 50 ns;
	
	
	add_enable <= '1'; 
	data_in <= std_logic_vector(to_unsigned(11, data_in'LENGTH)); 
	wait for 10 ns;
	add_enable <= '0'; 
	
	wait until is_done = '1'; 
	wait for 50 ns;


	add_enable <= '1'; 
	data_in <= std_logic_vector(to_unsigned(10, data_in'LENGTH)); 
	wait for 10 ns;
	add_enable <= '0'; 
	
	wait until is_done = '1'; 
	wait for 50 ns;


	add_enable <= '1'; 
	data_in <= std_logic_vector(to_unsigned(12, data_in'LENGTH)); 
	wait for 10 ns;
	add_enable <= '0'; 
	
	wait until is_done = '1'; 
	wait for 50 ns;


	add_enable <= '1'; 
	data_in <= std_logic_vector(to_unsigned(14, data_in'LENGTH)); 
	wait for 10 ns;
	add_enable <= '0'; 
	
	wait until is_done = '1'; 
	wait for 50 ns;


	add_enable <= '1'; 
	data_in <= std_logic_vector(to_unsigned(11, data_in'LENGTH)); 
	wait for 10 ns;
	add_enable <= '0'; 
	
	wait until is_done = '1'; 
	wait for 50 ns;

	wait; 

end process; 


toto:entity work.set(linear_set_c) 
  generic map (
	HAS_OUTPUT_REGISTER => true,
    ADDRESS_WIDTH => 8, 
    DATA_WIDTH => 32
    )
  port map (
    reset_n =>   reset_n, 
    clk =>   clk, 
    reset =>   reset, 
    add_enable =>   add_enable, 
    data_in =>   data_in, 
    clear_table =>   clear_table, 
    is_in =>   is_in, 
    is_full =>   is_full, 
	is_done =>   is_done 
);



end tb_arc;
