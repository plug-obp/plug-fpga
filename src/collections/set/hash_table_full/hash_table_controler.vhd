library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity hash_table_controler is 
  generic (
    HAS_OUTPUT_REGISTER : boolean := false; 
    HASH_WIDTH : integer := 8; 
    ADDR_WIDTH : integer := 8; 
    DATA_WIDTH : integer := 64 
  ); 
  port (
    clk         : in std_logic; 
    reset       : in std_logic; 
    reset_n     : in std_logic; 
    add_enable  : in std_logic; 
    data        : in std_logic_vector(DATA_WIDTH-1 downto 0); 
    clear_table : in std_logic; 
    isIn        : out std_logic; 
    isFull      : out std_logic; 
    isDone      : out std_logic
    hash_ok     : in std_logic; 
    hash        : in std_logic_vector(HASH_LENGTH - 1 downto 0); 
    -- I/Os for config reg file 
    rf_c_r      : out std_logic; 
    rf_c_w      : out std_logic; 
    rf_c_w_data : out std_logic_vector(DATA_WIDTH -1 downto 0);  
    rf_c_r_data : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    rf_c_w_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0);  
    rf_c_r_addr : in  std_logic_vector(ADDR_WIDTH -1 downto 0);
    rf_c_r_ok : in std_logic; 
    -- I/Os for isFilled reg file 
    rf_p_r      : out std_logic; 
    rf_p_w      : out std_logic; 
    rf_p_w_data : out std_logic_vector(0 downto 0);  
    rf_p_r_data : in  std_logic_vector(0 downto 0);
    rf_p_w_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0);  
    rf_p_r_addr : in  std_logic_vector(ADDR_WIDTH -1 downto 0);
    rf_p_r_ok   : in std_logic
  ) ; 
end entity; 