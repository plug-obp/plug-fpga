library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity transition_relation is
    generic
    (
        DATA_WIDTH         : integer    := 24                                 -- data width in bits, the size of a configuration
    );
    port 
    ( 
        clk              : in  std_logic;                                -- clock
        initial_enable   : in  std_logic;                             -- when initial is asserted, data_out contains a new configuration each clock cycle while has_next is set

        next_enable      : in std_logic;
        source_in        : in std_logic_vector(DATA_WIDTH-1 downto 0);

        next_out         : out std_logic_vector(DATA_WIDTH- 1 downto 0); -- the output configuration data
        next_ok          : out std_logic; -- next out can be read
        has_next         : out std_logic -- no more configuration available
    );
end transition_relation;
architecture a of transition_relation is begin end architecture;