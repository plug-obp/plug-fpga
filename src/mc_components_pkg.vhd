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
        add_done        : out std_logic;
        is_full         : out std_logic                               -- is_full is asserted when data_count == CAPACITY
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
        has_next        : out std_logic                                 -- no more configuration available
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

component controler is
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        sem_has_next    : in std_logic;

        open_is_empty   : in std_logic;
        open_is_full    : in std_logic;
        open_swap       : in std_logic;

        closed_full     : in std_logic;
        add_done : in std_logic;

        check_ready     : in std_logic;
        check_status    : in std_logic;

        start           : in std_logic;
        initialize      : out std_logic;
        execution_ended : out std_logic;
        is_verified     : out std_logic
    );
end component;

end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mc_components.all;
entity mc is
    generic (
        DATA_WIDTH              : integer := 6;
        OPEN_ADDRESS_WIDTH      : integer := 8;
        CLOSED_ADDRESS_WIDTH    : integer := 10
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

architecture arch_v0 of mc is
    signal initial : std_logic;
    signal open_empty, open_full, open_swap : std_logic;
    signal closed_full, add_done: std_logic;
    signal has_next : std_logic;
    signal check_ready, check_status : std_logic;
    signal source, target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal source_ready : std_logic;
    signal target_ready : std_logic;
    signal is_known : std_logic;
    --computed signals
    signal pop_enable, push_enable : std_logic;
    signal initial_enable, next_enable : std_logic;
    signal check_enable : std_logic;
begin

pop_enable <= '1' when initial = '0' and has_next = '0' else '0';
push_enable <= '1' when is_known = '0' and add_done = '1' else '0';

open_inst : open_stream
    generic map (ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        pop_enable  => pop_enable,
        push_enable => push_enable,
        data_in     => target,
        data_out    => source,
        data_ready  => source_ready,
        is_empty    => open_empty,
        is_full     => open_full,
        is_swapped  => open_swap
    );

closed_inst : closed_stream
    generic map (ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        add_enable  => target_ready,
        data_in     => target,
        is_in       => is_known,
        add_done    => add_done,
        is_full     => closed_full
    );

initial_enable <= '1' when initial = '1' and add_done = '1' else '0';
next_enable <= '1' when initial = '0' and source_ready = '1' and add_done = '1' else '0';

semantics_inst : semantics
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,
        
        initial_enable  => initial_enable,
        next_enable     => next_enable,
        source_in       => source,
        target_out      => target,
        target_ready    => target_ready,
        has_next        => has_next
    );

check_enable <= '1' when is_known = '0' else '0';

checker_inst : checker
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,

        check_enable    => check_enable,
        config_in       => target,
        check_ready     => check_ready,
        check_status    => check_status
    );

controler_inst : controler
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,

        sem_has_next    => has_next,

        open_is_empty   => open_empty,
        open_is_full    => open_full,
        open_swap       => open_swap,

        closed_full     => closed_full,
        add_done        => add_done,

        check_ready     => check_ready,
        check_status    => check_status,

        start           => start,
        initialize      => initial,
        execution_ended => execution_ended,
        is_verified     => is_verified
    );
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity open_stream is
    generic
    (
        ADDRESS_WIDTH   : integer    := 8;                                -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH      : integer    := 8                                 -- data width in bits, the size of a configuration
    );
    port 
    ( 
        clk             : in  std_logic;                                -- clock
        reset           : in  std_logic;                                 -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        reset_n         : in  std_logic;
        pop_enable      : in  std_logic;                                     -- read enable 
        push_enable     : in  std_logic;                                     -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is added when write_enable
        data_out        : out std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is read if read_enable
        data_ready      : out std_logic;
        is_empty        : out std_logic;                                 -- is_empty is asserted when no elements are in
        is_full         : out std_logic;                                 -- is_full is asserted when data_count == CAPACITY
        is_swapped      : out std_logic
    );
end entity;
architecture a of open_stream is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity closed_stream is 
    generic (
        ADDRESS_WIDTH    : integer    := 4;                           -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH       : integer    := 16                          -- data width in bits, the size of a configuration
    );
    port (
        clk             : in  std_logic;                               -- clock
        reset           : in  std_logic;                               -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        reset_n         : in  std_logic;
        add_enable      : in  std_logic;                               -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);-- the data that is added when write_enable
        is_in           : out std_logic;                              -- already_in is asserted if the last data_in handled was already in the set
        add_done        : out std_logic;
        is_full         : out std_logic                               -- is_full is asserted when data_count == CAPACITY
    );
end entity;
architecture a of closed_stream is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity semantics is
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
        has_next        : out std_logic                                 -- no more configuration available
    );
end entity;
architecture a of semantics is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity checker is
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
end entity;
architecture a of checker is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity controler is
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        sem_has_next    : in std_logic;

        open_is_empty   : in std_logic;
        open_is_full    : in std_logic;
        open_swap       : in std_logic;

        closed_full     : in std_logic;
        add_done : in std_logic;

        check_ready     : in std_logic;
        check_status    : in std_logic;

        start           : in std_logic;
        initialize      : out std_logic;
        execution_ended : out std_logic;
        is_verified     : out std_logic
    );
end entity;
architecture a of controler is begin end architecture;