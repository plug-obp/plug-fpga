library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture c of fifo is 
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_MEMORY is array (0 to CAPACITY - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal memory : T_MEMORY := (others => (others => '0'));
    attribute ram_style : string;
    attribute ram_style of memory : signal is "block";

    signal read_ptr, write_ptr : integer range 0 to CAPACITY-1 := 0; -- read and write pointers
    signal full: boolean := false; 
    signal empty : boolean := true;

begin 

handler : process (clk, reset_n) is
        variable idx : integer;
        procedure reset_state is
        begin
            write_ptr <= 0;
            read_ptr <= 0;
            memory <= (others => (others => '0'));
            empty <= true;
            full <= false;
            data_ready <= '0';
            data_out <= (others => '0');
        end;
    begin
        if reset_n = '0' then
            reset_state;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_state;
            else
                pop_is_done <= '0';
                push_is_done <= '0';
                if push_enable = '1' and pop_enable = '1' then
                    if empty then
                        data_out <= data_in;
                        data_ready <= '1';
                        memory(write_ptr) <= data_in;
                        push_is_done <= '1';
                        pop_is_done <= '1';
                    else -- full or not full nor empty
                        data_out <= memory(read_ptr);
                        data_ready <= '1';
                        read_ptr <= (read_ptr + 1) mod CAPACITY;
                        memory(write_ptr) <= data_in;
                        write_ptr <= (write_ptr + 1) mod CAPACITY;
                        push_is_done <= '1';
                        pop_is_done <= '1';
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
                    pop_is_done <= '1';
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
                    push_is_done <= '1';
                end if;
            end if;
        end if;
    end process;

is_full <= '1' when full else '0';
is_empty <= '1' when empty else '0';
is_swapped <= '0';

end architecture;