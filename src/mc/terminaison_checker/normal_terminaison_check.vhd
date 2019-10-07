library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions



entity normal_terminaison_check is
	generic (
		HAS_OUTPUT_REGISTER : boolean := false
	);
	port (
		clk                 : in std_logic;
		reset, reset_n      : in std_logic; 
    start               : in std_logic; 
		open_empty          : in std_logic; 
		timeout             : in std_logic_vector(15 downto 0); 
    idle_next_controler : in std_logic; 
    idle_scheduler      : in std_logic; 
		normal_term         : out std_logic
	);

end normal_terminaison_check;

architecture a of normal_terminaison_check is

 type T_CONTROL is (S0, S_STARTED, S1, S2, S3, S_END); 

 constant DEFAULT_STATE : T_CONTROL := S0; 



  type T_OUTPUT is record
    normal_term : std_logic; 
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := (normal_term => '0'); 


  --next state
  signal state_c  : T_CONTROL:= DEFAULT_STATE;
  signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

  --registers
  signal state_r : T_CONTROL := DEFAULT_STATE;
begin

  state_update : process (clk, reset_n) is
  begin
    if reset_n = '0' then
      state_r <= DEFAULT_STATE;
    elsif rising_edge(clk) then
      if reset = '1' then
        state_r <= DEFAULT_STATE;
      else
        state_r <= state_c;
      end if;
    end if;
  end process;

  next_update : process (clk, timeout, open_empty, state_r, start) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current    : T_CONTROL  := DEFAULT_STATE;
  begin
    current    := state_r;
    the_output := DEFAULT_OUTPUT;

    case current is 
      when S0 => 
        if start = '1' then 
          current := S_STARTED; 
        end if; 
      when S_STARTED => 
      	if idle_next_controler = '1' then 
      		current := S1; 
      	end if; 
      when S1 => 
        if idle_scheduler = '1' then 
          current := S2; 
        elsif idle_next_controler = '0' then 
          current := S_STARTED; 
        end if;  
      when S2 => 
        if open_empty = '1' then 
          current := S3; 
        elsif idle_next_controler = '0' or idle_scheduler = '0' then 
            current := S_STARTED; 
        end if; 
      when S3 =>
        if idle_next_controler = '0' or idle_scheduler = '0'  or open_empty = '0' then 
          current := S_STARTED; 
        else  
          current := S_END; 
        end if; 
      when S_END =>
        if start = '1' then 
          current := S_STARTED; 
        else 
          the_output.normal_term := '1'; 
        end if; 
    end case;



    --set the state_c
    state_c  <= current;
    --set the outputs
    output_c <= the_output;
  end process;

  out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
      procedure reset_output is
      begin
      	normal_term <= '0'; 
      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
        	normal_term <= output_c.normal_term; 
        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
		normal_term <= output_c.normal_term;
  end generate;



end a;