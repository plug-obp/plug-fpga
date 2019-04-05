library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mc_top_v1 is 
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
        
        closed_full  : out std_logic;
        is_deadlock        : out std_logic;
        open_empty  : out std_logic;
        open_full : out std_logic;
        open_swap : out std_logic
    );
end entity;

use WORK.mc_components.ALL;
architecture mc_top_v1_a of mc_top_v1 is
    signal previous_is_added : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal t_ready : std_logic;
    signal t_is_last : std_logic; 
	signal c_is_full : std_logic; 
    signal ask_push : std_logic;
    signal t_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_is_known : std_logic;
    signal s_ready : std_logic;
    signal is_scheduled : std_logic;
	signal ask_src : std_logic;
	signal source_in :std_logic_vector (DATA_WIDTH-1 downto 0);
    signal swap : std_logic; 
    signal src_is_last : std_logic; 
    --computed signals
    signal ask_next : std_logic;
    signal schedule_en : std_logic;

    -- added signals : 
    signal open_is_empty : std_logic; 
    signal pop_en : std_logic; 
    
begin

closed_full <= c_is_full;
ask_next <= '1' when (c_is_full = '0' and previous_is_added = '1') or start = '1' else '0';
open_empty <= open_is_empty; 

pop_ctrl_inst : pop_controler 
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        open_is_empty => open_is_empty, 
        ask_src => ask_src,
        pop_en => pop_en
    ); 


--TODO: should be renamed to closed_set
closed_inst : closed_stream 
    generic map (ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,
	clear_table => t_is_last,
        add_enable  => t_ready,
        data_in     => target,
        is_in       => target_is_known,
        is_full     => c_is_full,
		is_done    => previous_is_added
    );

next_inst : next_stream
    generic map (
        CONFIG_WIDTH => DATA_WIDTH
    )
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        next_en     => ask_next,
        target_ready => t_ready,
        target_out   => target,
        target_is_last => t_is_last, 

        ask_src     => ask_src,
        s_ready     => s_ready,
        s_in        => source_in,
        s_is_last   => src_is_last,
        is_deadlock => is_deadlock
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
        t_is_last       => t_is_last,

        ask_push        => ask_push,
        t_out           => t_out, 
        mark_last       => swap
    );

open_inst : open_stream
    generic map (ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        pop_enable  => pop_en,
        push_enable => ask_push,
        data_in     => t_out,
        mark_last   => swap, 
        push_is_done=> is_scheduled,
        data_out    => source_in,
        data_ready  => s_ready,
        is_empty    => open_is_empty,
        is_full     => open_full,
        is_last     => src_is_last, 
        is_swapped  => open_swap
    );


end architecture;


library ieee; 
use ieee.numeric_std.all; 
use WORK.mc_components.ALL;
architecture mc_top_v1_b of mc_top_v1 is
    signal previous_is_added : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal t_ready : std_logic;
    signal t_is_last : std_logic; 
    signal c_is_full : std_logic; 
    signal ask_push : std_logic;
    signal t_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_is_known : std_logic;
    signal s_ready : std_logic;
    signal is_scheduled : std_logic;
    signal ask_src : std_logic;
    signal source_in :std_logic_vector (DATA_WIDTH-1 downto 0);
    signal swap : std_logic; 
    signal src_is_last : std_logic; 
    --computed signals
    signal ask_next : std_logic;
    signal schedule_en : std_logic;

    -- added signals : 
    signal open_is_empty : std_logic; 
    signal pop_en : std_logic; 
    signal bound_is_reached : std_logic; 
    signal open_is_full : std_logic; 

begin

closed_full <= c_is_full;
ask_next <= '1' when (c_is_full = '0' and previous_is_added = '1') or start = '1' else '0';
open_empty <= open_is_empty; 
open_full <= open_is_full; 

pop_ctrl_inst : pop_controler 
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        open_is_empty => open_is_empty, 
        ask_src => ask_src,
        pop_en => pop_en
    ); 


--TODO: should be renamed to closed_set
closed_inst : closed_stream 
    generic map (ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,
        clear_table => t_is_last,
        add_enable  => t_ready,
        data_in     => target,
        is_in       => target_is_known,
        is_full     => c_is_full,
        is_done    => previous_is_added
    );

next_inst : next_stream
    generic map (
        CONFIG_WIDTH => DATA_WIDTH
    )
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        next_en     => ask_next,
        target_ready => t_ready,
        target_out   => target,
        target_is_last => t_is_last, 

        ask_src     => ask_src,
        s_ready     => s_ready,
        s_in        => source_in,
        s_is_last   => src_is_last,
        is_deadlock => is_deadlock
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
        t_is_last       => t_is_last,

        ask_push        => ask_push,
        t_out           => t_out, 
        mark_last       => swap
    );

open_inst : open_stream
    generic map (ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        pop_enable  => pop_en,
        push_enable => ask_push,
        data_in     => t_out,
        mark_last   => swap, 
        push_is_done=> is_scheduled,
        data_out    => source_in,
        data_ready  => s_ready,
        is_empty    => open_is_empty,
        is_full     => open_full,
        is_last     => src_is_last, 
        is_swapped  => open_swap
    );



    term_chker_inst : terminaison_checker 
	generic map ( HAS_OUTPUT_REGISTER => false)
        port map (
            clk => clk, 
            reset           => reset,
            reset_n         => reset_n,
            t_is_last       => t_is_last,
            open_is_empty   => open_is_empty,
            open_is_full    => open_is_full, 
            closed_is_full  => c_is_full
        ); 


end architecture;

