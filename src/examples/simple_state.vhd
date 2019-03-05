library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity simple_state is
    port (
        clk : in std_logic;
        rst : in std_logic;
        rst_n : in std_logic;
        count : in std_logic;
        dout : out std_logic_vector(3 downto 0)
    );
end entity;

architecture a of simple_state is 
    signal state : unsigned(3 downto 0) := (others => '0');
begin
    state_update : process (clk, rst_n) is
    begin
        if rst_n = '0' then
            state <= (others => '0');
        elsif rising_edge(clk) then
            if rst = '1' then
                state <= (others => '0');
            elsif count = '1' then
                state <= state + 1; --state changes
            else
                state <= state; -- state unchanged
            end if;
        end if;
    end process;

    dout <= std_logic_vector(state);
end architecture;

architecture b of simple_state is 
    signal state_0, state_1 : unsigned(3 downto 0) := (others => '0');
begin
    state_0_update : process (clk, rst_n) is
    begin
        if rst_n = '0' then
            state_0 <= (others => '0');
        elsif rising_edge(clk) then
            if rst = '1' then
                state_0 <= (others => '0');
            else
                state_0 <= state_1;
            end if;
        end if;
    end process;

    state_1_update : process (clk, rst_n) is
    begin
        if rst_n = '0' then
            state_1 <= (others => '0');
        elsif rising_edge(clk) then
            if rst = '1' then
                state_1 <= (others => '0');
            elsif count = '1' then
                state_1 <= state_1 + 1; --state changes
            else
                state_1 <= state_1; -- state unchanged
            end if;
        end if;
    end process;

    dout <= std_logic_vector(state_0);
end architecture;