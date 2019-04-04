library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package model_pkg is
    -- BEGIN GENERIC EXPLICIT MODEL
    type T_MODEL_PARAMS is record
        nb_states : integer;            -- number of configurations
        nb_transitions : integer;       -- number of transitions
        nb_initial : integer;           -- number of initial configurations
        configuration_width : integer;  -- number of bits in the configuration
    end record;
    -- END GENERIC EXPLICIT MODEL

    -- BEGIN ALICE BOB MODEL
    type T_STATE is  (IDLE, WAITS, RETRY, CS);
    type T_CONFIGURATION is record
        alice : T_STATE;
        aliceFlag : boolean;
        bob : T_STATE;
        bobFlag : boolean;
    end record;

    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector;
    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION;

    constant AB_PARAMS : T_MODEL_PARAMS := (11, 17, 1, 6);
    -- END ALICE BOB MODEL

    -- BEGIN GENERIC EXPLICIT MODEL
    type T_STATES is array (0 to AB_PARAMS.nb_states-1) of T_CONFIGURATION;
    type T_INITIAL is array (0 to AB_PARAMS.nb_initial-1) of integer;
    type T_FANOUT_BASE is array (0 to AB_PARAMS.nb_states) of integer;
    type T_FANOUT    is array (0 to AB_PARAMS.nb_transitions-1) of integer;

    type T_EXPLICIT is record
        states          : T_STATES;         -- the state array
        initial         : T_INITIAL;        -- the initial array
        fanout_base    : T_FANOUT_BASE;   -- the fanout indirection array : fanout (5) is in fanout array between [8, 10)
        fanout          : T_FANOUT;         -- the fanout array
    end record;
    -- END GENERIC EXPLICIT MODEL

    -- BEGIN ALICE BOB MODEL (state-space)
    --state-space of the lamport alice-bob mutex (unfair to bob)
    constant AB_MODEL : T_EXPLICIT := (
        states => (
            0 => (IDLE,  false,  IDLE,   false),    -- B000000
            1 => (WAITS, true,   IDLE,   false),    -- B011000
            2 => (IDLE,  false,  WAITS,  true),     -- B000011

            3 => (CS,    true,   IDLE,   false),    -- B111000
            4 => (WAITS, true,   WAITS,  true),     -- B011011
            5 => (IDLE,  false,  CS,     true),     -- B000111

            6 => (CS,    true,   WAITS,  true),     -- B111011
            7 => (WAITS, true,   RETRY,  false),    -- B011100
            8 => (WAITS, true,   CS,     true),     -- B011111

            9 => (CS,    true,   RETRY,  false),    -- B111100
           10 => (IDLE,  false,  RETRY,  false)     -- B000100
        ),
        initial => (0=>0),
        fanout_base => (0, 2, 4, 6, 7, 8, 10, 12, 13, 14, 15, 17),
        fanout => (
            1, 2,   -- fanout( 0)
            3, 4,   -- fanout( 1)
            4, 5,   -- fanout( 2)
            6,      -- fanout( 3)
            7,      -- fanout( 4)
            0, 8,   -- fanout( 5)
            2, 9,   -- fanout( 6)
            9,      -- fanout( 7)
            1,      -- fanout( 8)
            10,     -- fanout( 9)
            5, 7    -- fanout(10)
        )
    );
    -- END ALICE BOB MODEL (state-space)

    pure function state_at(model: T_EXPLICIT; index : integer) return std_logic_vector;
    pure function initial_at(model: T_EXPLICIT; index : integer) return std_logic_vector;
    pure function target_at(model: T_EXPLICIT; index : integer) return std_logic_vector;
    pure function fanout_size(model: T_EXPLICIT; source_index : integer) return integer;

end package;

package body model_pkg is
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

    pure function state_at(model: T_EXPLICIT; index : integer) return std_logic_vector is
    begin
        return config2lv(model.states(index));
    end function;

    pure function initial_at(model: T_EXPLICIT; index : integer) return std_logic_vector is
    begin
        return config2lv(model.states(model.initial(index)));
    end function;

    pure function target_at(model: T_EXPLICIT; index : integer) return std_logic_vector is
    begin
        return config2lv(model.states(model.fanout(index)));
    end function;

    pure function fanout_size(model: T_EXPLICIT; source_index : integer) return integer is
    begin
        return model.fanout_base(source_index+1) - model.fanout_base(source_index);
    end function;
end package body;


