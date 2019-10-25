
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.semantics_components_v2.all; 




architecture semantics_wrapper of semantics is


begin

	semantics_inst : entity work.explicit_interpreter(b)
    generic map(
        CONFIG_WIDTH => CONFIG_WIDTH
    )
    port map (
        clk              => clk,
        reset            => reset,
        reset_n          => reset_n,
        initial_enable   => initial_enable,
        next_enable      => next_enable,
        source_in        => source_in,
        target_out       => target_out,
        target_ready     => target_ready,
        has_next         => has_next,
        is_done          => is_done
    );
end semantics_wrapper;