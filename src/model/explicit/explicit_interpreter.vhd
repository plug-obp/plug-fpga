library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.model_pkg.ALL;
entity explicit_interpreter is
    generic (
		CONFIG_WIDTH : integer := AB_PARAMS.configuration_width;
		HAS_OUTPUT_REGISTER : boolean := true;
        p : T_MODEL_PARAMS := AB_PARAMS;
        model : T_EXPLICIT := AB_MODEL
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;
        initial_enable  : in std_logic;                                 -- when initial is asserted, data_out contains a new configuration each clock cycle while has_next is set

        next_enable     : in std_logic;
        source_in       : in std_logic_vector(p.configuration_width-1 downto 0);

        target_out      : out std_logic_vector(p.configuration_width-1 downto 0); -- the output configuration data
        target_ready    : out std_logic;                                -- next out can be read
        has_next        : out std_logic;                                -- no more configuration available
        is_done         : out std_logic
    );
begin
	assert CONFIG_WIDTH = p.configuration_width report "configuration width not equal to model configuration width" severity error;
end entity;



