library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stack is
    generic
    (
        ADDRESS_WIDTH    : integer    := 4;                                -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH         : integer    := 24                                 -- data width in bits, the size of a configuration
    );
    port 
    ( 
        clk             : in  std_logic;                                -- clock
        reset             : in  std_logic;                                 -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        pop_enable         : in  std_logic;                                     -- read enable 
        push_enable        : in  std_logic;                                     -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is added when write_enable
        data_out        : out std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is read if read_enable
        is_empty         : out std_logic;                                 -- is_empty is asserted when no elements are in
        is_full            : out std_logic;                                 -- is_full is asserted when data_count == CAPACITY
        is_error        : out std_logic_vector(1 downto 0) := B"00"
    );
end stack;
architecture a of stack is 

type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
constant CAPACITY :integer := 2**ADDRESS_WIDTH;
signal memory : T_MEMORY := (others => (others => '0'));
signal stack_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- stack pointer
signal full_ff, empty_ff : std_logic;

begin 

update: process (clk) 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                read_ptr <= 0;
                write_ptr <= 0;
                is_error <= B"00";
            else
                if push_enable = '1' then
                    if full_ff = '0' then
                        stack_ptr <= stack_ptr + 1;
                        memory(stack_ptr) <= data_in;
                        is_error <= (others => '0');
                    else
                        is_error <= B"01"; -- write when full
                    end if;
                end if;

                if pop_enable = '1' then
                    if empty_ff = '0' then
                        stack_ptr <= stack_ptr - 1;
                        is_error <= (others => '0');
                    else 
                        is_error <= B"10"; --read when empty
                    end if;
                end if;
            end if;
        end if;
    end process;

data_out <= memory(stack_ptr);

full_ff  <= '1' when (stack_ptr = CAPACITY - 1)     else '0';
empty_ff <= '1' when (stack_ptr = 0)         else '0';

-- connect full and empty
is_full <= full_ff;
is_empty <= empty_ff;

end architecture;