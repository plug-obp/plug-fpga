library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mc_sem_and_closed is 
    generic (
        DATA_WIDTH              : integer := 6;
        OPEN_ADDRESS_WIDTH      : integer := 4;
        CLOSED_ADDRESS_WIDTH    : integer := 4
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        start           : in std_logic;
        s_ready         : in std_logic;  -- source ready from the fifo
        source_in       : in std_logic_vector (DATA_WIDTH - 1 downto 0);

        ask_src         : out std_logic; -- source enable request towards fifo
        target_is_known : out std_logic;
        closed_is_full  : out std_logic;
        deadlock        : out std_logic
    );
end entity;

use WORK.mc_components.ALL;
architecture arch_v1 of mc_sem_and_closed is
    signal previous_is_added : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal t_ready : std_logic;
    signal has_next : std_logic; 
    signal t_produced : std_logic;   

    --computed signals
    signal i_en, n_en : std_logic;
    signal ask_next : boolean;
    
    --registers
    signal first_r : boolean := true;

	type T_STATE is (S0, I_PHASE, I_MORE, I_DEADLOCK, T_END, WAIT_SRC, WAIT_REQ, SERVED_REQ, T_MORE);
    signal next_state : T_STATE := S0;
    signal current_state : T_STATE := S0;

    type T_OUTPUT is record
        i_en        : std_logic;
        n_en        : std_logic;
        ask_src     : std_logic;
        deadlock    : std_logic;
    end record;
    constant DEFAULT_OUTPUT : T_OUTPUT := ('0', '0', '0', '0');
    signal next_output : T_OUTPUT := DEFAULT_OUTPUT;
    
begin

ask_next <= true when (closed_is_full = '0' and previous_is_added = '1') or start = '1' else '0';

state_update : process (clk, reset_n) is
    begin
        if reset_n = '0' then
            current_state <= S0;
        elsif rising_edge(clk) then
            if reset = '1' then
                current_state <= S0;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

next_update : process (ask_next, t_ready, t_produced, has_next, s_ready, current_state) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable phase_v : T_PHASE := S0;
    begin
        phase_v := current_state;
        the_output := DEFAULT_OUTPUT;

        case phase_v is
        when S0 =>
            if ask_next then
                the_output.i_en := '1';
                phase_v := I_PHASE;
            end if;
        when I_PHASE =>
            if t_produced = '1' and t_ready = '0' and  then
                the_output.deadlock := '1';
                phase_v := DEADLOCK;
            else
                if t_produced = '1' and has_next = '1' then 
                    if ask_next then
                        the_output.i_en := '1';
                    else 
                        phase_v := I_MORE;
                    end if;
                elsif t_produced = '1' and has_next = '0' then
                    the_output.ask_src := '1'
                    if ask_next and s_ready then
                        the_output.n_en := '1';
                        phase_v := SERVED_REQ;
                    elsif ask_next then
                        phase_v := WAIT_SRC;
                    elsif s_ready then
                        phase_v := WAIT_REQ;
                    else
                        phase_v := T_END;
                    end if;
                end if;
            end if;
        case I_MORE     =>
            if ask_next then
                the_output.i_en := '1';
                phase_v := I_PHASE;
            end if;
        case I_DEADLOCK => null; 
        case T_END    =>
            if ask_next and s_ready then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            elsif s_ready then
                phase_v := WAIT_REQ;
            elsif ask_next then
                phase_v := WAIT_SRC;
            end if;
        case WAIT_SRC   =>
            if s_ready = '1' then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            end if;
        case WAIT_REQ   =>
            if ask_next = '1' then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            end if;
        case SERVED_REQ =>
            if t_produced = '1' and t_ready = '0' and  then
                the_output.deadlock := '1';
                phase_v := T_END;
            else
                if t_produced = '1' and has_next = '1' then 
                    if ask_next then
                        the_output.n_en := '1';
                    else 
                        phase_v := T_MORE;
                    end if;
                elsif t_produced = '1' and has_next = '0' then
                    the_output.ask_src := '1'
                    phase_v := T_END;
                end if;
            end if;
        case T_MORE     =>
            if ask_next then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            end if;
        end case;

        next_state <= phase_v;
        next_output <= the_output;
    end process;

--with register on controler output
--(i_en, n_en, ask_src, deadlock) <= (next_output.i_en, next_output.n_en, next_output.ask_src, next_output.deadlock) when rising_edge(clk) else (others => '0');

--without register on the controler output
(i_en, n_en, ask_src, deadlock) <= (next_output.i_en, next_output.n_en, next_output.ask_src, next_output.deadlock);

--TODO: should be renamed to closed_set
closed_inst : closed_stream 
    generic map (ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        add_enable  => t_ready,
        data_in     => target,
        is_in       => target_is_known,
        is_full     => closed_is_full,
		is_done    => previous_is_added
    );

semantics_inst : semantics
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,
        
        initial_enable  => i_en,
        next_enable     => n_en,
        source_in       => source_in,
        target_out      => target,
        target_ready    => t_ready,
        has_next        => has_next,
        is_done         => t_produced
    );
end architecture;

use WORK.ALL;
configuration exhaustive_linear_set_v1 of mc_sem_and_closed is
    for arch_v1
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_c);
        end for;

        for semantics_inst : work.mc_components.semantics
            use entity work.explicit_interpreter(b);
        end for;
    end for;
end configuration;