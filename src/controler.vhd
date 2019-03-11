library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controler is
    generic (
        max_depth : integer
    );
    port (
        clk : in std_logic;
        reset : in std_logic;

        open_at_end : in std_logic;
        open_swap : in std_logic;
        
        fireable_at_end : in std_logic;
        execute_at_end : in std_logic;
        initial_at_end : in std_logic;
        add_enabled : in std_logic;

        open_is_full : inout std_logic;
        closed_is_full : inout std_logic;

        violation : in std_logic;

        start_done : in std_logic;

        start : out std_logic;
        initialize : out std_logic
        execution_ended : out std_logic;
        is_verified : out std_logic
    );
end entity;

architecture a of controler is
    type STATE_T is enum (S0, INITIALIZATION, RUNNING, DONE, OPEN_FULL, CLOSED_FULL);
    signal open_at_end_s : boolean := false;
    signal execute_at_end_s : boolean := false;
    signal fireable_at_end_s : boolean := false;
    signal add_enabled_s : boolean := false;
    signal is_verified_s : boolean := false;
    signal state : STATE_T := S0;
begin

state_update : process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                open_at_end_s := false;
                closed_at_end_s := false;
                fireable_at_end_s := false;
                add_enabled_s := false;
                state := S0;
                start := false;
                initialize := false;
                execution_ended := false;
                is_verified := false;
            else
                case state is
                when S0 =>
                    start <= true;
                    if start_done then
                        start <= false
                        state <= INITIALIZATION;
                    end if;
                when INITIALIZATION =>
                    initialize <= true;
                    if initial_at_end then
                        initialize <= false;
                        state <= RUNNING;
                    elsif closed_is_full then
                        initialize <= false;
                        execution_ended <= true;
                        state <= CLOSED_FULL;
                    elsif open_is_full then
                        initialize <= false;
                        execution_ended <= true;
                        state <= OPEN_FULL;
                    end if;
                when RUNNING =>
                    open_at_end_s <= open_at_end;
                    fireable_at_end_s <= fireable_at_end;
                    execute_at_end_s <= execute_at_end;
                    add_enabled_s <= add_enabled;
                    if closed_is_full then
                        initialize <= false;
                        execution_ended <= true;
                        state <= CLOSED_FULL;
                    elsif open_is_full then
                        initialize <= false;
                        execution_ended <= true;
                        state <= OPEN_FULL;
                    elsif open_at_end_s 
                        and fireable_at_end_s 
                        and execute_at_end_s 
                        and not add_enabled_s then
                        execution_ended <= true;
                        is_verified <= true;
                        state <= DONE;
                    elsif violation then
                        execution_ended <= true;
                        is_verified <= false;
                        state <= DONE;
                    end if;
                when DONE => null;
                when OPEN_FULL => null;
                when CLOSED_FULL => null;
                end case;
            end if;
        end if;
    end process;

end architecture;