library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mc_generic is
    generic (
        DATA_WIDTH              : integer := 6;
        OPEN_ADDRESS_WIDTH      : integer := 4;
        CLOSED_ADDRESS_WIDTH    : integer := 4
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        start           : in std_logic;

        execution_ended : out std_logic;
        is_verified     : out std_logic
    );
end entity;

