library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--State-machine design similar to :
    --Zabolotny, Wojciech M. "Clock-efficient and maintainable implementation of complex state machines in vhdl." 
    --Photonics Applications in Astronomy, Communications, Industry, and High-Energy Physics Experiments 2006. Vol. 6347. 
    --International Society for Optics and Photonics, 2006.

architecture linear_set_b of set is
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    type T_MEMORY is array (0 to CAPACITY - 1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal memory : T_MEMORY := (others => (others => '0'));
    signal write_ptr : unsigned(CAPACITY downto 0) := (others => '0');
    signal current_ptr : unsigned(CAPACITY downto 0) := (others => '0');
    signal s_is_full : boolean := false;
    signal s_is_added_ok : boolean := false;
    signal s_is_in : boolean := false;
begin 
-- add
add_handler : process (clk, reset_n) is
        type T_STATE is (NONE, ADD_NEW, ADD_FOUND, ADD_SEARCH);
        variable state : T_STATE := NONE;
        procedure state_reset is
        begin
            memory <= (others => (others => '0'));
            write_ptr <= (others => '0');
            current_ptr <= (others => '0');
            s_is_added_ok <= false;
            s_is_in <= false;
        end;
    begin
	    if reset_n = '0' then
            state_reset;
        elsif rising_edge(clk) then
            if reset = '1' then
                state_reset; 
            else
                --reset state
                state := NONE;

                --variable-driven state identification
                if add_enable = '1' and not s_is_full then 
                    if current_ptr = write_ptr then --empty slot found
                        state := ADD_NEW;
                    elsif memory(to_integer(current_ptr)) = data_in then --data_in was found in the set
                        state := ADD_FOUND;
                    else
                        state := ADD_SEARCH; --data_in not found, continue search
                    end if;
                end if;

                --next_state and output update
                case state is
                when NONE => null;
                when ADD_NEW =>
                    write_ptr <= write_ptr + 1;
                    memory(to_integer(write_ptr)) <= data_in;
                    s_is_in <= false;
                    s_is_added_ok <= true;
                    current_ptr <= (others => '0'); --restart the current_ptr for the next search
                when ADD_FOUND =>
                    s_is_in <= true;
                    s_is_added_ok <= true;
                    current_ptr <= (others => '0'); --restart the current_ptr for the next search
                when ADD_SEARCH =>
                    current_ptr <= current_ptr + 1;
                    s_is_added_ok <= false;
                end case;
            end if;
        end if;
    end process;

    s_is_full <= true when write_ptr = CAPACITY else false;

    --output
    is_in     <= '1' when s_is_added_ok and s_is_in else '0';
    is_done  <= '1' when s_is_added_ok else '0';
    --add_error <= '1' when add_enable = '1' and s_is_full else '0';
    is_full   <= '1' when s_is_full else '0';

end architecture;