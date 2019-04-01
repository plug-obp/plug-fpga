library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity next_stream is
    generic (
        CONFIG_WIDTH : integer := 6
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;

        next_en : in std_logic;
        target_ready : out std_logic;
        target_out   : out std_logic_vector(CONFIG_WIDTH-1 downto 0);
        target_is_last : out std_logic; 

        ask_src : out std_logic;
        s_ready : in std_logic;
        s_in    : in std_logic_vector(CONFIG_WIDTH-1 downto 0);
        s_is_last : in std_logic; 

        is_deadlock : out std_logic
    );
end entity;

use WORK.semantics_components.ALL;
architecture a of next_stream is
    signal t_done : std_logic;
    signal has_next : std_logic;
    signal i_en : std_logic;
    signal n_en : std_logic;
    signal t_ready : std_logic;
    signal src_was_last_r : std_logic; 
begin

semantics_inst : semantics
    generic map (CONFIG_WIDTH => CONFIG_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,
        
        initial_enable  => i_en,
        next_enable     => n_en,
        source_in       => s_in,
        target_out      => target_out,
        target_ready    => t_ready,
        has_next        => has_next,
        is_done         => t_done
    );

ctrl_inst : semantics_controler
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,
        ask_next        => next_en,
        t_ready         => t_ready, 
        t_produced      => t_done,
        has_next        => has_next,
        s_ready         => s_ready,
        i_en            => i_en,
        n_en            => n_en,
        ask_src         => ask_src,
        is_deadlock     => is_deadlock
    );

    
process(clk, reset) is 
begin
    if reset = '1' then
        src_was_last_r <= '0'; 
    elsif rising_edge(clk) then 
        if s_ready= '1' then 
        src_was_last_r <= s_is_last; 
    end if; 
end if; 
end process; 

target_ready <= t_ready;
target_is_last <= '1' when has_next = '0' and t_ready = '1' and src_was_last_r = '1' else '0'; 


end architecture;