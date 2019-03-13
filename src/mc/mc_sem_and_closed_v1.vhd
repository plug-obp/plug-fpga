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

        initial_enable  : in std_logic;
        source_enable   : in std_logic;
        source_in       : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        target_is_known : out std_logic;
        closed_is_full  : out std_logic;
        has_next        : out std_logic
    );
end entity;

use WORK.mc_components.ALL;
architecture arch_v1 of mc_sem_and_closed is
    signal previous_is_added_c : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_ready : std_logic;
    
    --computed signals
    signal initial_c, next_c : std_logic;

    --registers
    signal previous_is_added_r : std_logic := '1';
begin

process (clk, reset_n) is
    procedure state_reset is
    begin
        previous_is_added_r <= '1';
    end;
begin
    if reset_n = '0' then
        state_reset;
    elsif rising_edge(clk) then
        if reset = '1' then
            state_reset;
        else
            previous_is_added_r <= previous_is_added_c;
        end if;
    end if;
end process;

--TODO: should be renamed to closed_set
closed_inst : closed_stream 
    generic map (ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        add_enable  => target_ready,
        data_in     => target,
        is_in       => target_is_known,
        add_done    => previous_is_added_c,
        is_full     => closed_is_full
    );

initial_c   <= '1' when previous_is_added_r = '1' and initial_enable = '1'                            else '0';
next_c      <= '1' when previous_is_added_r = '1' and initial_enable = '0' and source_enable = '1'    else '0';

semantics_inst : semantics
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,
        
        initial_enable  => initial_c,
        next_enable     => next_c,
        source_in       => source_in,
        target_out      => target,
        target_ready    => target_ready,
        has_next        => has_next
    );
end architecture;

use WORK.ALL;
configuration exhaustive_linear_set_v1 of mc_sem_and_closed is
    for arch_v1
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_b);
        end for;

        for semantics_inst : work.mc_components.semantics
            use entity work.explicit_interpreter(a);
        end for;
    end for;
end configuration;