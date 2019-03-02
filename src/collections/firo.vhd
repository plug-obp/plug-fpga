library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--First in Random out

entity firo is
    generic
    (
        ADDRESS_WIDTH    : integer    := 4;                                -- address width in bits, maximum CAPACITY is 2^(ADDRESS_WIDTH)-1
        DATA_WIDTH         : integer    := 24;                                -- data width in bits, the size of a configuration
        SEED             : integer     := 1
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
        push_error        : out std_logic;
        pop_error        : out std_logic
    );
end firo;
architecture a of firo is 

type T_MEMORY is array (0 to 2**ADDRESS_WIDTH - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
constant CAPACITY :integer := 2**ADDRESS_WIDTH;
signal memory : T_MEMORY := (others => (others => '0'));
signal read_ptr, write_ptr, rnd_ptr : integer range 0 to ADDRESS_WIDTH-1 := 0; -- read and write pointers
signal full_ff, empty_ff : std_logic;

pure function offset_read_ptr(ridx, widx, rnd : integer) return integer is
begin
    if (ridx <= widx) then 
        return ridx + (rnd mod (widx - ridx));
    else 
        return (ridx + (rnd mod ((CAPACITY - ridx) + widx))) mod CAPACITY;
    end if;
end;

begin 

push_handler: process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                write_ptr <= 0;
            else
                if push_enable = '1' and full_ff = '0' then
                    write_ptr <= (write_ptr + 1) mod CAPACITY;
                    memory(write_ptr) <= data_in;
                end if;
            end if;
        end if;
    end process; 

push_error <= '1' when push_enable = '1' and full_ff = '1' else '0';

random_read : entity WORK.rng 
                generic map (SIZEM => ADDRESS_WIDTH, SEED => SEED)
                port map (clk => clk, offset_read_ptr(read_ptr, write_ptr, random_out) => rnd_ptr);

pop_handler: process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                read_ptr <= 0;
            else
                if pop_enable = '1' and empty_ff = '0' then
                    read_ptr <= (read_ptr + 1) mod CAPACITY;
                    --swap the memory slots
                    memory(read_ptr) <= memory(rnd_ptr);
                    memory(rnd_ptr) <= memory(read_ptr);
                end if;
            end if;
        end if;
    end process;

pop_error <= '1' when pop_enable = '1' and empty_ff = '1' else '0';

data_out <= memory(read_ptr);

full_ff  <= '1' when (write_ptr + 1 = read_ptr)     else '0';
empty_ff <= '1' when read_ptr = write_ptr         else '0';

-- connect full and empty
is_full <= full_ff;
is_empty <= empty_ff;

end architecture;