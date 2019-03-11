library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gtr is
    generic
    (
        CONFIGURATION_WIDTH         : integer    := 24;                                 -- data width in bits, the size of a configuration
        FIREABLE_WIDTH              : integer := 24
    );
    port 
    ( 
        clk                         : in  std_logic;

        -- initial call
        initial_enable              : in  std_logic;

        -- fireable call inputs
        get_fireables_enable        : in std_logic;
        source_in                   : in std_logic_vector(DATA_WIDTH-1 downto 0);
        -- fireable call outputs
        fireable_out                : out std_logic_vector(FIREABLE_WIDTH- 1 downto 0);
        fireable_ok                 : out std_logic;
        has_more_fireables          : out std_logic;                                -- are more fireables available ?

        --execute call inputs
        execute                     : in std_logic;
        exe_source_in               : in std_logic_vector(DATA_WIDTH-1 downto 0);
        exe_fireable_in             : std_logic_vector(FIREABLE_WIDTH- 1 downto 0);
        --initial & execute call outputs
        next_out                    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        next_ok                     : out std_logic;
        has_more_next               : out std_logic                                 -- are more configurations available ?
    );
end gtr;
architecture a of gtr is begin end architecture;