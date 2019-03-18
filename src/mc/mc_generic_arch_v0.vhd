use work.mc_components.all;
architecture arch_v0 of mc_generic is
    signal initial : std_logic;
    signal open_empty, open_full : std_logic;
    signal open_swap : std_logic := '0';
    signal closed_full, add_done: std_logic;
    signal has_next : std_logic;
    signal check_ready, check_status : std_logic;
    signal source, target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal source_ready : std_logic;
    signal target_ready : std_logic;
    signal is_known : std_logic;
    --computed signals
    signal pop_enable, push_enable : std_logic;
    signal initial_enable, next_enable : std_logic;
    signal check_enable : std_logic;
begin

pop_enable <= '1' when initial = '0' and has_next = '0' else '0';
push_enable <= '1' when is_known = '0' and add_done = '1' else '0';

open_inst : open_stream
    generic map (ADDRESS_WIDTH => OPEN_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        pop_enable  => pop_enable,
        push_enable => push_enable,
        data_in     => target,
        data_out    => source,
        data_ready  => source_ready,
        is_empty    => open_empty,
        is_full     => open_full,
        is_swapped  => open_swap
    );

closed_inst : closed_stream
    generic map (ADDRESS_WIDTH => CLOSED_ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
    port map (
        clk         => clk,
        reset       => reset,
        reset_n     => reset_n,

        add_enable  => target_ready,
        data_in     => target,
        is_in       => is_known,
        add_done    => add_done,
        is_full     => closed_full
    );

initial_enable <= '1' when initial = '1' and add_done = '1' else '0';
next_enable <= '1' when initial = '0' and source_ready = '1' and add_done = '1' else '0';

semantics_inst : semantics
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,
        
        initial_enable  => initial_enable,
        next_enable     => next_enable,
        source_in       => source,
        target_out      => target,
        target_ready    => target_ready,
        has_next        => has_next
    );

check_enable <= '1' when is_known = '0' else '0';

checker_inst : checker
    generic map (CONFIG_WIDTH => DATA_WIDTH)
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,

        check_enable    => check_enable,
        config_in       => target,
        check_ready     => check_ready,
        check_status    => check_status
    );

controler_inst : controler
    port map (
        clk             => clk,
        reset           => reset,
        reset_n         => reset_n,

        sem_has_next    => has_next,

        open_is_empty   => open_empty,
        open_is_full    => open_full,
        open_swap       => open_swap,

        closed_full     => closed_full,
        add_done        => add_done,

        check_ready     => check_ready,
        check_status    => check_status,

        start           => start,
        initialize      => initial,
        execution_ended => execution_ended,
        is_verified     => is_verified
    );
end architecture;