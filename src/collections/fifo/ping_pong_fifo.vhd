library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Ping pong FIFO implemented using as a circular buffer.
-- The barrier pointer gets the value of the write_ptr if the read_ptr = barrier_ptr, in that case swapped is asserted
entity pingpong_fifo is
    generic
    (
        ADDRESS_WIDTH    : integer    := 4;                                -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH         : integer    := 24                                 -- data width in bits, the size of a configuration
    );
    port 
    ( 
        clk             : in  std_logic;                                -- clock
        reset             : in  std_logic;                                 -- when reset is asserted the stream is emptied: size = 0, is_empty = 1, is_full = 0
        reset_n			: in  std_logic;
        pop_enable         : in  std_logic;                                     -- read enable 
        push_enable        : in  std_logic;                                     -- write enable 
        data_in         : in  std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is added when write_enable
        data_out        : out std_logic_vector(DATA_WIDTH- 1 downto 0);   -- the data that is read if read_enable
        data_ready  : out std_logic;
        is_empty         : out std_logic;                                 -- is_empty is asserted when no elements are in
        is_full            : out std_logic;                                 -- is_full is asserted when data_count == CAPACITY
        is_swapped            : out std_logic
    );
end pingpong_fifo;
architecture a of pingpong_fifo is 
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_MEMORY is array (0 to CAPACITY - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal memory : T_MEMORY := (others => (others => '0'));
    signal read_ptr, write_ptr, barrier_ptr : integer range 0 to CAPACITY-1 := 0; -- read and write pointers
    signal full : boolean := false;
    signal empty : boolean := true;

begin 

handler : process (clk, reset_n) is
        variable idx : integer;
        procedure reset_state is
        begin
            write_ptr <= 0;
            read_ptr <= 0;
            barrier_ptr <= 0;
            memory <= (others => (others => '0'));
            empty <= true;
            full <= false;
            data_ready <= '0';
            data_out <= (others => '0');
            is_swapped <= '0';
        end procedure;
    begin
        if reset_n = '0' then
            reset_state;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_state;
            else
                data_ready <= '0';
                is_swapped <= '0'; -- suppose we do not swap
                if push_enable = '1' and pop_enable = '1' then
                    if empty then
                        data_out <= data_in;
                        data_ready <= '1';
                        memory(write_ptr) <= data_in;
                        is_swapped <= '1'; -- if empty, add to next_fifo, swap and then read
                    else -- full or not full nor empty
                        data_out <= memory(read_ptr);
                        data_ready <= '1';
                        idx := (read_ptr + 1) mod CAPACITY;
                        read_ptr <= idx;
                        memory(write_ptr) <= data_in;
                        write_ptr <= (write_ptr + 1) mod CAPACITY;

                        --the barrier can change only when pop
                        --if the next read touches the barrier, then swap
                        if idx = barrier_ptr then
                            barrier_ptr <= write_ptr;
                            is_swapped <= '1';
                        end if;
                    end if;
                    
                elsif pop_enable = '1' and not empty then
                    data_out <= memory(read_ptr);
                    data_ready <= '1';
                    idx := (read_ptr + 1) mod CAPACITY;
                    read_ptr <= idx;
                    if idx = write_ptr then
                        empty <= true;
                    end if;
                    if full then 
                        full <= false;
                    end if;
                    --the barrier can change only when pop
                    -- if the next read touches the barrier, then swap
                    if idx = barrier_ptr then
                        barrier_ptr <= write_ptr;
                        is_swapped <= '1';
                    end if;
                elsif push_enable = '1' and not full then
                    memory(write_ptr) <= data_in;
                    idx := (write_ptr + 1) mod CAPACITY;
                    write_ptr <= idx;
                    if idx = read_ptr then
                        full <= true;
                    end if;
                    if empty then
                        empty <= false;
                    end if;
                end if;
            end if;
        end if;
    end process;

is_full <= '1' when full else '0';
is_empty <= '1' when empty else '0';

end architecture;