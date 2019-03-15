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

        start  : in std_logic;
        source_ready   : in std_logic;
        source_in       : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        target_is_known : out std_logic;
        closed_is_full  : out std_logic--;
        --has_next        : out std_logic
    );
end entity;

use WORK.mc_components.ALL;
architecture arch_v1 of mc_sem_and_closed is
    signal previous_is_added : std_logic;
    signal target : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_ready : std_logic;
    signal has_next : std_logic;    

    --computed signals
    signal initial_c, next_c : std_logic;
    --registers
    signal first_r : boolean := true;
	type T_PHASE is (S0, INIT_PHASE, NEXT_PHASE);
    signal init_phase_r : T_PHASE := S0;
begin

process (clk, reset_n) is
    procedure state_reset is
    begin
        first_r <= true;
    end;
begin
    if reset_n = '0' then
        state_reset;
    elsif rising_edge(clk) then
        if reset = '1' then
            state_reset;
        else
            if target_ready = '1' then
                first_r <= false;
            end if;
        end if;
    end if;
end process;

process (clk, reset_n, has_next) is
begin
	if reset_n = '0' then
		init_phase_r <= S0;
		initial_c <= '0';
		next_c <= '0';
	elsif rising_edge(clk) then
		case init_phase_r is
		when S0 =>
			if start = '1' then
				init_phase_r <= INIT_PHASE;
			end if;
		when INIT_PHASE =>
			if has_next = '0' and not first_r then
				init_phase_r <= NEXT_PHASE;
			end if;
			if previous_is_added = '1' or first_r then
				initial_c <= '1';
			end if;
			next_c <= '0';
		when NEXT_PHASE => 
			if previous_is_added = '1' and source_ready = '1' then
				next_c <= '1';
			end if;
			initial_c <= '0';
		end case;
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
        is_full     => closed_is_full,
		is_done    => previous_is_added
    );

--initial_c   	<= '1' when (previous_is_added = '1' or first_r) and init_phase_r = INIT_PHASE else '0';
--next_c      	<= '1' when (previous_is_added = '1' or first_r) and init_phase_r = NEXT_PHASE else '0';

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
            use entity work.set(linear_set_c);
        end for;

        for semantics_inst : work.mc_components.semantics
            use entity work.explicit_interpreter(b);
        end for;
    end for;
end configuration;