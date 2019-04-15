library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity bf_reg_file is

  generic (
    ADDR_WIDTH : natural := 8);

  port (
    clk         : in  std_logic;
    reset       : in  std_logic;
reset_n : in std_logic; 
    w_en        : in  std_logic;
    w_addr      : in  std_logic_vector(ADDR_WIDTH -1 downto 0);
    w_ok        : out std_logic;
    w_done      : out std_logic; 
    r_addr      : in  std_logic_vector(ADDR_WIDTH -1 downto 0);
    r_en        : in  std_logic;
    r_ret       : out std_logic
  );

end entity bf_reg_file;

architecture bf_reg_file of bf_reg_file is
  signal array_reg : std_logic_vector(2**ADDR_WIDTH -1 downto 0);
  signal val       : std_logic;
  signal op        : std_logic_vector(1 downto 0) := "00";
begin  -- architecture reg_file

  val <= array_reg(to_integer(unsigned(w_addr)));
  -- Writing process
  op  <= w_en & r_en;
  process (clk, reset) is
  begin  -- process
    if reset_n = '0' then                 -- asynchronous reset (active low)
      array_reg <= (others => '0');
      val       <= '0';
      r_ret <= '0';
      w_ok <= '0'; 
      
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      case op is
        when "01" =>
          r_ret <= array_reg(to_integer(unsigned(r_addr)));
        when "10" =>
          if val = '0' then
            array_reg(to_integer(unsigned(w_addr))) <= '1';
            w_ok                                    <= '1';
            w_done                                  <= '1'; 
          else
            w_ok <= '0';
            w_done <= '1'; 
          end if;
        when "11" =>
        when others =>
          w_ok  <= '0';
          r_ret <= '0';
          w_done <= '0'; 
      end case;


    end if;
  end process;





end architecture bf_reg_file;
