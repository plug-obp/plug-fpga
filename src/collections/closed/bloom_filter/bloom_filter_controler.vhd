library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bloom_filter_controler is
	generic(
		HAS_OUTPUT_REGISTER : boolean := false;
		HASH_WIDTH          : integer := 8;
		ADDR_WIDTH          : integer := 8;
		DATA_WIDTH          : integer := 64
	);
	port(
		clk         : in  std_logic;
		reset       : in  std_logic;
		reset_n     : in  std_logic;
		add_enable  : in  std_logic;
		data        : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
		clear_table : in  std_logic;
		isIn        : out std_logic;
		isFull      : out std_logic;
		isDone      : out std_logic;
		data_out    : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		hash_ok     : in  std_logic;
		hash        : in  std_logic_vector(HASH_WIDTH - 1 downto 0);
		-- I/Os for isFilled reg file 
		rf_p_r      : out std_logic;
		rf_p_w      : out std_logic;
		rf_p_clear  : out std_logic;
		rf_p_w_data : out std_logic_vector(0 downto 0);
		rf_p_r_data : in  std_logic_vector(0 downto 0);
		rf_p_w_addr : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
		rf_p_r_addr : out std_logic_vector(ADDR_WIDTH - 1 downto 0);
		rf_p_r_ok   : in  std_logic
	);
end entity;
