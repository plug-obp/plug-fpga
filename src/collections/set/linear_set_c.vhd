library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

architecture linear_set_c of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;

    type T_MEMORY is array (0 to CAPACITY - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    type T_CONTROL is (
        S0, SEARCH_SLOT
    );
    type T_STATE is record
        ctrl_state  : T_CONTROL;
        memory      : T_MEMORY;
        write_ptr   : unsigned(ADDRESS_WIDTH-1 downto 0);
        current_ptr : unsigned(ADDRESS_WIDTH-1 downto 0);
        data        : std_logic_vector(DATA_WIDTH- 1 downto 0);
    end record;

    constant DEFAULT_STATE : T_STATE := (S0, (others => (others => '0')), (others => '0'), (others => '0'), (others => '0'));
    --next state
    signal state_c : T_STATE :=  DEFAULT_STATE;

    --registers
    signal state_r : T_STATE :=  DEFAULT_STATE;
begin 

state_update : process (clk, reset_n) is
begin
    if reset_n = '0' then
        state_r <= DEFAULT_STATE;
    elsif rising_edge(clk) then
        if reset = '1' then
            state_r <= DEFAULT_STATE;
        else
            state_r <= state_c;
        end if;
    end if;
end process;

next_update : process (add_enable, data_in, state_r) is
    type T_OUTPUT is record
        is_in : boolean;
        is_full : boolean;
        is_done : boolean;
    end record;
    constant DEFAULT_OUTPUT : T_OUTPUT := (false, false, false);
    variable the_output : T_OUTPUT := DEFAULT_OUTPUT;
    variable current : T_STATE := DEFAULT_STATE;
begin
    current := state_r;
	the_output := DEFAULT_OUTPUT;

    case current.ctrl_state is
    when S0 =>
        if add_enable = '1' then
            current.data := data_in;
            current.current_ptr := (others => '0');
            if current.current_ptr = current.write_ptr then --first slot is empty
                the_output.is_in := false;
                the_output.is_done := true;
                current.memory(to_integer(current.write_ptr)) := current.data;

                if current.write_ptr + 1 < CAPACITY then
                    current.write_ptr := current.write_ptr + 1;
                    the_output.is_full := false;
                else
                    the_output.is_full := true;
                end if;
                current.ctrl_state := S0;
            elsif current.memory(to_integer(current.current_ptr)) = current.data then --the first element matches the one we want to add
                the_output.is_in := true;
                the_output.is_done := true;
                current.ctrl_state := S0;
            else --start searching
                the_output.is_done := false;
                current.current_ptr := to_unsigned(1,current.current_ptr'LENGTH);
                current.ctrl_state := SEARCH_SLOT;
            end if;
        end if;
    when SEARCH_SLOT => 
        if current.current_ptr = current.write_ptr then --slot is empty
            the_output.is_in   := false;
            the_output.is_done := true;
            current.memory(to_integer(current.write_ptr)) := current.data;

            if current.write_ptr + 1 < CAPACITY then
                current.write_ptr := current.write_ptr + 1;
                the_output.is_full := false;
            else
                the_output.is_full := true;
            end if;
            current.ctrl_state := S0;
        elsif current.memory(to_integer(current.current_ptr)) = current.data then --the element matches the one we want to add
            the_output.is_in := true;
            the_output.is_done := true;
            current.ctrl_state := S0;
        else --continue searching
            the_output.is_done := false;
            current.current_ptr := current.current_ptr + 1;
            current.ctrl_state := SEARCH_SLOT;
        end if;
    end case;

    --set the state_c
    state_c <= current;
    --set the outputs
    if the_output.is_in then
        is_in <= '1';
    else
        is_in <= '0';
    end if;
    if the_output.is_full then
        is_full <= '1';
    else
        is_full <= '0';
    end if;
    if the_output.is_done then
        add_done <= '1';
    else
        add_done <= '0';
    end if;
end process;

end architecture;