library ieee; 
use ieee.std_logic_1164.all; 



package bloom_filter_components is 


	component hash_block_cmp is 
 		generic (
 			DATA_WIDTH : natural;
 			HASH_WIDTH : natural;
 			WORD_WIDTH : natural
 		);

		port (
			clk      : in  std_logic;
			reset    : in  std_logic;
			reset_n  : in  std_logic; 
			data     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			hash_en  : in  std_logic;
			hash_key : out std_logic_vector(HASH_WIDTH - 1 downto 0);
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
			isDone : out std_logic; 

			hash_ok : in std_logic; 
			hash : in std_logic_vector(HASH_WIDTH - 1 downto 0); 

			-- I/Os for isIn reg file 

			rf_p_r : out std_logic; 
			rf_p_w : out std_logic; 
			rf_p_clear 	: out std_logic; 
			rf_p_w_data : out std_logic_vector(0 downto 0);  
			rf_p_r_data : in  std_logic_vector(0 downto 0);
			rf_p_w_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0);  
			rf_p_r_addr : out  std_logic_vector(ADDR_WIDTH -1 downto 0);
			rf_p_r_ok : in std_logic

		); 

	end component; 
	

	component reg_file_ssdpRAM_cmp is 
	  generic(
	    MEM_TYPE    : string := "block"; 
	    DATA_WIDTH     : integer := 416; 
	    ADDR_WIDTH     : integer := 12
	  ); 
	  port (
	    clk           : in std_logic;
	    reset         : in std_logic; 
	    clear 		  : in std_logic; 

	    we            : in std_logic; 
	    addr_w        : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
	    d_in          : in std_logic_vector(DATA_WIDTH-1 downto 0); 
	    
	    re            : in std_logic; 
	    addr_r        : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
	    d_out         : out std_logic_vector(DATA_WIDTH-1 downto 0); 
	    r_ok 		  : out std_logic
	  ); 
	end component; 



end package; 

