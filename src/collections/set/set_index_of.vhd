-------------------------------------------------------------------------------
-- JC LE LANN for C.Teodorov
-- 2019. ENSTA Bretagne.
-------------------------------------------------------------------------------
-- RTL version of : 
-------------------------------------------------------------------------------
 --pure function index_of(
 --   memory : T_MEMORY;
 --   object : std_logic_vector(DATA_WIDTH - 1 downto 0);
 --   hash   : integer)
 --   return T_INDEX is
 --   variable index, start : integer range 0 to CAPACITY-1;
 --   variable first        : boolean := true;
 --   variable element      : T_SET_ELEMENT;
 -- begin
 --   index := hash mod CAPACITY;
 --   while first or start /= index loop
 --     element := memory(index);
 --     if (element.is_set = false) then
 --       return (ptr => index, is_valid => true, is_found => false);
 --     elsif (element.data = object) then
 --       return (ptr => index, is_valid => true, is_found => true);
 --     end if;
 --     if first then
 --       start := index;
 --       first := false;
 --     end if;
 --     index := (index + 1) mod CAPACITY;
 --   end loop;
 --   return (ptr => 0, is_valid => false, is_found => false);  -- no space left
 -- end function;


    
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library set_lib;
use set_lib.pkg.all;

entity function_set_index_of is
  generic (CAPACITY : natural := 2**ADDRESS_WIDTH);
  port(
    reset_n  : in  std_logic;
    clk      : in  std_logic;
    go       : in  std_logic;
    done     : out std_logic;
    memory   : in  T_MEMORY;
    object   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    hash     : in  integer;
    index_of : out T_INDEX
    );
end;

architecture automaton of function_set_index_of is
  type T_STATE is (IDLE, S0, S1, S2, S3, RET);
  signal state, state_c       : T_STATE;
  signal index_r, index_c     : integer range 0 to CAPACITY-1;
  signal start_r, start_c     : integer range 0 to CAPACITY-1;
  signal first_r, first_c     : boolean;
  signal element_r, element_c : T_SET_ELEMENT;
  signal t_index_r, t_index_c : T_INDEX;
  signal done_r, done_c       : std_logic;

begin

  tick : process(reset_n, clk)
  begin
    if reset_n = '0' then
      state     <= IDLE;
      index_r   <= 0;
      start_r   <= 0;
      first_r   <= true;
      element_c <= ((others => '0'), false);
      t_index_c <= (0, false, false);
      state_c   <= IDLE;
      done_c    <= '0';
    elsif rising_edge(clk) then
      state     <= state_c;
      index_r   <= index_r;
      start_r   <= start_c;
      first_r   <= first_c;
      element_r <= element_c;
      t_index_r <= t_index_c;
      done_r    <= done_c;
    end if;
  end process;
  
  index_of <= t_index_r;
  
  done <= done_r;--need to check that.
  
  next_state : process(state,
                       go,
                       index_r,
                       start_r,
                       first_r,
                       element_r,
                       t_index_r,
                       done_r)
    variable go_v             : std_logic;
    variable done_v           : std_logic;
    variable index_v, start_v : integer range 0 to CAPACITY-1;
    variable state_v          : T_STATE;
    variable first_v          : boolean := true;
    variable element_v        : T_SET_ELEMENT;
    variable t_index_v        : T_INDEX;
  begin
    go_v    := go;
    done_v  := '0';
    state_v := state;
    index_v := index_r;

    case state_v is
      when IDLE =>
        if go_v='1' then
          state_v := S0;
        end if;
      when S0 =>
        index_v := hash mod CAPACITY;
        state_v := S1;
      when S1 =>
        if first_v or start_v /= index_v then
          state_v := S2;
        else
          state_v := S3;
        end if;
      when S2 =>
        if (element_v.is_set = false) then
          t_index_v.ptr      := index_v;
          t_index_v.is_valid := true;
          t_index_v.is_found := false;
          done_v             := '1';
          state_v            := RET;
        elsif (element_v.data = object) then
          t_index_v.ptr      := index_v;
          t_index_v.is_valid := true;
          t_index_v.is_found := true;
          done_v             := '1';
          state_v            := RET;
        end if;
        if first_v then
          start_v := index_v;
          first_v := false;
        end if;
        index_v := (index_v + 1) mod CAPACITY;
        if state_v /= RET then
          state_v := S1;
        end if;
      when S3 =>
        t_index_v.ptr      := 0;
        t_index_v.is_valid := false;
        t_index_v.is_found := false;
        done_v             := '1';
        state_v            := RET;
      when RET =>
        state_v := IDLE;
      when others =>
        null;
    end case;

    index_c   <= index_v;
    start_c   <= start_v;
    state_c   <= state_v;
    first_c   <= first_v;
    element_c <= element_v;
    t_index_c <= t_index_v;
    state_c   <= state_v;
    done_c    <= done_v;
  end process;

end automaton;
