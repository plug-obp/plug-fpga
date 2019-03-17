library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scheduler is 
    generic (
        CONFIG_WIDTH : integer := 6;
        HAS_OUTPUT_REGISTER : boolean := true
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        t_ready : in std_logic;
        schedule_en : in std_logic;
        is_scheduled : in std_logic;

        t_in : in std_logic_vector(CONFIG_WIDTH-1 downto 0);

        ask_push : out std_logic;
        t_out : out std_logic_vector(CONFIG_WIDTH-1 downto 0)
    );
end entity;

architecture a of scheduler is
type T_CONTROL is (
        S0, T_OK, S_OK, ERR
    );
    type T_STATE is record
        ctrl_state  : T_CONTROL;
        target      : std_logic_vector(CONFIG_WIDTH-1 downto 0);
    end record;
    constant DEFAULT_STATE : T_STATE := (S0, (others => '0'));

    type T_OUTPUT is record
        ask_push : std_logic;
        t_out : std_logic_vector(CONFIG_WIDTH-1 downto 0);
    end record;
    constant DEFAULT_OUTPUT : T_OUTPUT := ('0', (others => '0'));
    
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

next_update : process (t_ready, schedule_en, is_scheduled, state_r) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current : T_STATE := DEFAULT_STATE;
begin
    current := state_r;
	the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
    when S0   =>
        if t_ready = '1' and schedule_en = '1' and is_scheduled = '1' then
            the_output.ask_push := '1';
            the_output.t_out := t_in;
            current.target := t_in;
        elsif schedule_en = '1' or is_scheduled = '1' then
            current.ctrl_state := ERR;
        elsif t_ready = '1' and schedule_en = '1' then
            the_output.ask_push := '1';
            the_output.t_out := t_in;
            current.target := t_in;
            current.ctrl_state := S_OK;
        elsif t_ready = '1' then
            current.target := t_in;
            current.ctrl_state := T_OK;
        end if;
    when T_OK => 
        if t_ready = '1' and schedule_en = '1' and is_scheduled = '1' then
            the_output.ask_push := '1';
            the_output.t_out := current.target;
            current.target := t_in;
        elsif (t_ready = '1' or is_scheduled = '1') and schedule_en = '0' then
            current.ctrl_state := ERR;
        elsif schedule_en = '1' and is_scheduled = '1' then
            the_output.ask_push := '1';
            the_output.t_out := current.target;
            current.ctrl_state := S0;
        elsif schedule_en = '1' then 
            the_output.ask_push := '1';
            the_output.t_out := current.target;
            current.ctrl_state := S_OK;
        end if;
    when S_OK =>
        if t_ready = '1' and schedule_en = '1' and is_scheduled = '1' then
            the_output.ask_push := '1';
            the_output.t_out := current.target;
            current.target := t_in;
        elsif (t_ready = '1' or schedule_en = '1') and is_scheduled = '0' then
            current.ctrl_state := ERR;
        elsif t_ready = '1' and is_scheduled = '1' then
            current.target := t_in;
            current.ctrl_state := T_OK;
        elsif is_scheduled = '1' then
            current.ctrl_state := S0;
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
            ask_push <= '0';
            t_out <= (others => '0');
        end; 
    begin
        if reset_n = '0' then
            reset_output;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_output;
            else
				ask_push <= output_c.ask_push;
            t_out <= output_c.t_out;
            end if;
        end if;
    end process;
end generate;

no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
    ask_push <= output_c.ask_push;
    t_out <= output_c.t_out;
end generate;

end architecture;