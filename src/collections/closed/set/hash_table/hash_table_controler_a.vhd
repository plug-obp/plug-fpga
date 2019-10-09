library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use ieee.numeric_std_unsigned.all; 
use ieee.numeric_std.all; 



architecture a of hash_table_controler is
  
  --constant HAS_OUTPUT_REGISTER : boolean := false;
  constant CAPACITY : integer := 2**ADDR_WIDTH; 

 -- type T_SELECT is (isIn, conf); 

  type T_CONTROL is (S0, S_WAIT_HASH, S_READ_NEXT, S_WAIT_READ ); 
  type T_STATE is record
    ctrl_state  : T_CONTROL; 
    hash : std_logic_vector(ADDR_WIDTH-1 downto 0); 
    config : std_logic_vector(DATA_WIDTH -1 downto 0); 
    index : std_logic_vector(ADDR_WIDTH-1 downto 0); 
  end record;
  constant DEFAULT_STATE : T_STATE := (S0, (others => '0'), (others => '0'), (others => '0'));

  type T_OUTPUT is record

    rf_c_clear  : std_logic; 
    rf_c_r      : std_logic; 
    rf_c_r_addr : std_logic_vector(ADDR_WIDTH -1 downto 0);  
    rf_c_w      : std_logic; 
    rf_c_w_data : std_logic_vector(DATA_WIDTH -1 downto 0);  
    rf_c_w_addr : std_logic_vector(ADDR_WIDTH -1 downto 0);  
    rf_p_clear  : std_logic; 
    rf_p_r      : std_logic; 
    rf_p_r_addr : std_logic_vector(ADDR_WIDTH -1 downto 0);  
    rf_p_w      : std_logic; 
    rf_p_w_data : std_logic_vector(0 downto 0);  
    rf_p_w_addr : std_logic_vector(ADDR_WIDTH -1 downto 0);  
    isIn        : std_logic; 
    isFull      : std_logic; 
    isDone      : std_logic; 
  end record;
  constant DEFAULT_OUTPUT : T_OUTPUT :=  ( '0', '0', (others =>'0'), '0', (others => '0'), (others => '0'), '0', '0', (others => '0'), '0', (others => '0'), (others => '0'), '0', '0', '0');


  --next state
  signal state_c  : T_STATE  := DEFAULT_STATE;
  signal output_c : T_OUTPUT := DEFAULT_OUTPUT;

  --registers
  signal state_r : T_STATE := DEFAULT_STATE;


  procedure readAt (variable addr : in std_logic_vector(ADDR_WIDTH-1 downto 0); 
    variable ouput_var : inout T_OUTPUT) is 
  begin
        ouput_var.rf_p_r := '1'; 
        ouput_var.rf_p_r_addr :=  addr; 
        ouput_var.rf_c_r := '1'; 
        ouput_var.rf_c_r_addr :=  addr; 
  end procedure;


  procedure writeAt 
    (variable addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
     variable data : in std_logic_vector(DATA_WIDTH-1 downto 0); 
    variable ouput_var : inout T_OUTPUT) is 
  begin
        ouput_var.rf_c_w := '1'; 
        ouput_var.rf_c_w_addr :=  addr; 
        ouput_var.rf_c_w_data := data; 
        ouput_var.rf_p_w := '1'; 
        ouput_var.rf_p_w_addr :=  addr; 
        ouput_var.rf_p_w_data(0) := '1'; 
        
  end procedure;


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

  next_update : process (add_enable, hash_ok,rf_c_r_ok, rf_p_r_ok, data, hash, rf_p_r_data, rf_c_r_data , state_r) is
    variable o : T_OUTPUT := DEFAULT_OUTPUT;
    variable c : T_STATE  := DEFAULT_STATE;
  begin
    c := state_r;
    o := DEFAULT_OUTPUT;

      case(c.ctrl_state) is
        when S0 =>
          if add_enable = '1' and clear_table = '1' then 
            c.config := data; 
            c.ctrl_state := S_WAIT_HASH; 
            o.rf_c_clear := '1'; 
            o.rf_p_clear := '1'; 
          elsif add_enable = '1' then 
            c.config := data;
            c.ctrl_state := S_WAIT_HASH; 
          end if; 
        when S_WAIT_HASH => 
          if hash_ok = '1' then 
            --c.hash := (ADDR_WIDTH-1 downto 0 => hash(ADDR_WIDTH-1 downto 0), others => '0'); 
            c.hash(ADDR_WIDTH-1 downto 0) := hash(ADDR_WIDTH-1 downto 0); 
            --c.hash(ADD)
            c.index := c.hash; 
            c.ctrl_state := S_READ_NEXT; 
          end if; 
        when S_READ_NEXT =>
          readAt(c.index, o); 
          c.ctrl_state := S_WAIT_READ; 
        when S_WAIT_READ => 
          if (rf_c_r_ok = '1' and rf_p_r_ok = '1' ) then 
            if rf_p_r_data(0) = '1' then 
              if std_logic_vector((unsigned(c.index)+1) mod CAPACITY) = c.hash   then 
                o.isFull := '1';
                o.isDone := '0'; 
                if rf_c_r_data = c.config then 
                  o.isIn := '1';  
                else 
                  o.isIn := '0'; 
                end if; 
                c.ctrl_state := S0; 
              else
                c.index := std_logic_vector((unsigned(c.index)+1) mod CAPACITY); 
                if rf_c_r_data = c.config then 
                  o.isIn := '1'; 
                  o.isFull := '0'; 
                  o.isDone := '1'; 
                  c.ctrl_state := S0; 
                else 
                  c.ctrl_state := S_READ_NEXT; 
                end if; 
              end if; 
            else 
              writeAt(c.index, c.config, o); 
              c.ctrl_state := S0; 
              o.isDone := '1'; 
              o.isIn := '0'; 
              if std_logic_vector((unsigned(c.index)+1) mod CAPACITY) = c.hash then 
                o.isFull := '1'; 
              else 
                o.isFull := '0'; 
              end if; 

            end if; 
          end if; 
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
        rf_c_clear    <= '0'; 
        rf_c_r        <= '0'; 
        rf_c_r_addr   <= (others =>'0'); 
        rf_c_w        <= '0'; 
        rf_c_w_data   <= (others => '0'); 
        rf_c_w_addr   <= (others => '0'); 
        rf_p_clear    <= '0'; 
        rf_p_r        <= '0'; 
        rf_p_r_addr   <= (others => '0'); 
        rf_p_w        <= '0'; 
        rf_p_w_data   <= (others => '0'); 
        rf_p_w_addr   <= (others => '0'); 
        isIn          <= '0'; 
        isFull        <= '0'; 
        isDone        <= '0'; 

      end;
    begin
      if reset_n = '0' then
        reset_output;
      elsif rising_edge(clk) then
        if reset = '1' then
          reset_output;
        else
          rf_c_clear <= output_c.rf_c_clear; 
          rf_c_r <= output_c.rf_c_r; 
          rf_c_r_addr <= output_c.rf_c_r_addr; 
          rf_c_w <= output_c.rf_c_w; 
          rf_c_w_data <= output_c.rf_c_w_data; 
          rf_c_w_addr <= output_c.rf_c_w_addr; 
          rf_p_clear <= output_c.rf_p_clear; 
          rf_p_r <= output_c.rf_p_r; 
          rf_p_r_addr <= output_c.rf_p_r_addr; 
          rf_p_w <= output_c.rf_p_w; 
          rf_p_w_data <= output_c.rf_p_w_data; 
          rf_p_w_addr <= output_c.rf_p_w_addr; 
          isIn <= output_c.isIn; 
          isFull <= output_c.isFull; 
          isDone <= output_c.isDone; 


        end if;
      end if;
    end process;
  end generate;

  no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
        rf_c_clear <= output_c.rf_c_clear; 
        rf_c_r <= output_c.rf_c_r; 
        rf_c_r_addr <= output_c.rf_c_r_addr; 
        rf_c_w <= output_c.rf_c_w; 
        rf_c_w_data <= output_c.rf_c_w_data; 
        rf_c_w_addr <= output_c.rf_c_w_addr; 
        rf_p_clear <= output_c.rf_p_clear; 
        rf_p_r <= output_c.rf_p_r; 
        rf_p_r_addr <= output_c.rf_p_r_addr; 
        rf_p_w <= output_c.rf_p_w; 
        rf_p_w_data <= output_c.rf_p_w_data; 
        rf_p_w_addr <= output_c.rf_p_w_addr; 
        isIn <= output_c.isIn; 
        isFull <= output_c.isFull; 
        isDone <= output_c.isDone; 
  end generate;
end architecture;
