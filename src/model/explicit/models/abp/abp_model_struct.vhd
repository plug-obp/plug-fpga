library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.explicit_params.ALL;
package model_structure is
    constant CONFIG_WIDTH : integer := 168;
    constant AB_PARAMS : T_MODEL_PARAMS := (10, 16, 1, CONFIG_WIDTH);

    subtype T_CONFIGURATION is std_logic_vector(CONFIG_WIDTH-1 downto 0);
    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector;
    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION;
end package;

package body model_structure is
    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector is
    begin
    	return std_logic_vector(c);
    end function;

    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION is
    begin
        return T_CONFIGURATION(lv);
    end function;
end package body;
