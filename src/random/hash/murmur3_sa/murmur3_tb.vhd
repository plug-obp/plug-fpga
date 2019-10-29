library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all; 


entity tb is 
begin 
end entity; 

architecture a of tb is 

	signal config : STD_LOGIC_VECTOR(127 downto 0) := std_logic_vector(to_unsigned(3216516, 128)); 

    signal clk 				: STD_LOGIC := '0';
    signal reset 		: STD_LOGIC;
    signal ap_start_s		: STD_LOGIC;
    signal ap_done_s		: STD_LOGIC;
    signal key_dout_s		: STD_LOGIC_VECTOR (31 downto 0);
    signal key_empty_n_s	: STD_LOGIC;
    signal key_read_s		: STD_LOGIC;
    signal len_s			: STD_LOGIC_VECTOR (63 downto 0);
    signal seed_s			: STD_LOGIC_VECTOR (31 downto 0);
    signal ap_return_s		: STD_LOGIC_VECTOR (31 downto 0);

begin 

	clk <= not clk after 10 ns; 

	process 
	begin 
		reset <= '0'; 
		wait for 100 ns; 
		reset <= '1'; 

		wait; 
	end process; 

	process
	begin
		ap_start_s <= '0'; 
		
		seed_s <= (others => '0');
		len_s <= std_logic_vector(to_unsigned(8,64)); 
		key_dout_s <= config(31 downto 0); 
		key_empty_n_s <= '0'; 
		wait for 500 ns; 
		wait until falling_edge(clk); 
		ap_start_s <= '1'; 
		
		wait until falling_edge(clk); 
		

		wait; 

	end process; 


 	hash : entity murmur3_32(behav)
 	port map(
 		ap_clk			=> clk,
		ap_rst			=> reset,
		ap_start		=> ap_start_s,
		ap_done			=> ap_done_s,
		ap_idle			=> open,
		ap_ready		=> open,
		key_dout		=> key_dout_s,
		key_empty_n		=> key_empty_n_s,
		key_read		=> key_read_s,
		len				=> len_s,
		seed			=> seed_s,
		ap_return		=> ap_return_s
	);


end architecture; 


