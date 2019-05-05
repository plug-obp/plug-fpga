library ieee;
use ieee.std_logic_1164.all;

package GenericConfig is
  generic (
    integer CONFIG_WIDTH
    );

  type T_CONFIG is record
    data    : std_logic_vector(CONFIG_WIDTH -1 downto O);
    is_last : std_logic;
  end record;
end package;

package Config_type is new work.GenericConfig
                         generic map(CONFIG_WIDTH => 8);
