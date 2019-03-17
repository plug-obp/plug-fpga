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
begin

closed_is_full <= c_is_full;
ask_next <= true when (c_is_full = '0' and previous_is_added = '1') or start = '1' else false;


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

next_inst : next_stream
    generic map (
        CONFIG_WIDTH => DATA_WIDTH
    );
    port (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        next_en     => ask_next,
        target_ready => t_ready,
        target_out   => target,

        ask_src     => ask_src,
        s_ready     => s_ready,
        s_in        => source_in,
        
        is_deadlock => is_deadlock
    );
end entity;

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

        for next_inst : work.mc_components.next_stream
            use entity work.next_stream(a);
        end for;

        for sched_inst : work.mc_components.scheduler
            use entity work.scheduler(a);
        end for;

        for open_inst : work.mc_components.open_stream
            use entity work.fifo(c);
        end for;
    end for;
end configuration;