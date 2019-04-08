library ieee;
use ieee.std_logic_1164.all;



package term_components_pkg is


	component bound_check is
		generic( 
			HAS_OUTPUT_REGISTER : boolean := false
		);
		port (
			clk : in std_logic;
			reset : in std_logic; 
			reset_n : in std_logic; 
			enabled : in std_logic; 
			bound  	: in std_logic_vector(7 downto 0); 
			trig 	: in std_logic; 
			bound_is_reached : out std_logic
		);
	end component; 


	component normal_term_comp is 
		generic (
				HAS_OUTPUT_REGISTER : boolean := false
			);
		port (
				clk : in std_logic;
				reset, reset_n : in std_logic; 
				open_empty : in std_logic; 
				timeout : in std_logic_vector(15 downto 0); 
				normal_term : out std_logic
			);
	end component; 


	component terminaison_fsm_comp is 
		generic (
			HAS_OUTPUT_REGISTER : boolean
		);
		port (
			clk : in std_logic;
			reset : in std_logic; 
			reset_n : in std_logic; 

			bound_reached_term : in std_logic; 
			closed_full_term : in std_logic; 
			open_full_term : in std_logic; 
			normal_term : in std_logic; 

		    sim_end : out std_logic; 
		    err_code : out std_logic_vector(7 downto 0)
		);
	end component; 

end package; 

