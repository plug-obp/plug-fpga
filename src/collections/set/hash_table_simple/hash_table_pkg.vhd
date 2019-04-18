library ieee; 
use ieee.std_logic_1164.all; 



package hash_table_components is 


	component hash_block_cmp is 
 		generic (
 			DATA_WIDTH : natural;
 			HASH_WIDTH : natural;
 			WORD_WIDTH : natural
 		);

		port (
			clk      : in  std_logic;
			reset    : in  std_logic;
			data     : in  std_logic_vector(DATA_LENGTH - 1 downto 0);
			hash_en  : in  std_logic;
			hash_key : out std_logic_vector(HASH_LENGTH - 1 downto 0);
			hash_ok  : out std_logic
		);
	end component;



	component controler_cmp is 
		generic (
			HAS_OUTPUT_REGISTER : boolean := false; 
			HASH_WIDTH : integer := 8; 
			ADDR_WIDTH : integer := 8; 
			DATA_WIDTH : integer := 64 
		); 
		port (
			clk : in std_logic; 
			reset : in std_logic; 
			reset_n : in std_logic; 

			add_enable : in std_logic; 
			data : in std_logic_vector(DATA_WIDTH-1 downto 0); 

			clear_table : in std_logic; 
			isIn : out std_logic; 
			isFull : out std_logic; 
			isDone : out std_logic

			hash_ok : in std_logic; 
			hash : in std_logic_vector(HASH_LENGTH - 1 downto 0); 

		); 

	end component; 


end package; 

