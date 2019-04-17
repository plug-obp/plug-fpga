library IEEE;
use IEEE.STD_LOGIC_1164.all;



architecture a of hash_table_controler is
  constant HAS_OUTPUT_REGISTER : boolean := false;
  
  type T_SELECT is (isIn, conf); 

  type T_CONTROL is (S0, WAIT_HASH, S1 )
  type T_STATE is record
    ctrl_state  : T_CONTROL; 
    hash : std_logic_vector(HASH_WIDTH-1 downto 0); 

  end record;
  constant DEFAULT_STATE : T_STATE := ((others => (others => '0')), 0, 0, 0, false, true);

  type T_OUTPUT is record
    
    rf_c_r      : out std_logic; 
    rf_c_w      : out std_logic; 
    rf_c_w_data : out std_logic_vector(DATA_WIDTH -1 downto 0);  
    rf_c_w_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0);  
    
    rf_p_r      : out std_logic; 
    rf_p_w      : out std_logic; 
    rf_p_w_data : out std_logic_vector(DATA_WIDTH -1 downto 0);  
    rf_p_w_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0);  

    isIn        : out std_logic; 
    isFull      : out std_logic; 
    isDone      : out std_logic
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT := ('0', '0', (others => '0'), (others => '0'), '0', '0', ( others => '0'), ( others => '0'), '0', '0', '0'); 

  --next state
  signal state_c  : T_STATE  := DEFAULT_STATE;
  signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

  --registers
  signal state_r : T_STATE := DEFAULT_STATE;



begin

  procedure read_at_addr
   (signal addr : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    variable o : inout T_OUTPUT) is 
  begin
        o.rf_p_r := '1'; 
        o.rf_p_w_addr :=  addr; 
        o.rf_c_r := '1'; 
        o.rf_c_w_addr :=  addr; 
  end read_at_addr;



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
  begin
    c := state_r;
    o := DEFAULT_OUTPUT;

      case(c.ctrl_state) is
        when S0 => 

          if add_enable = '1' then 
            c.ctrl_state := WAIT_HASH; 
          end if; 

        when WAIT_HASH => 
            if (hash_ok = '1') then 
              c.hash := hash; 
              o = read_at_addr(hash, o); 
              c.ctrl_state = S1; 
            end if; 
        when S1 => 
          ;
        
        when others =>
          null;
      end case;

    

    

    
    --set the state_c
    state_c  <= c;
    --set the outputs
    output_c <= o;
  end process;

  out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
      procedure reset_output is
      begin
        rf_c_r      <= '0'; 
        rf_c_w      <= '0'; 
        rf_c_w_data <= (others => '0'); 
        rf_c_w_addr <= (others => '0'); 
        rf_p_r      <= '0'; 
        rf_p_w      <= '0'; 
        rf_p_w_data <= ( others => '0'); 
        rf_p_w_addr <= ( others => '0'); 
        isIn        <= '0'; 
        isFull      <= '0'; 
        isDone      <= '0'; 

      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          rf_c_r      <= output_c.rf_c_r; 
          rf_c_w      <= output_c.rf_c_w; 
          rf_c_w_data <= output_c.rf_c_w_data; 
          rf_c_w_addr <= output_c.rf_c_w_addr; 
          rf_p_r      <= output_c.rf_p_r; 
          rf_p_w      <= output_c.rf_p_w; 
          rf_p_w_data <= output_c.rf_p_w_data; 
          rf_p_w_addr <= output_c.rf_p_w_addr; 
          isIn        <= output_c.isIn; 
          isFull      <= output_c.isFull; 
          isDone      <= output_c.isDone; 

        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
    rf_c_r      <= output_c.rf_c_r; 
    rf_c_w      <= output_c.rf_c_w; 
    rf_c_w_data <= output_c.rf_c_w_data; 
    rf_c_w_addr <= output_c.rf_c_w_addr; 
    rf_p_r      <= output_c.rf_p_r; 
    rf_p_w      <= output_c.rf_p_w; 
    rf_p_w_data <= output_c.rf_p_w_data; 
    rf_p_w_addr <= output_c.rf_p_w_addr; 
    isIn        <= output_c.isIn; 
    isFull      <= output_c.isFull; 
    isDone      <= output_c.isDone;
  end generate;
end architecture;
