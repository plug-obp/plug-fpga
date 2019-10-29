
-- Entity and architectures of simple synchronous dual port ram. 
library ieee; 
use ieee.std_logic_1164.ALL; 
use ieee.numeric_std.all; 

entity reg_file_ssdpRAM is 
  generic(
    MEM_TYPE    : string := "block"; 
    DATA_WIDTH     : integer := 416; 
    ADDR_WIDTH     : integer := 12
  ); 
  port (
    clk           : in std_logic;
    reset_n         : in std_logic; 
    clear         : in std_logic; 

    we            : in std_logic; 
    addr_w        : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    d_in          : in std_logic_vector(DATA_WIDTH-1 downto 0); 
    
    re            : in std_logic; 
    addr_r        : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    d_out         : out std_logic_vector(DATA_WIDTH-1 downto 0); 
    r_ok          : out std_logic
  ); 
end entity; 


architecture syn of reg_file_ssdpRAM is
type ram_type is array (2**ADDR_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
shared variable RAM : ram_type := (others => (others => '0'));
begin
  process(clk)
  begin
    if clk'event and clk = '1' then
      if we = '1' then
          RAM(to_integer(unsigned(addr_w))) := d_in; 
      end if; 
    end if; 
  end process; 

  process(clk)
  begin
    if clk'event and clk = '1' then
      if re = '1' then
        d_out <= RAM(to_integer(unsigned(addr_r)));
      end if; 
    end if;
  end process; 

  process(clk, reset_n)
  begin
    if reset_n = '0' then 
      r_ok <= '0'; 
    elsif clk'event and clk = '1' then 
      if re = '1' then 
        r_ok <= '1';
       else 
        r_ok <= '0';  
      end if;  
    end if; 
  end process; 


end architecture; 


--
--
--architecture rtl of reg_file_ssdpRAM is 
--
--  type T_MEM is array (0 to 2**ADDR_WIDTH -1)
--    of std_logic_vector(DATA_WIDTH-1 downto 0); 
--
--  signal mem : T_MEM; 
--  attribute ram_style : string;
--  attribute ram_style of mem : signal is MEM_TYPE;
--
--begin 
--  
--  reg : process (clk)
--  begin
--
--    if (rising_edge(clk)) then
--      if (reset = '0' ) then 
--        mem <= (others => (others => '0'));
--        d_out <= (others => '0');
--        r_ok <= '0'; 
--      elsif (clear = '1') then
--        mem <= (others => (others => '0')); 
--        d_out <= (others => '0');
--        r_ok <= '0'; 
--      elsif (we = '1' and re = '1') then 
--        mem(to_integer(unsigned(addr_w))) <= d_in;
--        d_out <= mem(to_integer(unsigned(addr_r))); 
--        r_ok <= '1'; 
--      elsif (we = '1' and re = '0') then 
--        mem(to_integer(unsigned(addr_w))) <= d_in;
--        d_out  <= (others => '0');
--        r_ok <= '0'; 
--      elsif (we = '0' and re = '1') then 
--        d_out <= mem(to_integer(unsigned(addr_r))); 
--        r_ok <= '1'; 
--      else 
--        d_out <= (others => '0');
--        r_ok <= '0'; 
--      end if; 
--    end if;
--  end process reg;
--  
--end rtl;



-- Simple Dual-Port Block RAM with One Clock-- Correct Modelization with a Shared Variable-- File:simple_dual_one_clock.vhdl
--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.std_logic_unsigned.all
--entity simple_dual_one_clock isport(clk   : in  std_logic
--  ena   : in  std_logic
--enb   : in  std_logic
--wea   : in  std_logic
--addra : in  std_logic_vector(9 downto 0);
--addrb : in  std_logic_vector(9 downto 0);
--dia   : in  std_logic_vector(15 downto 0);
--dob   : out std_logic_vector(15 downto 0));
--end simple_dual_one_clock
