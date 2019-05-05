library ieee;
use ieee.std_logic_1164.all;


entity cycle_counter is
	port (
		clk 	: in  std_logic;
		reset 	: in  std_logic; 
		reset_n : in  std_logic; 
		count 	: out std_logic_vector(63 downto 0)
	);
end cycle_counter;


library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std_unsigned.all; 

architecture a of cycle_counter is
	signal count_reg : std_logic_vector(63 downto 0); 
begin
	reg : process (reset, clk)
	begin
	  	if (reset_n = '0') then
	    count_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			if reset = '1' then 
				count_reg <= (others => '0');
			else
				count_reg <= count_reg + 1; 
			end if; 
	  end if;
	end process;

	count <= count_reg; 
end a;
