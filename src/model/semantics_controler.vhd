library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity semantics_controler is
  generic (
    HAS_OUTPUT_REGISTER : boolean := true
    );
  port (
    clk         : in  std_logic;        -- clock
    reset       : in  std_logic;
    reset_n     : in  std_logic;
    ask_next    : in  std_logic;
    t_ready     : in  std_logic;
    t_produced  : in  std_logic;
    has_next    : in  std_logic;
    s_ready     : in  std_logic;
    i_en        : out std_logic;
    n_en        : out std_logic;
    ask_src     : out std_logic;
    is_deadlock : out std_logic
    );
end entity;

architecture a of semantics_controler is
  type T_STATE is (S0, I_PHASE, I_MORE, I_DEADLOCK, T_END, WAIT_SRC, WAIT_REQ, SERVED_REQ, T_MORE);
  signal next_state    : T_STATE := S0;
  signal current_state : T_STATE := S0;

  type T_OUTPUT is record
    i_en        : std_logic;
    n_en        : std_logic;
    ask_src     : std_logic;
    is_deadlock : std_logic;
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := ('0', '0', '0', '0');
  signal next_output      : T_OUTPUT := DEFAULT_OUTPUT;
begin
  state_update : process (clk, reset_n) is
  begin
    if reset_n = '0' then
      current_state <= S0;
    elsif rising_edge(clk) then
      if reset = '1' then
        current_state <= S0;
      else
        current_state <= next_state;
      end if;
    end if;
  end process;

  next_update : process (clk, ask_next, t_ready, t_produced, has_next, s_ready, current_state) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable phase_v    : T_STATE  := S0;
  begin
    phase_v    := current_state;
    the_output := DEFAULT_OUTPUT;

    case phase_v is
      when S0 =>
        if ask_next = '1' then
          the_output.i_en := '1';
          phase_v         := I_PHASE;
        end if;
      when I_PHASE =>
        if t_produced = '1' and t_ready = '0' then
          the_output.is_deadlock := '1';
          phase_v                := I_DEADLOCK;
        else
          if t_produced = '1' and has_next = '1' then
            if ask_next = '1' then
              the_output.i_en := '1';
            else
              phase_v := I_MORE;
            end if;
          elsif t_produced = '1' and has_next = '0' then
            the_output.ask_src := '1';
            if ask_next = '1' and s_ready = '1' then
              the_output.n_en := '1';
              phase_v         := SERVED_REQ;
            elsif ask_next = '1' then
              phase_v := WAIT_SRC;
            elsif s_ready = '1' then
              phase_v := WAIT_REQ;
            else
              phase_v := T_END;
            end if;
          end if;
        end if;
      when I_MORE =>
        if ask_next = '1' then
          the_output.i_en := '1';
          phase_v         := I_PHASE;
        end if;
      when I_DEADLOCK => null;
      when T_END =>
        if ask_next = '1' and s_ready = '1' then
          the_output.n_en := '1';
          phase_v         := SERVED_REQ;
        elsif s_ready = '1' then
          phase_v := WAIT_REQ;
        elsif ask_next = '1' then
          phase_v := WAIT_SRC;
        end if;
      when WAIT_SRC =>
        if s_ready = '1' then
          the_output.n_en := '1';
          phase_v         := SERVED_REQ;
        end if;
      when WAIT_REQ =>
        if ask_next = '1' then
          the_output.n_en := '1';
          phase_v         := SERVED_REQ;
        end if;
      when SERVED_REQ =>
        if t_produced = '1' and t_ready = '0' then
          the_output.is_deadlock := '1';
          phase_v                := T_END;
        else
          if t_produced = '1' and has_next = '1' then
            if ask_next = '1' then
              the_output.n_en := '1';
            else
              phase_v := T_MORE;
            end if;
          elsif t_produced = '1' and has_next = '0' then
            the_output.ask_src := '1';
            phase_v            := T_END;
          end if;
        end if;
      when T_MORE =>
        if ask_next = '1' then
          the_output.n_en := '1';
          phase_v         := SERVED_REQ;
        end if;
    end case;

    next_state  <= phase_v;
    next_output <= the_output;
  end process;

  --with register on controler output
  out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
      procedure reset_output is
      begin
        i_en        <= '0';
        n_en        <= '0';
        ask_src     <= '0';
        is_deadlock <= '0';
      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          i_en        <= next_output.i_en;
          n_en        <= next_output.n_en;
          ask_src     <= next_output.ask_src;
          is_deadlock <= next_output.is_deadlock;
        end if;
      end if;
    end process;
  end generate;

--without register on the controler output
  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
    i_en        <= next_output.i_en;
    n_en        <= next_output.n_en;
    ask_src     <= next_output.ask_src;
    is_deadlock <= next_output.is_deadlock;
  end generate;

end architecture;


---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity semantics_controler_v2 is
  generic (
    HAS_OUTPUT_REGISTER : boolean := true;
    CONFIG_WIDTH        : integer := 6
    );
  port (
    clk         : in  std_logic;        -- clock
    reset       : in  std_logic;
    reset_n     : in  std_logic;
    ask_next    : in  std_logic;
    src_in      : in  std_logic_vector(CONFIG_WIDTH-1 downto 0);
    -- src_is_last : in  std_logic; 
    t_ready     : in  std_logic;
    t_produced  : in  std_logic;
    has_next    : in  std_logic;
    s_ready     : in  std_logic;
    i_en        : out std_logic;
    n_en        : out std_logic;
    src_out     : out std_logic_vector(CONFIG_WIDTH-1 downto 0);
    ask_src     : out std_logic;
    is_deadlock : out std_logic
    );
end entity;


















library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



architecture b of semantics_controler_v2 is

  type T_CONTROL is (S0, I_PHASE, I_MORE, I_DEADLOCK, T_END, WAIT_SRC, WAIT_REQ, SERVED_REQ, T_MORE);

  type T_CONFIG is record
    data    : std_logic_vector(CONFIG_WIDTH-1 downto 0);
    is_last : std_logic;
  end record;


  type T_STATE is record
    ctrl_state : T_CONTROL;
    source     : std_logic_vector(CONFIG_WIDTH-1 downto 0);
    is_last    : std_logic;
  end record;
  constant DEFAULT_STATE : T_STATE := (S0, (others => '0'), '0');


  type T_OUTPUT is record
    i_en        : std_logic;
    n_en        : std_logic;
    src_out     : std_logic_vector(CONFIG_WIDTH-1 downto 0);
    ask_src     : std_logic;
    is_deadlock : std_logic;
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := ('0', '0', (others => '0'), '0', '0');

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

  next_update : process (src_in, ask_next, t_ready, t_produced, has_next, s_ready, state_r) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current    : T_STATE  := DEFAULT_STATE;
  begin
    current    := state_r;
    the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
      when S0 =>
        if ask_next = '1' then
          the_output.i_en       := '1';
          current.ctrl_state    := I_PHASE;
        end if;
      when I_PHASE =>
        if t_produced = '1' and t_ready = '0' then
          the_output.is_deadlock    := '1';
          current.ctrl_state        := I_DEADLOCK;
        else
          if t_produced = '1' and has_next = '1' then
            if ask_next = '1' then
              the_output.i_en := '1';
            else
              current.ctrl_state    := I_MORE;
            end if;
          elsif t_produced = '1' and has_next = '0' then
            the_output.ask_src := '1';
            if ask_next = '1' and s_ready = '1' then
              the_output.n_en := '1';
              current.ctrl_state    := SERVED_REQ;
            elsif ask_next = '1' then
              current.ctrl_state := WAIT_SRC;
            elsif s_ready = '1' then
              current.ctrl_state := WAIT_REQ;
            else
              current.ctrl_state := T_END;
            end if;
          end if;
        end if;
      when I_MORE =>
        if ask_next = '1' then
          the_output.i_en := '1';
          current.ctrl_state         := I_PHASE;
        end if;
      when I_DEADLOCK => null;
      when T_END =>
        if ask_next = '1' and s_ready = '1' then
          the_output.src_out := src_in; 
          current.source := src_in; 

          the_output.n_en := '1';
          current.ctrl_state         := SERVED_REQ;
        elsif s_ready = '1' then
          current.ctrl_state := WAIT_REQ;
          current.source := src_in; 

        elsif ask_next = '1' then
          current.ctrl_state := WAIT_SRC;
        end if;
      when WAIT_SRC =>
        if s_ready = '1' then
          the_output.n_en := '1';
          the_output.src_out := src_in; 
          current.source := src_in; 
          current.ctrl_state         := SERVED_REQ;
        end if;
      when WAIT_REQ =>
        if ask_next = '1' then
          the_output.src_out := current.source; 
          the_output.n_en := '1';
          current.ctrl_state         := SERVED_REQ;
        end if;
      when SERVED_REQ =>
        if t_produced = '1' and t_ready = '0' then
          the_output.is_deadlock := '1';
          current.ctrl_state                := T_END;
        else
          if t_produced = '1' and has_next = '1' then
            if ask_next = '1' then
              the_output.n_en := '1';
            else
              current.ctrl_state := T_MORE;
            end if;
          elsif t_produced = '1' and has_next = '0' then
            the_output.ask_src := '1';
            current.ctrl_state            := T_END;
          end if;
        end if;
      when T_MORE =>
        if ask_next = '1' then
          the_output.n_en := '1';
          the_output.src_out := current.source; 
          current.ctrl_state         := SERVED_REQ;
        end if;
    end case;



    --set the state_c
    state_c  <= current;
    --set the outputs
    output_c <= the_output;
  end process;

  out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
      procedure reset_output is
      begin
        i_en        <= '0';
        n_en        <= '0'; 
        src_out     <= (others => '0');
        ask_src     <= '0'; 
        is_deadlock <= '0';
      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          i_en          <= output_c.i_en; 
          n_en          <= output_c.n_en; 
          src_out       <= output_c.src_out; 
          ask_src       <= output_c.ask_src; 
          is_deadlock   <= output_c.is_deadlock; 
        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
    i_en          <= output_c.i_en; 
    n_en          <= output_c.n_en; 
    src_out       <= output_c.src_out; 
    ask_src       <= output_c.ask_src; 
    is_deadlock   <= output_c.is_deadlock; 
  end generate;

end architecture;
