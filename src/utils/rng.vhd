library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rng is
    generic (
        SIZE : integer := 32;
        SEED : std_logic_vector (SIZE-1 downto 0);
    );
    port (
        clk : in std_logic;
        random_out : out std_logic_vector(SIZE-1 downto 0)
    );
end entity;

architecture a of rng is

signal state : std_logic_vector (SIZE-1 downto 0) := SEED;

begin

    process (clk) is
        variable x : std_logic_vector (SIZE-1 downto 0) := SEED;
    begin
        if (rising_edge(clk)) then
            x := state;
            x := x xor (x sll 13);
            x := x xor (x srl 17);
            x := x xor (x sll 5);
            state <= x;
        end if;
        
    end process;

    data_out <= state;
end;