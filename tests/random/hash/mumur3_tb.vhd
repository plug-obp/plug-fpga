
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.all; 


entity murmur3_tb is 
begin
end entity;





architecture a of murmur3_tb is 
	signal clk      :  std_logic := '0';
	signal reset    :  std_logic := '0';
	signal data     :  std_logic_vector(31 downto 0) := (others => '0');
	signal hash_en  :  std_logic := '0'; 
	signal hash_key :  std_logic_vector(31 downto 0) := (others => '0');
	signal hash_ok  :  std_logic := '0'; 

begin
	clk <= not clk after 10 ns; 


	process 
	begin
		wait for 30 ns; 
		reset <= '1'; 
		wait for 50 ns; 
		data <= std_logic_vector(to_unsigned(10, 32)); 
		hash_en <= '1'; 
		wait for 10 ns; 
		data <= (others => '0');
		hash_en <= '0'; 
		wait ;

	end process; 


	hash_inst : entity hash(murmur3_wrapper)
	generic map (
	    DATA_WIDTH=> 32, 
    HASH_WIDTH => 32, 
    WORD_WIDTH =>32 
	)
	port map (
		clk		 => clk,
		reset	 => reset,
		data	 => data,
		hash_en	 => hash_en,
		hash_key => hash_key,
		hash_ok	 => hash_ok  
	); 



end architecture; 