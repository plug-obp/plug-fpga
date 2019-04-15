entity hash is

  generic (
    DATA_WIDTH : natural;
    HASH_WIDTH : natural;
    WORD_WIDTH : natural);

  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    data     : in  std_logic_vector(DATA_LENGTH - 1 downto 0);
    hash_en  : in  std_logic;
    hash_key : out std_logic_vector(HASH_LENGTH - 1 downto 0);
    hash_ok  : out std_logic);


end entity hash;
