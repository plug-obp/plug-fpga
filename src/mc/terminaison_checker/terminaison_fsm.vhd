library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use worK.term_components_pkg.all; 

entity terminaison_fsm is
  generic ( HAS_OUTPUT_REGISTER : boolean := false); 
  port (
    clk : in std_logic;
    reset : in std_logic; 
    reset_n : in std_logic; 

    bound_reached_term : in std_logic; 
    closed_full_term : in std_logic; 
    open_full_term : in std_logic; 
    normal_term : in std_logic; 

    sim_end : out std_logic; 
    err_code : out std_logic_vector(7 downto 0)

  );
end terminaison_fsm;

architecture a of terminaison_fsm is

 type T_STATE is (S0, S_OPEN_FULL, S_CLOSED_FULL, S_BOUND_REACHED, S_NORMAL_TERM, S_DEFAULT); 

 constant DEFAULT_STATE : T_STATE := S0; 


  type T_OUTPUT is record
    sim_end : std_logic; 
    err_code : std_logic_vector(7 downto 0); 
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := ('0', (others => '0')); 

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

  next_update : process (bound_reached_term, closed_full_term, open_full_term, normal_term, state_r) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current    : T_STATE  := DEFAULT_STATE;
  begin
    current    := state_r;
    the_output := DEFAULT_OUTPUT;

    case current is 
      when S0 =>
      		if bound_reached_term = '1' then 
      			current := S_BOUND_REACHED; 
      		elsif (closed_full_term = '1') then
      			current := S_CLOSED_FULL; 
      		elsif (open_full_term = '1') then
      			current := S_OPEN_FULL; 
          elsif normal_term = '1' then 
            current := S_NORMAL_TERM; 
      		end if;        				
      when S_DEFAULT =>
      when S_NORMAL_TERM =>
        the_output.sim_end := '1'; 
        the_output.err_code := std_logic_vector(to_unsigned(1, 8));  
      when S_BOUND_REACHED =>  
        the_output.sim_end := '1'; 
        the_output.err_code := std_logic_vector(to_unsigned(2, 8)); 
      when S_CLOSED_FULL => 
        the_output.sim_end := '1'; 
        the_output.err_code := std_logic_vector(to_unsigned(3, 8)); 
      when S_OPEN_FULL => 
        the_output.sim_end := '1'; 
        the_output.err_code := std_logic_vector(to_unsigned(4, 8)); 
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
      	sim_end <= '0'; 
      	err_code <= (others => '0');
      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          --if state_c = S0 then 
          --    sim_end <= '0'; 
          --else 
          --  sim_end <= '1'; 
          --end if; 
        	--sim_end <= '0' when state_c = S0 else '1'; 
        	--err_code <= (others => '0') ; 
          sim_end   <= output_c.sim_end;
          err_code  <= output_c.err_code;

        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
		--sim_end <= '0' when state_c = S0 else '1'; 
		--err_code <= (others => '0') ; 
    sim_end   <= output_c.sim_end;
    err_code  <= output_c.err_code;
  end generate;
end architecture;