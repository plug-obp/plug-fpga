library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Ping pong FIFO implemented using as a circular buffer.
-- The barrier pointer gets the value of the write_ptr if the read_ptr = barrier_ptr, in that case swapped is asserted

entity pingpong_fifo is
  generic
    (
      ADDRESS_WIDTH : integer := 8;  -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
      DATA_WIDTH    : integer := 8  -- data width in bits, the size of a configuration
      );
  port
    (
      clk          : in  std_logic;     -- clock
      reset        : in  std_logic;  -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
      reset_n      : in  std_logic;
      is_pingpong  : in  std_logic; 
      pop_enable   : in  std_logic;     -- read enable 
      push_enable  : in  std_logic;     -- write enable 
      data_in      : in  std_logic_vector(DATA_WIDTH- 1 downto 0);  -- the data that is added when write_enable
      mark_last    : in  std_logic;
      data_out     : out std_logic_vector(DATA_WIDTH- 1 downto 0);  -- the data that is read if read_enable
      data_ready   : out std_logic;
      is_empty     : out std_logic;  -- is_empty is asserted when no elements are in
      is_full      : out std_logic;  -- is_full is asserted when data_count == CAPACITY
      is_last      : out std_logic;
      pop_is_done  : out std_logic;
      push_is_done : out std_logic; 
      is_swapped   : out std_logic
      );
end pingpong_fifo;

