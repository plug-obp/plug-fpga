library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
    -- Tres crado : clk pour exciter le process de l'automate, 


entity pop_controler is 
    generic (
        HAS_OUTPUT_REGISTER : boolean := false
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        open_is_empty : in std_logic; 
        ask_src : in std_logic; 
        pop_en : out std_logic
    );
end entity;

architecture a of pop_controler is
type T_CONTROL is (
        S0, W, ERR
    );

    type T_STATE is record
        ctrl_state  : T_CONTROL;
    end record;
    constant DEFAULT_STATE : T_STATE := (ctrl_state => S0);

    type T_OUTPUT is record
        pop: std_logic;
    end record;
    constant DEFAULT_OUTPUT : T_OUTPUT := (pop => '0');
    
    --next state
    signal state_c : T_STATE :=  DEFAULT_STATE;
    signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

    --registers
    signal state_r : T_STATE :=  DEFAULT_STATE;
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

next_update : process (ask_src, open_is_empty, clk) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current : T_STATE := DEFAULT_STATE;
begin
    current := state_r;
	the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
    when S0   =>
        if (ask_src = '1' and open_is_empty = '0') then 
            the_output.pop := '1';  
        elsif (ask_src = '1' and open_is_empty = '1' ) then 
            the_output.pop := '0'; 
            current.ctrl_state := W; 
        end if; 
    when W =>
        if open_is_empty = '0' then
            the_output.pop := '1'; 
            current.ctrl_state := S0; 
        elsif ask_src = '1' then 
            current.ctrl_state := ERR; 
            
        end if; 
    when ERR  => null;
    end case;

    --set the state_c
    state_c <= current;
    --set the outputs
    output_c <= the_output;
end process;

out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
        procedure reset_output is
        begin
            pop_en <= '0';
        end; 
    begin
        if reset_n = '0' then
            reset_output;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_output;
            else
				pop_en <= output_c.pop;
            end if;
        end if;
    end process;
end generate;

no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
	pop_en <= output_c.pop;
end generate;

end architecture;

