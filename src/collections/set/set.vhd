library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity set is 
    generic (
        ADDRESS_WIDTH    : integer    := 2;                           -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH       : integer    := 4;                          -- data width in bits, the size of a configuration
        HAS_OUTPUT_REGISTER : boolean := true
    );
    port (
        clk             : in  std_logic;                               -- clock
        reset           : in  std_logic;                               -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        reset_n			: in  std_logic;
		
		add_enable      : in  std_logic;                               -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);-- the data that is added when write_enable
        is_in           : out std_logic;                              -- already_in is asserted if the last data_in handled was already in the set
		is_full         : out std_logic;                               -- is_full is asserted when data_count == CAPACITY        
		is_done         : out std_logic  
);
end entity set;