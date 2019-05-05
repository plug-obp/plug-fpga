library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std_unsigned.all; 


architecture pingpong_fifo_controler_a of open_controler is
 -- constant HAS_OUTPUT_REGISTER : boolean := false;
  constant CAPACITY            : integer := 2**ADDR_WIDTH;
  type T_STATE is record
    read_ptr    : std_logic_vector(ADDR_WIDTH-1 downto 0); --integer range 0 to CAPACITY-1;
    write_ptr   : std_logic_vector(ADDR_WIDTH-1 downto 0); --integer range 0 to CAPACITY-1;
    barrier_ptr : std_logic_vector(ADDR_WIDTH-1 downto 0); --integer range 0 to CAPACITY-1;
    full        : boolean;
    empty       : boolean;
  end record;
  constant DEFAULT_STATE : T_STATE := ((others => '0'), (others => '0'), (others => '0'), false, true);

  type T_OUTPUT is record
    -- global I/Os

    data_out     : std_logic_vector(DATA_WIDTH- 1 downto 0);  -- the data that is read if read_enable 
    data_ready   : std_logic; 
    is_empty     : std_logic; 
    is_full      : std_logic; 
    is_last      : std_logic; 
    pop_is_done  : std_logic; 
    push_is_done : std_logic; 
    is_swapped   : std_logic;

    rf_c_r       : std_logic; 
    rf_c_w       : std_logic; 
    rf_c_w_data  : std_logic_vector(DATA_WIDTH -1 downto 0);  
    rf_c_w_addr  : std_logic_vector(ADDR_WIDTH -1 downto 0);  
    rf_c_r_addr  : std_logic_vector(ADDR_WIDTH -1 downto 0);

  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT :=  ( (others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), (others => '0')); 


  --next state
  signal state_c  : T_STATE  := DEFAULT_STATE;
  signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

  --registers
  signal state_r : T_STATE := DEFAULT_STATE;





begin

  state_update : process (clk, reset_n) is
  begin
    if reset_n = '0' then

      state_r <= DEFAULT_STATE;
    elsif rising_edge(clk) then
      if reset = '1' then
        state_r <= DEFAULT_STATE;
      else
        state_r <= state_c;
      end if;
    end if;
  end process;

  next_update : process (pop_enable, push_enable, data_in, state_r) is
    variable o : T_OUTPUT := DEFAULT_OUTPUT;
    variable c : T_STATE  := DEFAULT_STATE;
  procedure readAt (variable addr : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    variable ouput_var : inout T_OUTPUT) is 
  begin
        ouput_var.rf_c_r := '1'; 
        ouput_var.rf_c_r_addr :=  addr; 
  end procedure;


  procedure writeAt 
    (variable addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
     signal data : in std_logic_vector(DATA_WIDTH-1 downto 0); 
    variable ouput_var : inout T_OUTPUT) is 
  begin
        ouput_var.rf_c_w := '1'; 
        ouput_var.rf_c_w_addr :=  addr; 
        ouput_var.rf_c_w_data := data;   
  end procedure;


  begin
    c := state_r;
    o := DEFAULT_OUTPUT;

    if mark_last = '1' and push_enable = '1' and pop_enable = '1' then
      
      writeAt(c.write_ptr, data_in, o); 
      --c.memory(c.write_ptr) := data_in;

      c.barrier_ptr         := c.write_ptr;
      c.write_ptr           := (c.write_ptr + 1) mod CAPACITY;

      readAt(c.read_ptr, o); 
      --o.data_out            := c.memory(c.read_ptr);

      c.read_ptr            := (c.read_ptr + 1) mod CAPACITY;
      o.data_ready          := '1';
      if c.read_ptr = c.barrier_ptr then
        o.is_last := '1';
      end if;
      o.pop_is_done  := '1';
      o.push_is_done := '1';


    elsif push_enable = '1' and pop_enable = '1' then
      
      writeAt(c.write_ptr, data_in, o); 
      --c.memory(c.write_ptr) := data_in;
      
      c.write_ptr           := (c.write_ptr + 1) mod CAPACITY;

      readAt(c.read_ptr, o); 
      --o.data_out            := c.memory(c.read_ptr);
      
      c.read_ptr            := (c.read_ptr + 1) mod CAPACITY;
      o.data_ready          := '1';
      if c.read_ptr = c.barrier_ptr then
        o.is_last := '1';
      end if;
      o.pop_is_done  := '1';
      o.push_is_done := '1';



    elsif mark_last = '1' and push_enable = '1' and not c.full then
      
      writeAt(c.write_ptr, data_in, o); 
      --c.memory(c.write_ptr) := data_in;
      
      c.barrier_ptr         := c.write_ptr;
      c.empty               := false;
      o.push_is_done        := '1';
      c.write_ptr           := (c.write_ptr + 1) mod CAPACITY;

      if c.read_ptr = c.write_ptr then
        c.full := true;
      end if;
    elsif push_enable = '1' and not c.full then
      
      writeAt(c.write_ptr, data_in, o);
      --c.memory(c.write_ptr) := data_in;
      
      c.empty               := false;
      o.push_is_done        := '1';
      c.write_ptr           := (c.write_ptr + 1) mod CAPACITY;

      if c.read_ptr = c.write_ptr then
        c.full := true;
      end if;

    elsif mark_last = '1' and (pop_enable = '1' and not c.empty) then
      
      readAt(c.read_ptr, o); 
      --o.data_out    := c.memory(c.read_ptr);
      
      o.data_ready  := '1';
      c.full        := false;
      o.pop_is_done := '1';
      c.barrier_ptr := c.write_ptr - 1;
      if c.read_ptr = c.barrier_ptr then
        o.is_last := '1';
      end if;

      c.read_ptr := (c.read_ptr + 1) mod CAPACITY;

      if c.read_ptr = c.write_ptr then
        c.empty := true;
      end if;

    elsif (pop_enable = '1' and not c.empty) then
      
      readAt(c.read_ptr, o); 
      --o.data_out    := c.memory(c.read_ptr);
      
      o.data_ready  := '1';
      c.full        := false;
      o.pop_is_done := '1';
      if c.read_ptr = c.barrier_ptr then
        o.is_last := '1';
      end if;

      c.read_ptr := (c.read_ptr + 1) mod CAPACITY;

      if c.read_ptr = c.write_ptr then
        c.empty := true;
      end if;

    elsif mark_last = '1' then
      c.barrier_ptr := c.write_ptr - 1;
    end if;


    o.is_empty := '1' when c.empty else '0';
    o.is_full  := '1' when c.full  else '0';

    --set the state_c
    state_c  <= c;
    --set the outputs
    output_c <= o;
  end process;



--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------



  out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
      procedure reset_output is
      begin
        data_out <= (others => '0'); 
        data_ready <= '0'; 
        is_empty <= '0'; 
        is_full <= '0'; 
        is_last <= '0'; 
        pop_is_done <= '0'; 
        push_is_done <= '0'; 
        is_swapped <= '0'; 
        rf_c_r <= '0'; 
        rf_c_w <= '0'; 
        rf_c_w_data <= (others => '0'); 
        rf_c_w_addr <= (others => '0'); 
        rf_c_r_addr <= (others => '0'); 


      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          data_out <= output_c.data_out; 
          data_ready <= output_c.data_ready; 
          is_empty <= output_c.is_empty; 
          is_full <= output_c.is_full; 
          is_last <= output_c.is_last; 
          pop_is_done <= output_c.pop_is_done; 
          push_is_done <= output_c.push_is_done;
          is_swapped <= output_c.is_swapped;  
          rf_c_r <= output_c.rf_c_r; 
          rf_c_w <= output_c.rf_c_w; 
          rf_c_w_data <= output_c.rf_c_w_data; 
          rf_c_w_addr <= output_c.rf_c_w_addr; 
          rf_c_r_addr <= output_c.rf_c_r_addr; 

        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
      data_out <= output_c.data_out; 
      data_ready <= output_c.data_ready; 
      is_empty <= output_c.is_empty; 
      is_full <= output_c.is_full; 
      is_last <= output_c.is_last; 
      pop_is_done <= output_c.pop_is_done; 
      push_is_done <= output_c.push_is_done;
      is_swapped <= output_c.is_swapped;  
      rf_c_r <= output_c.rf_c_r; 
      rf_c_w <= output_c.rf_c_w; 
      rf_c_w_data <= output_c.rf_c_w_data; 
      rf_c_w_addr <= output_c.rf_c_w_addr; 
      rf_c_r_addr <= output_c.rf_c_r_addr; 
  end generate;
end architecture;
