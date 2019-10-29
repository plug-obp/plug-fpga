library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.model_structure.ALL;
package explicit_structure is
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

    pure function state_at(model: T_EXPLICIT; index : integer) return std_logic_vector;
    pure function initial_at(model: T_EXPLICIT; index : integer) return std_logic_vector;
    pure function target_at(model: T_EXPLICIT; index : integer) return std_logic_vector;
    pure function fanout_size(model: T_EXPLICIT; source_index : integer) return integer;
end package;

package body explicit_structure is
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