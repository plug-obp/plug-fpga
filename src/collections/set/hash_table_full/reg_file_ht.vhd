-- Entity and architectures of simple synchronous dual port ram. 


entity reg_file_ssdpRAM is 
  generic(
    MEM_TYPE    : string := "block"; 
    DATA_WIDTH     : integer := 416; 
    ADDR_WIDTH     : integer := 12
  ); 
  port (
    clk           : in std_logic;
    reset         : in std_logic; 

    we            : in std_logic; 
    addr_w        : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    d_in          : in std_logic_vector(DATA_WIDTH-1 downto 0); 
    
    re            : in std_logic; 
    addr_r        : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    d_out         : out std_logic_vector(DATA_WIDTH-1 downto 0)
  ); 
end entity; 


architecture rtl of reg_file_ssdpRAM is 

  type T_MEM is array (0 to 2**ADDR_WIDTH -1)
    of std_logic_vector(DATA_WIDTH-1 downto 0); 

  signal mem : T_MEM; 
  attribute ram_style : string;
  attribute ram_style of mem : variable is MEM_TYPE;

begin 
  
  reg : process (clk)
  begin
    if (rising_edge(clock)) then
      if (reset = '1') then 
        mem <= (others => (others => '0')
      elsif (we = '1' and re = '1') then 
        mem(to_integer(unsigned(addr_w))) <= d_in;
        d_out <= mem(to_integer(unsigned(addr_r))); 
      elsif (we = '1' and re = '0') then 
        mem(to_integer(unsigned(addr_w))) <= d_in;
      elsif (we = '0' and re = '1') then 
        d_out <= mem(to_integer(unsigned(addr_r))); 
      end if; 
    end if;
  end process reg;
  
end rtl;




