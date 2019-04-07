package explicit_params is
    type T_MODEL_PARAMS is record
        nb_states : integer;            -- number of configurations
        nb_transitions : integer;       -- number of transitions
        nb_initial : integer;           -- number of initial configurations
        configuration_width : integer;  -- number of bits in the configuration
    end record;
end package;