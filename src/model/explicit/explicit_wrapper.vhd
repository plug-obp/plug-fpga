
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions

use work.semantics_components_v2.all;
use work.explicit_params.all;

architecture semantics_wrapper of semantics is

begin

	semantics_inst : entity work.explicit_interpreter(b)
		generic map(
			CONFIG_WIDTH        => work.model_structure.CONFIG_WIDTH,
			HAS_OUTPUT_REGISTER => true,
			p                   => work.model_structure.AB_PARAMS,
			model               => work.model.AB_MODEL
		)
		port map(
			clk            => clk,
			reset          => reset,
			reset_n        => reset_n,
			initial_enable => initial_enable,
			next_enable    => next_enable,
			source_in      => source_in(work.model_structure.CONFIG_WIDTH - 1 downto 0),
			target_out     => target_out(work.model_structure.CONFIG_WIDTH - 1 downto 0),
			target_ready   => target_ready,
			has_next       => has_next,
			is_done        => is_done
		);

	target_out(CONFIG_WIDTH - 1 downto work.model_structure.CONFIG_WIDTH) <= (others => '0');
end semantics_wrapper;
