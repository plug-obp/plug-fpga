library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.term_components_pkg.all; 


entity terminaison_checker is
	generic (
	HAS_OUTPUT_REGISTER : boolean := false
);
	port (
		clk : in std_logic; 
		reset : in std_logic; 
		reset_n : in std_logic; 
		t_is_last : in std_logic; 
		open_is_empty : in std_logic; 
		open_is_full : in std_logic; 
        closed_is_full : in std_logic; 
        sim_end : out std_logic
	);
end terminaison_checker;


architecture a of terminaison_checker is
	signal bound_is_reached : std_logic; 
    signal normal_term : std_logic; 
begin

	bound_chker_inst : bound_check
	generic map ( HAS_OUTPUT_REGISTER => false)
        port map (
            clk => clk, 
            reset       => reset,
            reset_n     => reset_n,
            enabled => '1', 
            bound => "00010000", 
            trig => t_is_last, 
            bound_is_reached => bound_is_reached
    ); 

    normal_term_chker_inst : normal_term_comp 
        generic map (HAS_OUTPUT_REGISTER => false)
        port map (
            clk => clk, 
            reset_n => reset_n, 
            reset => reset,
            open_empty => open_is_empty, 
            timeout => "0000000000011001", 
            normal_term => normal_term
        ); 

    term_inst : terminaison_fsm_comp
    generic map ( 
        HAS_OUTPUT_REGISTER => false
    )
    port map (
    	clk => clk, 
    	reset => reset, 
    	reset_n => reset_n, 
        bound_reached_term => bound_is_reached,
        closed_full_term => closed_is_full,
        open_full_term => open_is_full, 
        normal_term => normal_term,
        sim_end => sim_end,
        err_code => open
    ); 


end a;