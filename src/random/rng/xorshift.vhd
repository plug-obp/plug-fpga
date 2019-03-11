

package rng_pkg is

type param is record
        width : integer;
        a : integer;
        b : integer; 
        c : integer;
    end record;
    --The (a,b,c) parameters come from:
    -- Marsaglia, George. "Xorshift rngs." Journal of Statistical Software 8.14 (2003): 1-6. 
    constant p : param := (width => 64, a => 13, b => 7, c => 17);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.rng_pkg.ALL;

entity rng is
    generic (
        SEED : integer := 1
    );
    port (
        clk : in std_logic;
        sreset : in std_logic;
        reset_n : in std_logic;
	    next_random : in std_logic;
	    next_ok : out std_logic;
        random_out : out std_logic_vector(64-1 downto 0)
    );
    
end entity;

--https://en.wikipedia.org/wiki/Xorshift
architecture a of rng is
    signal state : UNSIGNED (64-1 downto 0) := to_unsigned(SEED, p.width);
    signal s_next_ok : boolean := false;
begin
    process (clk, reset_n) is
        variable x : UNSIGNED (64-1 downto 0) := to_unsigned(SEED, p.width);
    begin
        if reset_n = '0' then
            state <= to_unsigned(SEED, p.width);
            s_next_ok <= false;
        elsif (rising_edge(clk)) then
            if sreset = '1' then
                state <= to_unsigned(SEED, p.width);
                s_next_ok <= false;
            elsif next_random = '1' then
                x := state;
                x := x xor shift_left(x, p.a); -- sinon a la main
                x := x xor shift_right(x, p.b);
                x := x xor shift_left(x, p.c);
                state <= x;
                s_next_ok <= true;
            end if;
        end if;   
    end process;

    random_out <= std_logic_vector(state);
    next_ok <= '1' when s_next_ok else '0';
end;