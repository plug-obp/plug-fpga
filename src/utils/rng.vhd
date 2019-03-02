library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rng is
    generic (
        SIZEM : integer := 32;
        SEED : integer := 0
    );
    port (
        clk : in std_logic;
        random_out : out std_logic_vector(SIZEM-1 downto 0)
    );
end entity;

architecture a of rng is

signal state : std_logic_vector (SIZEM-1 downto 0) := std_logic_vector(to_unsigned(SEED, SIZEM));

begin

    process (clk) is
        variable x : std_logic_vector (SIZEM-1 downto 0) := std_logic_vector(to_unsigned(SEED, SIZEM));
    begin
        if (rising_edge(clk)) then
            x := state;
            x := x xor (x sll 13);
            x := x xor (x srl 17);
            x := x xor (x sll 5);
            state <= x;
        end if;
        
    end process;

    random_out <= state;
end;