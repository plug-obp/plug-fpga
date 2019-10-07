library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use work.model_structure.all; 

entity mc_top is 
    generic (
        DATA_WIDTH              : integer := 32;
        OPEN_ADDRESS_WIDTH      : integer := 6;
        CLOSED_ADDRESS_WIDTH    : integer := 4
    );
    port (
        clk             : in  std_logic;                                 -- clock
        reset           : in  std_logic;
        reset_n         : in  std_logic;
        start           : in  std_logic;
        is_bounded      : in  std_logic; 
        sim_end         : out std_logic; 
        end_code        : out std_logic_vector(7 downto 0); 



        i_en_next        : out std_logic; 
        n_en_next        : out std_logic; 
        source_next      : out std_logic_vector(DATA_WIDTH-1 downto 0); 
        target_out_next  : in std_logic_vector(DATA_WIDTH-1 downto 0); 
        t_ready_next     : in std_logic; 
        has_next_next    : in std_logic; 
        t_done_next      : in std_logic

    );
end entity;




