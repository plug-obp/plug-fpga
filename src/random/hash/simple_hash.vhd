library ieee;
use ieee.std_logic_1164.all; 

entity simple_hash is

  generic (
    HAS_OUTPUT_REGISTER : boolean := true; 
    DATA_WIDTH          : natural := 416;
    HASH_WIDTH          : natural := 16 ;
    WORD_WIDTH          : natural := 8);

  port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    reset_n     : in std_logic; 
    data        : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    hash_en     : in  std_logic;
    hash_key    : out std_logic_vector(HASH_WIDTH - 1 downto 0);
    hash_ok     : out std_logic);


end entity simple_hash;


library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std_unsigned.all; 
use ieee.numeric_std.all; 


architecture a of simple_hash is
    type T_CONTROL is (
        S0, S1, ERR
    );
    
    -- constant word_count : integer := DATA_WIDTH / HASH_WIDTH + 1; 
    --constant log_data_width : integer := integer(ceil(log2(real(w_par))));

    type T_STATE is record
        ctrl_state      : T_CONTROL;
        --data            : std_logic_vector(DATA_WIDTH + ( DATA_WIDTH mod WORD_WIDTH) downto 0);
        data            : std_logic_vector(8*((DATA_WIDTH / WORD_WIDTH) +1 )-1 downto 0);
        idx             : integer; 
        hash            : std_logic_vector(HASH_WIDTH -1 downto 0); 
    end record;
    constant DEFAULT_STATE : T_STATE := (S0, (others => '0'), 0, (others => '0'));

    type T_OUTPUT is record
        hash            : std_logic_vector(HASH_WIDTH -1 downto 0);
        hash_ok         : std_logic; 
    end record;
    constant DEFAULT_OUTPUT : T_OUTPUT := ((others => '0'), '0');
    
    --next state
    signal state_c      : T_STATE :=  DEFAULT_STATE;
    signal output_c     : T_OUTPUT := DEFAULT_OUTPUT;

    --registers
    signal state_r      : T_STATE :=  DEFAULT_STATE;

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

next_update : process (hash_en, data, state_r) is
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current : T_STATE := DEFAULT_STATE;
    variable current_word : std_logic_vector(WORD_WIDTH -1 downto 0); 
begin
    current := state_r;
	the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
    when S0   =>
        if hash_en = '1' then 
            current.idx         := 0; 
            current.hash        := (2 downto 0 => '1', others => '0');  --(current_word'high downto 0 => current_word, others => '0');
            --current.data        := ( DATA_WIDTH -1 downto 0 => data, others => '0');  
            current.data(DATA_WIDTH -1 downto 0 )        := data; 
            current.data( downto DATA_WIDTH) := '0';  
--            if DATA_WIDTH < HASH_WIDTH then 
--                current.ctrl_state := FT; 
--            else 
            current_word := current.data(7 downto 0);     
            --current.hash    := shift_left(current.hash,5) - current.hash + current_word;  -- VHDL 2008 
            current.idx := current.idx +1; 

            if (current.idx >= DATA_WIDTH / WORD_WIDTH) then 
                the_output.hash := shift_left(current.hash,5) - current.hash + current_word; 
                the_output.hash_ok := '1'; 
                
            else 
                current.ctrl_state  := S1; 
            end if; 
            -- end if; 

        end if; 

    when S1 =>
            --current_word    := data(7 downto 0);           --current.hash    := (current_word'high downto 0 => current_word, others => '0');    
        --current.hash := std_logic_vector(unsigned(shift_left(current.hash,5)) - unsigned(current.hash) + unsigned(data((current.idx +1)*8 -1 downto current.idx*8))); -- VHDL < 2008 
        current_word := current.data((current.idx +1)*8 -1 downto current.idx*8); 
            
        current.hash    := shift_left(current.hash,5) - current.hash + current_word;  -- VHDL 2008 
        if current.idx = DATA_WIDTH / HASH_WIDTH + 1 then 
            the_output.hash     := current.hash;
            the_output.hash_ok  := '1'; 
            current.ctrl_state  := S0; 
        else 
            current.idx     := current.idx +1; 
        end if; 
  --  when FT => 
  --      the_output.hash := ( DATA_WIDTH -1 downto 0 => current.data, others  => '0'); 
 --     the_output.hash_ok := '1'; 
 --       current.ctrl_state := S0; 
    when ERR  => null;
    end case;

    --set the state_c
    state_c <= current;
    --set the outputs
    output_c <= the_output;

end process;

out_register : if HAS_OUTPUT_REGISTER generate
    registered_output : process (clk, reset_n) is
        procedure reset_output is
        begin
            hash_key <= ( others => '0');
            hash_ok   <= '0'; 
        end; 
    begin
        if reset_n = '0' then
            reset_output;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_output;
            else
                hash_key <= output_c.hash;
                hash_ok  <= output_c.hash_ok; 
            end if;
        end if;
    end process;
end generate;

no_out_register : if not HAS_OUTPUT_REGISTER generate
    --non-registered output
	hash_key <= output_c.hash;
    hash_ok  <= output_c.hash_ok; 
end generate;

end architecture;





--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std_unsigned.all; 
--use ieee.numeric_std.all; 


--architecture b of simple_hash is
--type T_CONTROL is (
--        S0, S1, FT, ERR
--    );

--    type T_STATE is record
--        ctrl_state      : T_CONTROL;
--        data            : std_logic_vector(DATA_WIDTH-1 downto 0);
--        idx             : integer; 
--        hash            : std_logic_vector(HASH_WIDTH -1 downto 0); 
--    end record;
--    constant DEFAULT_STATE : T_STATE := (S0, (others => '0'), 0, (others => '0'));

--    type T_OUTPUT is record
--        hash            : std_logic_vector(HASH_WIDTH -1 downto 0);
--        hash_ok         : std_logic; 
--    end record;
--    constant DEFAULT_OUTPUT : T_OUTPUT := ((others => '0'), '0');
    
--    --next state
--    signal state_c      : T_STATE :=  DEFAULT_STATE;
--    signal output_c     : T_OUTPUT := DEFAULT_OUTPUT;

--    --registers
--    signal state_r      : T_STATE :=  DEFAULT_STATE;


--    signal current_word : std_logic_vector(WORD_WIDTH-1 downto 0); 
--begin 

--state_update : process (clk, reset_n) is
--begin
--    if reset_n = '0' then
--        state_r <= DEFAULT_STATE;
--    elsif rising_edge(clk) then
--        if reset = '1' then
--            state_r <= DEFAULT_STATE;
--        else
--            state_r <= state_c;
--        end if;
--    end if;
--end process;

--if DATA_WIDTH < WORD_WIDTH generate 
--begin
--    if DATA_WIDTH > (state_r.idx +1)*8 -1 then 
--        current_word <= state_r.data((state_r.idx +1)*8 -1 downto state_r.idx*8); 
--    else
--        current_word <= (DATA_WIDTH-1 downto 0 => state_r.data(DATA_WIDTH-1 downto 0), others => '0'); 
--    end if; 
--else
--    current_word <= (DATA_WIDTH-1 downto 0 => state_r.data(DATA_WIDTH-1 downto 0), others => '0'); 
--end generate; 



--next_update : process (hash_en, current_word, state_r) is
--    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
--    variable current : T_STATE := DEFAULT_STATE;
--    variable current_word : std_logic_vector(WORD_WIDTH -1 downto 0); 
--begin
--    current := state_r;
--	the_output := DEFAULT_OUTPUT;

--    case current.ctrl_state is
--    when S0   =>
--        if hash_en = '1' then 
--            current.idx         := 0; 
--            current.hash        := "0000000000000111"; --(current_word'high downto 0 => current_word, others => '0');
--            current.data        := data; 
--            if DATA_WIDTH < HASH_WIDTH then 
--                current.ctrl_state := FT; 
--            else 
--                current.ctrl_state  := S1; 
--            end if; 

--        end if; 

--    when S1 =>
--            --current_word    := data(7 downto 0);           --current.hash    := (current_word'high downto 0 => current_word, others => '0');    
--        --current.hash := std_logic_vector(unsigned(shift_left(current.hash,5)) - unsigned(current.hash) + unsigned(data((current.idx +1)*8 -1 downto current.idx*8))); -- VHDL < 2008 
    
--        current.hash    := shift_left(current.hash,5) - current.hash + current_word;  -- VHDL 2008 
--        if current.idx = DATA_WIDTH / HASH_WIDTH + 1 then 
--            the_output.hash     := current.hash;
--            the_output.hash_ok  := '1'; 
--            current.ctrl_state  := S0; 
--        else 
    
--            current.idx     := current.idx +1; 
--        end if; 
--    when FT => 
--        the_output.hash := ( DATA_WIDTH -1 downto 0 => current.data, others  => '0'); 
--        the_output.hash_ok := '1'; 
--        current.ctrl_state := S0; 
--    when ERR  => null;
--    end case;

--    --set the state_c
--    state_c <= current;
--    --set the outputs
--    output_c <= the_output;

--end process;

--out_register : if HAS_OUTPUT_REGISTER generate
--    registered_output : process (clk, reset_n) is
--        procedure reset_output is
--        begin
--            hash_key <= ( others => '0');
--            hash_ok   <= '0'; 
--        end; 
--    begin
--        if reset_n = '0' then
--            reset_output;
--        elsif rising_edge(clk) then
--            if reset = '1' then
--                reset_output;
--            else
--                hash_key <= output_c.hash;
--                hash_ok  <= output_c.hash_ok; 
--            end if;
--        end if;
--    end process;
--end generate;

--no_out_register : if not HAS_OUTPUT_REGISTER generate
--    --non-registered output
--	hash_key <= output_c.hash;
--    hash_ok  <= output_c.hash_ok; 
--end generate;

--end architecture;

