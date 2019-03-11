library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUmERIC_STD.ALL;

package alice_bob_pkg is
type T_STATE is  (IDLE, WAITS, CS);
type T_CONFIGURATION is record
    alice : T_STATE;
    aliceFlag : boolean;
    bob : T_STATE;
    bobFlag : boolean;
end record;

pure function config2lv(c : T_CONFIGURATION) return std_logic_vector;
pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION;
end package;

package body alice_bob_pkg is

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

end;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUmERIC_STD.ALL;
use work.alice_bob_pkg.all;
package explicit_pkg is



type T_MODEL_PARAMS is record
    nb_states : integer;
    nb_transitions : integer;
    nb_initial : integer;
    configuration_width : integer;
end record;
constant ABPARAMS : T_MODEL_PARAMS := (10, 17, 1, 6);
type T_STATES is array (0 to ABPARAMS.nb_states) of std_logic_vector(ABPARAMS.configuration_width-1 downto 0);
type T_INITIAL is array (0 to ABPARAMS.nb_initial) of integer;
type T_COLUMN is array (0 to ABPARAMS.nb_states) of integer;
type T_FANOUT    is array (0 to ABPARAMS.nb_transitions-1) of integer;

type T_EXPLICIT is record
    states : T_STATES;
    initial : T_INITIAL;
    columnPtr : T_COLUMN;
    fanout : T_FANOUT;
end record;

constant AB_MODEL : T_EXPLICIT := (
	states => (
		 0 => config2lv((IDLE, false, IDLE, false)),
		 1 => B"000000",
		 2 => B"000000",
		 3 => B"000000",
		 4 => B"000000",
		 5 => B"000000",
		 6 => B"000000",
		 7 => B"000000",
		 8 => B"000000",
		 9 => B"000000",
		10 => B"000000"
	),
	initial => (0 => 0),
	columnPtr => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	fanout => (others => 0)
);



end package;


