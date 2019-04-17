library ieee; 
use ieee.std_logic_1164.all; 

architecture fifo_wrapper of fifo is 
begin

  fifo_gen: entity work.fifo_generator_0
    port map (
      clk => clk, 
      srst => reset_n, 
      din => data_in, 
      wr_en => push_enable, 
      rd_en => pop_enable, 
      dout => data_out, 
      full => is_full, 
      wr_ack => push_is_done, 
      empty => is_empty, 
      valid => data_ready
    ); 



end architecture; 

