library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package alice_bob_pkg is
    -- BEGIN GENERIC EXPLICIT MODEL
    type T_MODEL_PARAMS is record
        nb_states : integer;            -- number of configurations
        nb_transitions : integer;       -- number of transitions
        nb_initial : integer;           -- number of initial configurations
        configuration_width : integer;  -- number of bits in the configuration
    end record;
    -- END GENERIC EXPLICIT MODEL

    -- BEGIN ALICE BOB MODEL
    type T_STATE is  (IDLE, WAITS, RETRY, CS);
    type T_CONFIGURATION is record
        alice : T_STATE;
        aliceFlag : boolean;
        bob : T_STATE;
        bobFlag : boolean;
    end record;

    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector;
    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION;

    constant AB_PARAMS : T_MODEL_PARAMS := (11, 17, 2, 6);
    -- END ALICE BOB MODEL

    -- BEGIN GENERIC EXPLICIT MODEL
    type T_STATES is array (0 to AB_PARAMS.nb_states-1) of T_CONFIGURATION;
    type T_INITIAL is array (0 to AB_PARAMS.nb_initial-1) of integer;
    type T_FANOUT_BASE is array (0 to AB_PARAMS.nb_states) of integer;
    type T_FANOUT    is array (0 to AB_PARAMS.nb_transitions-1) of integer;

    type T_EXPLICIT is record
        states          : T_STATES;         -- the state array
        initial         : T_INITIAL;        -- the initial array
        fanout_base    : T_FANOUT_BASE;   -- the fanout indirection array : fanout (5) is in fanout array between [8, 10)
        fanout          : T_FANOUT;         -- the fanout array
    end record;
    -- END GENERIC EXPLICIT MODEL

    -- BEGIN ALICE BOB MODEL (state-space)
    --state-space of the lamport alice-bob mutex (unfair to bob)
    constant AB_MODEL : T_EXPLICIT := (
        states => (
            0 => (IDLE,  false,  IDLE,   false),
            1 => (WAITS, true,   IDLE,   false),
            2 => (IDLE,  false,  WAITS,  true),

            3 => (CS,    true,   IDLE,   false),
            4 => (WAITS, true,   WAITS,  true),
            5 => (IDLE,  false,  CS,     true),

            6 => (CS,    true,   WAITS,  true),
            7 => (WAITS, true,   RETRY,  false),
            8 => (WAITS, true,   CS,     true),

            9 => (CS,    true,   RETRY,  false),
           10 => (IDLE,  false,  RETRY,  false)
        ),
        initial => (0 => 0, 1=>2),
        fanout_base => (0, 2, 4, 6, 7, 8, 10, 12, 13, 14, 15, 17),
        fanout => (
            1, 2,   -- fanout( 0)
            3, 4,   -- fanout( 1)
            4, 5,   -- fanout( 2)
            6,      -- fanout( 3)
            7,      -- fanout( 4)
            0, 8,   -- fanout( 5)
            2, 9,   -- fanout( 6)
            9,      -- fanout( 7)
            1,      -- fanout( 8)
            10,     -- fanout( 9)
            5, 7    -- fanout(10)
        )
    );
    -- END ALICE BOB MODEL (state-space)

end package;

package body alice_bob_pkg is
    -- BEGIN ALICE BOB CONVERSION FUNCTIONS
    pure function config2lv(c : T_CONFIGURATION) return std_logic_vector is
        variable result : std_logic_vector(5 downto 0);
    begin
        result(5 downto 4) := std_logic_vector(to_unsigned(T_STATE'POS(c.alice), 2));
        if c.aliceFlag then 
            result(3) := '1';
        else 
            result(3) := '0';
        end if;
        result(2 downto 1) := std_logic_vector(to_unsigned(T_STATE'POS(c.bob), 2));
        if c.bobFlag then 
            result(0) := '1';
        else 
            result(0) := '0';
        end if;
        return result;
    end function;

    pure function lv2config(lv : std_logic_vector) return T_CONFIGURATION is
        variable result : T_CONFIGURATION;
    begin
        result.alice := T_STATE'VAL(to_integer(unsigned(lv(5 downto 4))));
        if lv(3) = '1' then
            result.aliceFlag := true;
        else 
            result.aliceFlag := false; 
        end if;
        result.bob := T_STATE'VAL(to_integer(unsigned(lv(2 downto 1))));
        if lv(0) = '1' then
            result.bobFlag := true;
        else 
            result.bobFlag := false; 
        end if;
        return result;
    end function;
    -- END ALICE BOB CONVERSION FUNCTIONS
end;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.alice_bob_pkg.ALL;
entity explicit_interpreter is
    generic (
	CONFIG_WIDTH : integer := AB_PARAMS.configuration_width;
        p : T_MODEL_PARAMS := AB_PARAMS;
        model : T_EXPLICIT := AB_MODEL
    );
    port (
        clk             : in std_logic;                                 -- clock
        reset           : in std_logic;
        reset_n         : in std_logic;
        initial_enable  : in std_logic;                                 -- when initial is asserted, data_out contains a new configuration each clock cycle while has_next is set

        next_enable     : in std_logic;
        source_in       : in std_logic_vector(p.configuration_width-1 downto 0);

        target_out      : out std_logic_vector(p.configuration_width-1 downto 0); -- the output configuration data
        target_ready    : out std_logic;                                -- next out can be read
        has_next        : out std_logic                                 -- no more configuration available
    );
begin
	assert CONFIG_WIDTH = p.configuration_width report "configuration width not equal to model configuration width" severity error;
end entity;

architecture a of explicit_interpreter is
    signal started_init : boolean := false;
    signal source : std_logic_vector(p.configuration_width-1 downto 0) := (others => '0');
    signal source_index : integer := 0;
    signal source_found : boolean := false;
    signal target_base : integer := 0;
    signal target_offset : integer := 0;
    signal has_nxt : boolean := false;
begin

update : process (clk, reset_n) is
        type T_STATE is (START_INIT, PRODUCE_INIT, END_INIT, 
                START_NEXT, LOAD_SOURCE, NO_SOURCE, PRODUCE_NEXT, END_NEXT,
                DO_NOTHING);
        variable state : T_STATE;
        variable fanout_size : integer := 0;
        procedure reset_state is 
        begin
            started_init <= false;
            source <= (others => '0');
            source_index <= 0;
            source_found <= false;
            target_base <= 0;
            target_offset <= 0;
            has_nxt <= false;
	    target_out <= (others => '0');
	    target_ready <= '0';
        end;
    begin
        if reset_n = '0' then
            reset_state;
        elsif rising_edge(clk) then
            if reset = '1' then
                reset_state;
            else
                if initial_enable = '1' and next_enable = '1' then
                    state := DO_NOTHING;
                elsif initial_enable = '1' then
                    if not started_init then
                        state := START_INIT;
                    elsif has_nxt then
                        state := PRODUCE_INIT;
                    else
                        state := END_INIT;
                    end if;
                elsif next_enable = '1' then
                    if source /= source_in then
                        if p.nb_states > 0 then
                            state := START_NEXT;
                        else
                            state := NO_SOURCE;
                        end if;
                    elsif not source_found then
                        if p.nb_states > 0 and source_index < p.nb_states then
                            state := LOAD_SOURCE;
                        else 
                            state := NO_SOURCE;
                        end if;
                    elsif has_nxt then
                        state := PRODUCE_NEXT;
                    else
                        state := END_NEXT;
                    end if;
                else
                    state := DO_NOTHING;
                end if;

                case state is
                when START_INIT =>
                    started_init <= true;
                    if p.nb_initial = 0 then
                        has_nxt <= false;
                    else
                        target_out <= config2lv(model.states(model.initial(0)));
                        target_ready <= '1';
                        target_offset <= 1;
                        if p.nb_initial > 1 then
                            has_nxt <= true;
                        else
                            has_nxt <= false;
                        end if;
                    end if;
                when PRODUCE_INIT => 
                    target_out <= config2lv(model.states(model.initial(target_offset)));
                    target_ready <= '1';
                    target_offset <= target_offset + 1;
                    if target_offset + 1 < p.nb_initial then
                        has_nxt <= true;
                    else
                        has_nxt <= false;
                    end if;
                when END_INIT =>
                    started_init <= false;
                when START_NEXT =>
                    source <= source_in;
                    source_found <= false;
                    if source_in = config2lv(model.states(0)) then
                        source_found <= true;
                        source_index <= 0;
                        target_base <= model.fanout_base(0);
                        fanout_size := model.fanout(1) - model.fanout_base(0);
                        if fanout_size > 0 then
                            target_out <= config2lv(model.states(model.fanout(model.fanout_base(0) + 0)));
                            target_ready <= '1';
                            target_offset <= 1;
                            if fanout_size > 1 then
                                has_nxt <= true;
                            else
                                has_nxt <= false;
                            end if;
                        else -- no fanout / deadlock
                            has_nxt <= false;
                        end if;
                    else 
                        source_found <= false;
                        source_index <= 1;
                    end if;
                when LOAD_SOURCE =>
                    if source_in = config2lv(model.states(source_index)) then
                        source_found <= true;
                        target_base <= model.fanout_base(source_index);
                        fanout_size := model.fanout_base(source_index + 1) - model.fanout_base(source_index);
                        if fanout_size > 0 then
                            target_out <= config2lv(model.states(model.fanout(model.fanout_base(source_index) + 0)));
                            target_ready <= '1';
                            target_offset <= 1;
                            if fanout_size > 1 then
                                has_nxt <= true;
                            else
                                has_nxt <= false;
                            end if;
                        else
                            has_nxt <= false;
                        end if;
                    else
                        source_found <= false;
                        source_index <= source_index + 1;
                    end if;
                when PRODUCE_NEXT =>
                    target_out <= config2lv(model.states(model.fanout(target_base + target_offset)));
                    target_ready <= '1';
                    target_offset <= target_offset + 1;
                    fanout_size := model.fanout_base(source_index + 1) - model.fanout_base(source_index);
                    if target_offset + 1 < fanout_size then
                        has_nxt <= true;
                    else
                        has_nxt <= false;
                    end if;
                when NO_SOURCE | END_NEXT | DO_NOTHING => null;
                end case;

            end if;
        end if;
    end process;

has_next <= '1' when has_nxt else '0';
end;