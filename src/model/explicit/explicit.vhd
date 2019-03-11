
package explicit_pkg is

type T_STATE is  enum (IDLE, WAITS, CS);
type T_CONFIGURATION is record
    alice : T_STATE;
    aliceFlag : boolean;
    bob : T_STATE;
    bobFlag : boolean;
end record;

type T_EXPLICIT is record
    nb_states : integer;
    nb_transitions : integer;
    nb_initial : integer;
    configuration_width : integer;
    states : array 0 to nb_states of std_logic_vector(configuration_width-1 downto 0);
    initial : array 0 to nb_initial of integer;
    columnPtr : array 0 to nb_states of integer;
    fanout : array 0 to nb_transitions of integer;
end record;

end package;