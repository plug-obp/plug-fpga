library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.explicit_params.ALL;
package model_structure is
    -- BEGIN USER MODEL
    constant CONFIG_WIDTH : integer := 6; 
    type T_STATE is  (IDLE, WAITS, RETRY, CS);
    type T_CONFIGURATION is record
        alice : T_STATE;
        aliceFlag : boolean;
        bob : T_STATE;
        bobFlag : boolean;
    end record;

    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector;
    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION;

    constant AB_PARAMS : T_MODEL_PARAMS := (11, 17, 2, 6);
    -- END USER MODEL
end package;

package body model_structure is
    -- BEGIN ALICE BOB CONVERSION FUNCTIONS
    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector is
        variable result : std_logic_vector(5 downto 0);
    begin
        result(5 downto 4) := std_logic_vector(to_unsigned(T_STATE'POS(c.alice), 2));
        if c.aliceFlag then 
            result(3) := '1';
        else 
            result(3) := '0';
        end if;
        result(2 downto 1) := std_logic_vector(to_unsigned(T_STATE'POS(c.bob), 2));
        if c.bobFlag then 
            result(0) := '1';
        else 
            result(0) := '0';
        end if;
        return result;
    end function;

    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION is
        variable result : T_CONFIGURATION;
    begin
        result.alice := T_STATE'VAL(to_integer(unsigned(lv(5 downto 4))));
        if lv(3) = '1' then
            result.aliceFlag := true;
        else 
            result.aliceFlag := false; 
        end if;
        result.bob := T_STATE'VAL(to_integer(unsigned(lv(2 downto 1))));
        if lv(0) = '1' then
            result.bobFlag := true;
        else 
            result.bobFlag := false; 
        end if;
        return result;
    end function;
    -- END ALICE BOB CONVERSION FUNCTIONS
end package body;