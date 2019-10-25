library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.mc_components.ALL;

architecture bloom_filter_a of set is
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
  signal is_done_s : std_logic; 

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
      w_done => is_done_s, 
      r_addr => (others => '0'),
      r_en   => '0',
      r_ret  => open);

    is_in <= '1' when w_ok_s = '0' and is_done_s = '1' else '0'; 
    is_done <= is_done_s; 
    is_full <= '0'; 

end architecture;