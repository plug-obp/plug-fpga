----------------------------------------------------------------------------------
-- Company: ENSTA Bretagne
-- Engineer: Fournier Emilien
-- 
-- Create Date: 06/21/2019 12:04:57 PM
-- Design Name: 
-- Module Name: mc_top_wrapper - Behavioral
-- Project Name: 
-- Target Devices: Zynq 7000
-- Tool Versions: 2018.3
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mc_top_wrapper is
--  Port ( );
	generic (
			DATA_WIDTH				: integer := 32;
			OPEN_ADDRESS_WIDTH		: integer := 6; 	
			CLOSED_ADDRESS_WIDTH	: integer := 4  		
		);
	port (
        clk             : in  std_logic;                                 -- clock
        reset           : in  std_logic;
        reset_n         : in  std_logic;
        start           : in  std_logic;
        is_bounded      : in  std_logic; 
        sim_end         : out std_logic; 
        end_code        : out std_logic_vector(7 downto 0); 



        i_en_next        : out std_logic; 
        n_en_next        : out std_logic; 
        source_next      : out std_logic_vector(31 downto 0); 
        target_out_next  : in std_logic_vector(31 downto 0); 
        t_ready_next     : in std_logic; 
        has_next_next    : in std_logic; 
        t_done_next      : in std_logic
    );
end mc_top_wrapper;

architecture Behavioral of mc_top_wrapper is
--	constant DATA_WIDTH : integer := 32; --CONFIG_WIDTH; 
--	constant OPEN_ADDRESS_WIDTH : integer := 6; 
--	constant CLOSED_ADDRESS_WIDTH : integer := 4; 

	component mc_top_comp is 
	    generic (
	        DATA_WIDTH              : integer := 32;
	        OPEN_ADDRESS_WIDTH      : integer := 6;
	        CLOSED_ADDRESS_WIDTH    : integer := 4
	    );
	    port (
	        clk             : in  std_logic;                                 -- clock
	        reset           : in  std_logic;
	        reset_n         : in  std_logic;
	        start           : in  std_logic;
	        is_bounded      : in  std_logic; 
	        sim_end         : out std_logic; 
        	end_code        : out std_logic_vector(7 downto 0); 



	        i_en_next        : out std_logic; 
	        n_en_next        : out std_logic; 
	        source_next      : out std_logic_vector(DATA_WIDTH-1 downto 0); 
	        target_out_next  : in std_logic_vector(DATA_WIDTH-1 downto 0); 
	        t_ready_next     : in std_logic; 
	        has_next_next    : in std_logic; 
	        t_done_next      : in std_logic
	    );
	end component;


	for mc_top_arch : mc_top_comp use configuration work.mc_top_exh_h_fifo_bram_config;

	signal is_started : std_logic; 
	--signal start_s : std_logic; 




begin

	--process (reset_n, clk)
	--begin
	--	if (reset_n = '1') then
	--    	is_started <= '0'; 
	--    	start_s <= '0'; 
	--	elsif (rising_edge(clk)) then
	--		if ( start = '1' and is_started = '0') then 
	--			start_s <= '1'; 
	--			is_started <= '1'; 
	--		else 
	--			start_s <= '0'; 
	--		end if; 
	-- 	end if;
	--end process; 



	mc_top_arch :  mc_top_comp
		generic map(
			DATA_WIDTH              => DATA_WIDTH,
			OPEN_ADDRESS_WIDTH      => OPEN_ADDRESS_WIDTH,
			CLOSED_ADDRESS_WIDTH    => CLOSED_ADDRESS_WIDTH
		)
		port map (
			clk              => clk,
			reset            => reset,
			reset_n          => reset_n,
			start            => start,
			is_bounded       => is_bounded,
			sim_end          => sim_end,
			end_code		 => end_code, 
			i_en_next        => i_en_next,
			n_en_next        => n_en_next,
			source_next      => source_next,
			target_out_next  => target_out_next,
			t_ready_next     => t_ready_next,
			has_next_next    => has_next_next,
			t_done_next      => t_done_next

		); 





end Behavioral;
