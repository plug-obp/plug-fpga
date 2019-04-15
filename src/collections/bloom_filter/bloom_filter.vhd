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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.mc_components.ALL;

architecture bloom_filter of set is
  constant HASH_LENGTH : natural := 16; 
  signal w_addr : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal r_en   : std_logic := '0';
  signal w_en   : std_logic;
  signal w_key : std_logic_vector(HASH_LENGTH-1 downto 0); 

  signal key : integer;
  signal addr : integer; 

  signal w_ok_s : std_logic; 

  -- non assigned signals 
  signal r_addr   : std_logic_vector(ADDRESS_WIDTH-1 downto 0) := (others => '0');
  signal r_ret    : std_logic                                := '0';
  signal cont_ret : std_logic;

begin  -- architecture bloom_filter

  hash_add : hash
    generic map (
      HASH_WIDTH => HASH_LENGTH,
      DATA_WIDTH =>  DATA_WIDTH)
    port map (
      clk      => clk,
      reset    => reset,
      reset_n  => reset_n,
      data     => data_in,
      hash_en  => add_enable,
      hash_key => w_key,
      hash_ok  => w_en);


    
  
  
  reg : entity work.bf_reg_file
    generic map (
      ADDR_WIDTH => ADDRESS_WIDTH)
    port map (
      clk    => clk,
      reset  => reset,
	   reset_n => reset_n,
      w_en   => w_en,
      w_addr => w_key(ADDRESS_WIDTH-1 downto 0),
      W_ok   => w_ok_s,
      w_done => is_done, 
      r_addr => (others => '0'),
      r_en   => '0',
      r_ret  => open);

    is_in <= '1' when w_ok_s = '0' and is_done = '1' else '0'; 

  is_full <= '0'; 

end architecture bloom_filter;
