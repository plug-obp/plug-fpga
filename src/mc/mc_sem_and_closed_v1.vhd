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
        
        closed_is_full  : out std_logic;
        is_deadlock        : out std_logic;
        open_empty  : out std_logic;
        open_full : out std_logic;
        open_swap : out std_logic
    );
end entity;

use WORK.mc_components.ALL;
architecture arch_v1 of mc_sem_and_closed is
    signal previous_is_added : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal t_ready : std_logic;
    signal has_next : std_logic; 
    signal t_produced : std_logic;  
	signal c_is_full : std_logic; 
    signal ask_push : std_logic;
    signal t_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_is_known : std_logic;
    signal s_ready : std_logic;
    signal is_scheduled : std_logic;
	signal ask_src : std_logic;
	signal source_in :std_logic_vector (DATA_WIDTH-1 downto 0);

    --computed signals
    signal i_en, n_en : std_logic;
    signal ask_next : boolean;
    signal schedule_en : std_logic;
    
    --registers
    signal first_r : boolean := true;

	type T_STATE is (S0, I_PHASE, I_MORE, I_DEADLOCK, T_END, WAIT_SRC, WAIT_REQ, SERVED_REQ, T_MORE);
    signal next_state : T_STATE := S0;
    signal current_state : T_STATE := S0;

    type T_OUTPUT is record
        i_en        : std_logic;
        n_en        : std_logic;
        ask_src     : std_logic;
        is_deadlock    : std_logic;
    end record;
    constant DEFAULT_OUTPUT : T_OUTPUT := ('0', '0', '0', '0');
    signal next_output : T_OUTPUT := DEFAULT_OUTPUT;
    
begin

closed_is_full <= c_is_full;
ask_next <= true when (c_is_full = '0' and previous_is_added = '1') or start = '1' else false;


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
    variable phase_v : T_STATE := S0;
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
            if t_produced = '1' and t_ready = '0'  then
                the_output.is_deadlock := '1';
                phase_v := I_DEADLOCK;
            else
                if t_produced = '1' and has_next = '1' then 
                    if ask_next then
                        the_output.i_en := '1';
                    else 
                        phase_v := I_MORE;
                    end if;
                elsif t_produced = '1' and has_next = '0' then
                    the_output.ask_src := '1';
                    if ask_next and s_ready = '1' then
                        the_output.n_en := '1';
                        phase_v := SERVED_REQ;
                    elsif ask_next then
                        phase_v := WAIT_SRC;
                    elsif s_ready = '1' then
                        phase_v := WAIT_REQ;
                    else
                        phase_v := T_END;
                    end if;
                end if;
            end if;
        when I_MORE     =>
            if ask_next then
                the_output.i_en := '1';
                phase_v := I_PHASE;
            end if;
        when I_DEADLOCK => null; 
        when T_END    =>
            if ask_next and s_ready = '1' then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            elsif s_ready = '1' then
                phase_v := WAIT_REQ;
            elsif ask_next then
                phase_v := WAIT_SRC;
            end if;
        when WAIT_SRC   =>
            if s_ready = '1' then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            end if;
        when WAIT_REQ   =>
            if ask_next then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            end if;
        when SERVED_REQ =>
            if t_produced = '1' and t_ready = '0'  then
                the_output.is_deadlock := '1';
                phase_v := T_END;
            else
                if t_produced = '1' and has_next = '1' then 
                    if ask_next then
                        the_output.n_en := '1';
                    else 
                        phase_v := T_MORE;
                    end if;
                elsif t_produced = '1' and has_next = '0' then
                    the_output.ask_src := '1';
                    phase_v := T_END;
                end if;
            end if;
        when T_MORE     =>
            if ask_next then
                the_output.n_en := '1';
                phase_v := SERVED_REQ;
            end if;
        end case;

        next_state <= phase_v;
        next_output <= the_output;
    end process;

--with register on controler output
--registered_output : process (clk, reset_n) is
--        procedure reset_output is
--        begin
--            i_en <= '0';
--            n_en <= '0';
--            ask_src <= '0';
--            is_deadlock <= '0';
--        end; 
--    begin
--        if reset_n = '0' then
--            reset_output;
--        elsif rising_edge(clk) then
--            if reset = '1' then
--                reset_output;
--            else
--                i_en <= next_output.i_en;
--				n_en <= next_output.n_en;
--				ask_src <= next_output.ask_src;
--				is_deadlock <= next_output.is_deadlock;
--            end if;
--        end if;
--    end process;
--
--without register on the controler output
i_en <= next_output.i_en;
n_en <= next_output.n_en;
ask_src <= next_output.ask_src;
is_deadlock <= next_output.is_deadlock;


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
        is_full     => c_is_full,
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

schedule_en <= '1' when previous_is_added = '1' and target_is_known = '0' else '0'; 
sched_inst : scheduler
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,

        t_ready         => t_ready,
        schedule_en     => schedule_en,
        is_scheduled    => is_scheduled,

        t_in            => target,

        ask_push        => ask_push,
        t_out           => t_out
    );

open_inst : open_stream
    generic map (ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        pop_enable  => ask_src,
        push_enable => ask_push,
        data_in     => t_out,
        push_is_done=> is_scheduled,
		pop_is_done	=> s_ready,
        data_out    => source_in,
        data_ready  => s_ready,
        is_empty    => open_empty,
        is_full     => open_full,
        is_swapped  => open_swap
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

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a);
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.fifo(c);
        end for;
    end for;
end configuration;