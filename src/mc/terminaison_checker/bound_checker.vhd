library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.term_components_pkg.all; 

entity bound_checker is
	generic ( HAS_OUTPUT_REGISTER : boolean := false );
  port (
    clk           : in std_logic;
    reset         : in std_logic; 
    reset_n       : in std_logic; 
    start       : in std_logic; 
    trig          : in std_logic; 
    bound         : in std_logic_vector(7 downto 0); 

    bound_is_reached : out std_logic

  );
end bound_checker;

architecture a of bound_checker is

  type T_CONTROL is (S0, S_COUNT, S_END); 
  type T_STATE is record
    ctrl_state : T_CONTROL;
    bound : integer; 
    cnt : integer; 
  end record;
  constant DEFAULT_STATE : T_STATE := (S0, 0, 0);


  type T_OUTPUT is record
    bound_is_reached        : std_logic;
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := (bound_is_reached => '0'); 

  --next state
  signal state_c  : T_STATE  := DEFAULT_STATE;
  signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

  --registers
  signal state_r : T_STATE := DEFAULT_STATE;
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

  next_update : process (bound, start, trig, state_r) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current    : T_STATE  := DEFAULT_STATE;
  begin
    current    := state_r;
    the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
      when S0 =>
      	if (start = '1') then 
      		current.bound := to_integer(unsigned(bound)); 
          current.cnt := 0; 
          current.ctrl_state := S_COUNT; 
      	--else 
      		--current.ctrl_state := S_END; 
      	end if; 
      when S_COUNT =>
      	if (trig = '1' and current.cnt = current.bound) then 
          current.ctrl_state := S_END; 
      		elsif (trig = '1') then
      			current.cnt := current.cnt + 1; 
      	end if; 
      when S_END => 
        if start = '1' then 
          current.bound := to_integer(unsigned(bound)); 
          current.cnt := 0; 
          current.ctrl_state := S_COUNT; 
        else 
          the_output.bound_is_reached := '1'; 
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
        bound_is_reached <= '0'; 
      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          bound_is_reached <= output_c.bound_is_reached; 
        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
    bound_is_reached <= output_c.bound_is_reached; 
  end generate;

end architecture;
