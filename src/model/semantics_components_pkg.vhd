--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--package semantics_components is

--component semantics_controler is 
--    generic (
--        HAS_OUTPUT_REGISTER : boolean := true
--    );
--    port (
--        clk             : in std_logic;                                 -- clock
--        reset           : in std_logic;
--        reset_n         : in std_logic;
--        ask_next        : in std_logic;
--        t_ready         : in std_logic; 
--        t_produced      : in std_logic;
--        has_next        : in std_logic;
--        s_ready         : in std_logic;
--        i_en        : out std_logic;
--        n_en        : out std_logic;
--        ask_src     : out std_logic;
--        is_deadlock    : out std_logic
--    );
--end component;

--component semantics is
--    generic (
--        CONFIG_WIDTH : integer := 6
--    );
--    port (
--        clk             : in std_logic;                                 -- clock
--        reset           : in std_logic;
--        reset_n         : in std_logic;
--        initial_enable  : in std_logic;                                 -- when initial is asserted, data_out contains a new configuration each clock cycle while has_next is set
        
--        next_enable     : in std_logic;
--        source_in       : in std_logic_vector(CONFIG_WIDTH-1 downto 0);

--        target_out      : out std_logic_vector(CONFIG_WIDTH-1 downto 0); -- the output configuration data
--        target_ready    : out std_logic;                                -- next out can be read
--        has_next        : out std_logic;                                 -- no more configuration available
--        is_done         : out std_logic
--    );
--end component;

--end package;



-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


package semantics_components_v2 is

component semantics_controler is 
    generic (
        HAS_OUTPUT_REGISTER : boolean := true; 
	    CONFIG_WIDTH : integer := 6

    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;
        start           : in std_logic; 
        ask_next        : in std_logic;
        t_ready         : in std_logic; 
        t_produced      : in std_logic;
        has_next        : in std_logic;
        s_ready         : in std_logic;
        src_in          : in std_logic_vector(CONFIG_WIDTH-1 downto 0); 
        i_en            : out std_logic;
        n_en            : out std_logic;
        src_out         : out std_logic_vector(CONFIG_WIDTH-1 downto 0); 
        ask_src         : out std_logic;
        is_deadlock     : out std_logic; 
        idle            : out std_logic
    );
end component;

component semantics is
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
end component;

end package;
