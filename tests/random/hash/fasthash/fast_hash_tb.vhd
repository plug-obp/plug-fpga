library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all; 









entity tb is 
begin 
end entity; 

architecture a of tb is 

	signal config : STD_LOGIC_VECTOR(127 downto 0) := std_logic_vector(to_unsigned(3216516, 128)); 

    signal clk : STD_LOGIC := '0';
    signal ap_rst_s : STD_LOGIC;
    signal ap_start_s : STD_LOGIC;
    signal ap_done_s : STD_LOGIC;
    signal ap_idle_s : STD_LOGIC;
    signal ap_ready_s : STD_LOGIC;
    signal inData_s : STD_LOGIC_VECTOR (63 downto 0);
    signal len_s : STD_LOGIC_VECTOR (63 downto 0);
    signal step_s : STD_LOGIC_VECTOR (1 downto 0);
    signal seed_s : STD_LOGIC_VECTOR (63 downto 0);
    signal ap_return_s : STD_LOGIC_VECTOR (63 downto 0);

begin 

	clk <= not clk after 10 ns; 

	process 
	begin 
		ap_rst_s <= '0'; 
		wait for 100 ns; 
		ap_rst_s <= '1'; 
		wait; 
	end process; 

	process
	begin
		ap_start_s <= '0'; 
		inData_s <= (others => '0');
		seed_s <= (others => '0');
		step_s <= (others => '0'); 
		len_s <= std_logic_vector(to_unsigned(16,64)); 
		wait for 500 ns; 
		wait until falling_edge(clk); 
		ap_start_s <= '1'; 
		inData_s <= config(63 downto 0); 
		step_s <= std_logic_vector(to_unsigned(2, 2)); 
		wait until falling_edge(clk); 
		inData_s <= config(127 downto 64); 
		step_s <= std_logic_vector(to_unsigned(3, 2)); 

		wait; 

	end process; 









 	hash : entity fasthash64(behav)
 	port map(
		ap_clk		=> clk,
		ap_rst		=> ap_rst_s,
		ap_start	=> ap_start_s,
		ap_done		=> ap_done_s,
		ap_idle		=> ap_idle_s,
		ap_ready	=> ap_ready_s,
		inData		=> inData_s,
		len			=> len_s,
		step		=> step_s,
		seed		=> seed_s,
		ap_return	=> ap_return_s
 	); 


end architecture; 


