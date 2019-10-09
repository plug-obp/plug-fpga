
--entity hash is

--  generic (
--    DATA_WIDTH : natural;
--    HASH_WIDTH : natural;
--    WORD_WIDTH : natural);

--  port (
--        clk      : in  std_logic;
--        reset    : in  std_logic;
--        data     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
--        hash_en  : in  std_logic;
--        hash_key : out std_logic_vector(HASH_WIDTH - 1 downto 0);
--        hash_ok  : out std_logic
--    );


--end entity hash;
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.all; 



architecture murmur3_wrapper of hash is
	type CTRL_STATE is (IDLE, PROCESSING, ERR); 
	signal state : CTRL_STATE; 
	signal ap_start : std_logic; 
	signal ap_done : std_logic; 

	signal key : std_logic_vector(31 downto 0); 
	signal key_ap_vld : std_logic; 
	signal seed : std_logic_vector(31 downto 0); 
	signal seed_ap_vld : std_logic; 

begin

	hash_inst : entity murmur3(behav)
	port map(
		ap_clk => clk,						-- : IN STD_LOGIC;
		ap_rst_n => reset, 						-- : IN STD_LOGIC;
		ap_start =>	ap_start, 					-- : IN STD_LOGIC;
		ap_done => ap_done, 						-- : OUT STD_LOGIC;
		ap_idle => 	open, 					-- : OUT STD_LOGIC;
		ap_ready => open, 				-- : OUT STD_LOGIC;
		key => 	key, 				-- : IN STD_LOGIC_VECTOR (31 downto 0);
		key_ap_vld => key_ap_vld,  					-- : IN STD_LOGIC;
		seed => seed, 		-- : IN STD_LOGIC_VECTOR (31 downto 0);
		seed_ap_vld => '1', 					-- : IN STD_LOGIC;
		ap_return => hash_key			-- : OUT STD_LOGIC_VECTOR (31 downto 0) );
	); 

	seed  <= std_logic_vector(to_unsigned(42, 32));

	--ctrl : process (reset, clk)
	--begin
	--  	if (reset = '0') then
	--    	ap_start <= '0'; 
	--    	key <= (others => '0');
	--    	key_ap_vld <= (others => '0');
	--    	seed_ap_vld <= '0'; 
	--    	state <= IDLE; 
	--  	elsif (rising_edge(clk)) then
	--		if (state = IDLE and hash_en = '1') then 
	--				key <= data; 
	--				ap_start <= '1'; 
	--				key_ap_vld <= '1'
	--				state <= PROCESSING; 
	--		elsif (state = PROCESSING and ap_done = '1') then
	--			hash_key <= ap_return; 
	--			hash_en <= '1'; 
	--			state <= IDLE;
	--		elsif (state = PROCESSING and hash_en = '1') then
	--			state <= ERR; 
	--		else 
	--			state <= state; 
	--			ap_start <= '0'; 
	--			key <= '0'; 
	--			key_ap_vld <= '0'; 
	--			seed_ap_vld <= '0'; 
	--		end if; 
	--  	end if;
	--end process ctrl;

 	hash_ok <= '1' when ap_done = '1' and ap_start = '1' else '0'; 
 		
	process (reset, clk, hash_en, ap_done)
	begin
	  if (reset = '0') then
	  	ap_start <= '0'; 
	  elsif (rising_edge(clk)) then
		if hash_en = '1' then 
			ap_start <= '1'; 
		elsif ( ap_done = '1' ) then
			ap_start <= '0'; 
		else 
			ap_start <= ap_start; 
		end if; 
	  end if;
	end process; 

	process (reset, clk, hash_en)
	begin
	  if (reset = '0') then
	    key <= (others => '0');
	    key_ap_vld <= '1'; 
	  elsif (rising_edge(clk)) then
		if hash_en = '1' then 
			key <= data; 
			key_ap_vld <= '1'; 
		else 
			key <= key; 
			key_ap_vld <= key_ap_vld; 
		end if; 
	  end if;
	end process ;



end architecture ; 