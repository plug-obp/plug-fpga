entity mc_sem_and_closed is 
    generic (
        DATA_WIDTH              : integer := 6;
        OPEN_ADDRESS_WIDTH      : integer := 4;
        CLOSED_ADDRESS_WIDTH    : integer := 4
    );
    port (
        initial_enable  : in std_logic;
        source_enable   : in std_logic;
        source_in       : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        target_is_known : out std_logic;
        closed_is_full  : out std_logic;
        has_next        : out std_logic
    );
end entity;

architecture arch_v1 of mc_generic is
    signal previous_is_added : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_ready : std_logic;
    
    --computed signals
    signal initial_c, next_c : std_logic;
begin

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
        add_done    => previous_is_added,
        is_full     => closed_is_full
    );

initial_c   <= '1' when previous_is_added = '1' and initial_enable = '1'                            else '0';
next_c      <= '1' when previous_is_added = '1' and initial_enable = '0' and source_enable = '1'    else '0';

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

use work.all;

configuration exhaustive_linear_set_v1 of mc_generic is
    for arch_v1
        for closed_inst : work.mc_components.closed_stream
            use entity work.set(linear_set_b);
        end for;

        for semantics_inst : work.mc_components.semantics
            use entity work.explicit_interpreter(a);
        end for;
    end for;
end configuration;