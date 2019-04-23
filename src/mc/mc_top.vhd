library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.model_structure.all; 

entity mc_top is 
    generic (
        DATA_WIDTH              : integer := CONFIG_WIDTH;
        OPEN_ADDRESS_WIDTH      : integer := 6;
        CLOSED_ADDRESS_WIDTH    : integer := 4
    );
    port (
        clk             : in  std_logic;                                 -- clock
        reset           : in  std_logic;
        reset_n         : in  std_logic;
        start           : in  std_logic;
        is_bounded      : in  std_logic; 
        sim_end         : out std_logic
    );
end entity;




