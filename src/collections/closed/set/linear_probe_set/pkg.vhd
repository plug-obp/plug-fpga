library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pkg is
  constant ADDRESS_WIDTH    : natural :=4;
  constant DATA_WIDTH       : natural :=16;
  constant CAPACITY :integer := 2**ADDRESS_WIDTH;

  type T_SET_ELEMENT is record
      data : std_logic_vector(DATA_WIDTH-1 downto 0);
      is_set : boolean;
  end record;

  type T_MEMORY is array (0 to CAPACITY - 1) of T_SET_ELEMENT;

  type T_INDEX is record
      ptr : integer range 0 to CAPACITY-1;
      is_valid : boolean;
      is_found : boolean;
  end record;
end package;
