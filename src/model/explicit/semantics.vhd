library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions



entity semantics is
    generic (
        CONFIG_WIDTH : integer := 6
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;
        initial_enable  : in std_logic;                                 -- when initial is asserted, data_out contains a new configuration each clock cycle while has_next is set
        
        next_enable     : in std_logic;
        source_in       : in std_logic_vector(CONFIG_WIDTH-1 downto 0);

        target_out      : out std_logic_vector(CONFIG_WIDTH-1 downto 0); -- the output configuration data
        target_ready    : out std_logic;                                -- next out can be read
        has_next        : out std_logic;                                 -- no more configuration available
        is_done         : out std_logic
    );
end entity;
