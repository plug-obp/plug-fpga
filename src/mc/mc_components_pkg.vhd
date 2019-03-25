library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mc_components is

component open_stream is
    generic
    (
        ADDRESS_WIDTH   : integer    := 8;                                -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH      : integer    := 8                                 -- data width in bits, the size of a configuration
    );
    port 
    ( 
        clk             : in  std_logic;                                -- clock
        reset           : in  std_logic;                                 -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        reset_n			: in  std_logic;
        pop_enable      : in  std_logic;                                     -- read enable 
        push_enable     : in  std_logic;                                     -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is added when write_enable
        push_is_done	: out std_logic;
        data_out        : out std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is read if read_enable
        data_ready      : out std_logic;
        is_empty        : out std_logic;                                 -- is_empty is asserted when no elements are in
        is_full         : out std_logic;                                 -- is_full is asserted when data_count == CAPACITY
        is_swapped      : out std_logic
    );
end component; 

component closed_stream is 
    generic (
        ADDRESS_WIDTH    : integer    := 4;                           -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH       : integer    := 16                          -- data width in bits, the size of a configuration
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
end component;

component next_stream is
    generic (
        CONFIG_WIDTH : integer := 6
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        next_en : in std_logic;
        target_ready : out std_logic;
        target_out   : out std_logic_vector(CONFIG_WIDTH-1 downto 0);

        ask_src : out std_logic;
        s_ready : in std_logic;
        s_in    : in std_logic_vector(CONFIG_WIDTH-1 downto 0);
        
        is_deadlock : out std_logic
    );
end component;

component checker is
    generic (
        CONFIG_WIDTH : integer := 6
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        check_enable    : in std_logic;
        config_in       : in std_logic_vector(CONFIG_WIDTH-1 downto 0);
        check_ready     : out std_logic;
        check_status    : out std_logic -- '0' property checked, '1' property violated
    );
end component;

component scheduler is 
    generic (
        CONFIG_WIDTH : integer := 6;
        HAS_OUTPUT_REGISTER : boolean := true
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        t_ready : in std_logic;
        schedule_en : in std_logic;
        is_scheduled : in std_logic;

        t_in : in std_logic_vector(CONFIG_WIDTH-1 downto 0);

        ask_push : out std_logic;
        t_out : out std_logic_vector(CONFIG_WIDTH-1 downto 0)
    );
end component;

end package;