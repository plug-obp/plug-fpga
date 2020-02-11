library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipelined_hash is
	generic (
		DATA_WIDTH : integer := 32; 
		HASH_WIDTH : integer := 16 
	);
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		data_in : in std_logic_vector(DATA_WIDTH-1 downto 0); 
		data_rdy : in std_logic;
		 
		data_out : out std_logic_vector(DATA_WIDTH-1 downto 0); 
		hash_out : out std_logic_vector(HASH_WIDTH-1 downto 0); 
		hash_rdy : out std_logic
	);
end entity pipelined_hash;

architecture a of pipelined_hash is
	
begin
	
	input_fifo : process (clk, reset_n) is
	begin
		if reset_n = '0' then
			   			
		elsif rising_edge(clk) then
			
		end if;
	end process input_fifo;
	

end architecture a;
