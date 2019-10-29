library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity next_stream is
	generic(
		CONFIG_WIDTH : integer := 6
	);
	port(
		clk             : in  std_logic; -- clock
		reset           : in  std_logic;
		reset_n         : in  std_logic;
		start           : in  std_logic;
		next_en         : in  std_logic;
		target_ready    : out std_logic;
		target_out      : out std_logic_vector(CONFIG_WIDTH - 1 downto 0);
		target_is_last  : out std_logic;
		ask_src         : out std_logic;
		s_ready         : in  std_logic;
		s_in            : in  std_logic_vector(CONFIG_WIDTH - 1 downto 0);
		s_is_last       : in  std_logic;
		is_deadlock     : out std_logic;
		----------------------------------

		i_en_next       : out std_logic;
		n_en_next       : out std_logic;
		source_next     : out std_logic_vector(CONFIG_WIDTH - 1 downto 0);
		target_out_next : in  std_logic_vector(CONFIG_WIDTH - 1 downto 0);
		t_ready_next    : in  std_logic;
		has_next_next   : in  std_logic;
		t_done_next     : in  std_logic;
		idle            : out std_logic
	);
end entity;

--use WORK.semantics_components.ALL;
--architecture a of next_stream is
--    signal t_done : std_logic;
--    signal has_next : std_logic;
--    signal i_en : std_logic;
--    signal n_en : std_logic;
--    signal t_ready : std_logic;
--    signal src_was_last_r : std_logic; 
--begin

--semantics_inst : semantics
--    generic map (CONFIG_WIDTH => CONFIG_WIDTH)
--    port map (
--        clk             => clk,
--        reset           => reset,
--        reset_n         => reset_n,

--        initial_enable  => i_en,
--        next_enable     => n_en,
--        source_in       => s_in,
--        target_out      => target_out,
--        target_ready    => t_ready,
--        has_next        => has_next,
--        is_done         => t_done
--    );

--ctrl_inst : semantics_controler
--    port map (
--        clk             => clk,
--        reset           => reset,
--        reset_n         => reset_n,
--        ask_next        => next_en,
--        t_ready         => t_ready, 
--        t_produced      => t_done,
--        has_next        => has_next,
--        s_ready         => s_ready,
--        i_en            => i_en,
--        n_en            => n_en,
--        ask_src         => ask_src,
--        is_deadlock     => is_deadlock
--    );

--process(clk, reset_n) is 
--begin
--    if reset_n = '0' then
--        src_was_last_r <= '1'; 
--    elsif rising_edge(clk) then 
--        if s_ready= '1' then 
--        src_was_last_r <= s_is_last; 
--    end if; 
--end if; 
--end process; 

--target_ready <= t_ready;
--target_is_last <= '1' when has_next = '0' and t_ready = '1' and src_was_last_r = '1' else '0'; 

--end architecture;

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

--use WORK.semantics_components_v2.ALL;

--architecture b of next_stream is 
--    signal t_done : std_logic;
--    signal has_next : std_logic;
--    signal i_en : std_logic;
--    signal n_en : std_logic;
--    signal t_ready : std_logic;
--    signal src_was_last_r : std_logic; 
--    signal source : std_logic_vector(CONFIG_WIDTH-1 downto 0); 
--begin

--semantics_inst : semantics
--    generic map (CONFIG_WIDTH => CONFIG_WIDTH)
--    port map (
--        clk             => clk,
--        reset           => reset,
--        reset_n         => reset_n,

--        initial_enable  => i_en,
--        next_enable     => n_en,
--        source_in       => source,
--        target_out      => target_out,
--        target_ready    => t_ready,
--        has_next        => has_next,
--        is_done         => t_done
--    );

--ctrl_inst : semantics_controler
--    generic map (CONFIG_WIDTH => CONFIG_WIDTH)
--    port map (
--        clk             => clk,
--        reset           => reset,
--        reset_n         => reset_n,
--        ask_next        => next_en,
--        src_in          => s_in,  -- new 
--        -- src_is_last     => s_is_last, -- new 
--        t_ready         => t_ready, 
--        t_produced      => t_done,
--        has_next        => has_next,
--        s_ready         => s_ready,
--        i_en            => i_en,
--        n_en            => n_en,
--        src_out         => source,  -- new
--        ask_src         => ask_src,
--        is_deadlock     => is_deadlock
--    );

--process(clk, reset_n) is 
--begin
--    if reset_n = '0' then
--        src_was_last_r <= '1'; 
--    elsif rising_edge(clk) then 
--        if s_ready= '1' then 
--        src_was_last_r <= s_is_last; 
--    end if; 
--end if; 
--end process; 

--target_ready <= t_ready;
--target_is_last <= '1' when has_next = '0' and t_ready = '1' and src_was_last_r = '1' else '0'; 

--end architecture; 

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------


use work.semantics_components_v2.ALL;

architecture c of next_stream is
	--signal t_done : std_logic;
	--signal has_next : std_logic;
	--signal i_en : std_logic;
	--signal n_en : std_logic;
	--signal t_ready : std_logic;
	signal src_was_last_r : std_logic;
	signal start_s        : std_logic;
	signal ask_next_s     : std_logic;
	--signal source : std_logic_vector(CONFIG_WIDTH-1 downto 0); 
begin

	--semantics_inst : semantics
	--    generic map (CONFIG_WIDTH => CONFIG_WIDTH)
	--    port map (
	--        clk             => clk,
	--        reset           => reset,
	--        reset_n         => reset_n,

	--        initial_enable  => i_en,
	--        next_enable     => n_en,
	--        source_in       => source,
	--        target_out      => target_out,
	--        target_ready    => t_ready,
	--        has_next        => has_next,
	--        is_done         => t_done
	--    );

	ctrl_inst : semantics_controler
		generic map(CONFIG_WIDTH => CONFIG_WIDTH)
		port map(
			clk         => clk,
			reset       => reset,
			reset_n     => reset_n,
			start       => start_s,
			ask_next    => ask_next_s,
			src_in      => s_in,        -- new 
			-- src_is_last     => s_is_last, -- new 
			t_ready     => t_ready_next,
			t_produced  => t_done_next,
			has_next    => has_next_next,
			s_ready     => s_ready,
			n_en        => n_en_next,
			i_en        => i_en_next,
			src_out     => source_next, -- new
			ask_src     => ask_src,
			is_deadlock => is_deadlock,
			idle        => idle
		);

	process(clk, reset_n) is
	begin
		if reset_n = '0' then
			src_was_last_r <= '1';
		elsif rising_edge(clk) then
			if s_ready = '1' then
				src_was_last_r <= s_is_last;
			end if;
		end if;
	end process;

	start_s    <= start;
	ask_next_s <= next_en or start_s;

	target_ready   <= t_ready_next;
	target_is_last <= '1' when has_next_next = '0' and t_ready_next = '1' and src_was_last_r = '1' else '0';
	target_out     <= target_out_next;

end architecture;

