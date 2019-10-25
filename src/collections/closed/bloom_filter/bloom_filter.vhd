library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bloom_filter is

  generic (
    HASH_LENGTH : natural := 32;
    ADDRESS_WIDTH : natural := 16; 
    DATA_WIDTH : natural := 8);

  port (
    clk             : in  std_logic;
    reset           : in  std_logic;
    reset_n         : in  std_logic;
    clear_table     : in  std_logic;     
    add_enable      : in  std_logic;
    data_in         : in  std_logic_vector;
    is_in           : out std_logic; 
    is_done         : out std_logic; 
    is_full         : out std_logic
   --cont_data : in  std_logic_vector;
   --cont_en   : in  std_logic;
   --cont_ret  : out std_logic
    );

end entity; 



