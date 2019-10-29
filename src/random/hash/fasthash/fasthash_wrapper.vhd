library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.all; 


architecture fasthash_wrapper of hash is
	type CTRL_STATE is (IDLE, PROCESSING, LAST, ERR); 
	signal state : CTRL_STATE; 
	signal ap_start : std_logic; 
	signal ap_done : std_logic; 

	signal key : std_logic_vector(DATA_WIDTH-1 downto 0); 
	signal key_ap_vld : std_logic; 
	signal seed : std_logic_vector(63 downto 0);  
begin

	hash_inst : entity fasthash64(behav)
	port map (
		ap_clk			=> clk, 
		ap_rst			=> reset, 
		ap_start		=> ap_start, 
		ap_done			=> ap_done, 
		ap_idle			=> open, 
		ap_ready		=> open, 
		inData			=> 
		len				=> 
		step			=> 
		seed			=> 
		ap_return		=> 
	); 

end fasthash_wrapper;
