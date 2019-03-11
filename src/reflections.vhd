----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 01:22:44 PM
-- Design Name: 
-- Module Name: test1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity to_see is
    generic
    (
        ADDRESS_WIDTH    : integer    := 4;                                -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH         : integer    := 24;                                 -- data width in bits, the size of a configuration
        CAPACITY        : integer     := 16                                -- CAPACITY must be less than address space: CAPACITY <= 2^(ADDRESS_WIDTH)-1
    );
    port 
    ( 
        clk             : in  std_logic;                                -- clock
        reset             : in  std_logic;                                 -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        top_enable      : in  std_logic;
        pop_enable         : in  std_logic;                                     -- read enable 
        push_enable        : in  std_logic;                                     -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is added when write_enable
        data_out        : out std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is read if read_enable
        is_empty         : out std_logic;                                 -- is_empty is asserted when no elements are in
        is_full            : out std_logic;                                 -- is_full is asserted when data_count == CAPACITY
        swapped            : out std_logic                                -- true if a FIFO swap was detected
    );
end to_see;
architecture a of to_see is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity closed_set is
    generic
    (
        ADDRESS_WIDTH    : integer    := 4;                                -- address width in bits, maximum FIFO_LENGTH is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH         : integer    := 24;                                 -- data width in bits, the size of a configuration
        CAPACITY        : integer     := 16                                -- CAPACITY must be less than address space: CAPACITY <= 2^(ADDRESS_WIDTH)-1
    );
    port 
    ( 
        clk             : in  std_logic;                                -- clock
        reset             : in  std_logic;                                     -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        write_enable    : in  std_logic;                                 -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0); -- the data that is added when write_enable
        already_in        : in  std_logic;                                -- already_in is asserted if the last data_in handled was already in the set
        is_full            : out std_logic                                 -- is_full is asserted when data_count == CAPACITY
    );
end closed_set;
architecture a of closed_set is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity transition_relation is
    generic
    (
        DATA_WIDTH         : integer    := 24                                 -- data width in bits, the size of a configuration
    );
    port 
    ( 
        clk              : in  std_logic;                                -- clock
        initial_enable   : in  std_logic;                             -- when initial is asserted, data_out contains a new configuration each clock cycle while has_next is set

        next_enable      : in std_logic;
        source_in        : in std_logic_vector(DATA_WIDTH-1 downto 0);

        next_out         : out std_logic_vector(DATA_WIDTH- 1 downto 0); -- the output configuration data
        next_ok          : out std_logic; -- next out can be read
        has_next         : out std_logic -- no more configuration available
    );
end transition_relation;
architecture a of transition_relation is begin end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity property_checker is
    generic (
        DATA_WIDTH : integer := 24;
        AP_COUNT : integer := 1
    );
    port (
        clk : in std_logic;
        target_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        ap_out : out std_logic_vector(AP_COUNT - 1 downto 0)
    );
end property_checker;
architecture a of property_checker is begin end architecture;

package pack is
type STATUS_CODE is (VERIFIED, VIOLATED, OPEN_FULL, CLOSED_FULL);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.pack.ALL;


entity model_checker is
    generic (
        DATA_WIDTH : integer := 24;
        STATUS_WIDTH : integer := 2
    );
    port(
        clk : in std_logic;
        start : in std_logic;
        reset : in std_logic;
        done : out std_logic;
        error : out std_logic;
        status_code : out std_logic_vector (STATUS_WIDTH - 1 downto 0)
    );
end model_checker;

architecture a of model_checker is 
begin

--open_stream_1 : entity WORK.open_stream 
--                generic map (ADDRESS_WIDTH => 4, DATA_WIDTH => DATA_WIDTH, CAPACITY => 16)
--                port map (
--                    clk         => clk,
--                    reset       => '0',
--                    read_enable => open,
--                    write_enable=> open,
--                    data_in     => open,
--                    data_out    => open,
--                    size        => open,
--                    is_empty     => open,
--                    is_full        => open
--                    );

end architecture;