library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pingpong_fifo_b_tb is end entity;

-- R1 : the FIFO is always eventually full []<>full
-- R2 : the FIFO is always eventually empty []<>empty
-- R3 : the FIFO is full iff the is_full is asserted : G is_full <-> write_ptr+1=read_ptr (COUNTER = CAPACITY)
-- R4 : the FIFO is empty iff the is_empty is asserted : G is_empty <-> write_ptr = read_ptr (COUNTER = 0)


architecture test1 of pingpong_fifo_b_tb is
    constant CLK_PERIOD : time := 100 ns;
    constant ADDRESS_WIDTH : integer := 2;
    constant DATA_WIDTH : integer := 4;
    constant CAPACITY :integer := 2**ADDRESS_WIDTH;
    signal clk, rst, rst_n : std_logic := '0';
    signal do_pop, do_push : std_logic := '0';
    signal is_empty, is_full, is_last : std_logic;
    signal data_in : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal data_out : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal data_ready : std_logic;
	signal pop_done, push_done : std_logic; 

    signal simulation_end : boolean := false;
begin

    clk <= not clk after CLK_PERIOD/2 when not simulation_end else '0';

dut : entity work.pingpong_fifo_b(b)
    generic map (ADDRESS_WIDTH => ADDRESS_WIDTH, DATA_WIDTH => DATA_WIDTH)
	port map (
		clk => clk,
		reset => rst,
		reset_n => rst_n,
		pop_enable => do_pop,
		push_enable	=> do_push,
		data_in => data_in,
		data_out => data_out,
		data_ready => data_ready,
		is_empty => is_empty,
		is_full	=> is_full, 
		is_last => is_last, 
		pop_is_done => pop_done, 
		push_is_done => push_done,
		swap => '0'
	);

scenario : process
	procedure async_reset is
	begin
		wait until rising_edge(clk);
		wait for CLK_PERIOD / 4;
		rst_n <= '0';
		wait for CLK_PERIOD / 2;
		rst_n <= '1';
	end procedure;

	procedure add_element(object : std_logic_vector(DATA_WIDTH-1 downto 0)) is
	begin
		wait until rising_edge(clk);
		do_push <= '1';
		data_in <= object;
		wait until rising_edge(clk);
		do_push <= '0';
		data_in <= (others => '0');
		wait for CLK_PERIOD/2;
	end procedure;

	procedure read_element(expected:std_logic_vector(DATA_WIDTH-1 downto 0)) is
	begin
		wait until rising_edge(clk);
		do_pop <= '1';
		wait until rising_edge(clk);
		do_pop <= '0';
		wait until data_ready = '1';
		assert data_out = expected report "read does not match expected" severity error;
		wait for CLK_PERIOD/2;
	end procedure;
	begin
		--default values
		rst <= '0';
		do_pop <= '0';
		do_push <= '0';
		data_in <= (others => '0');
		--reset the circuit
		async_reset;

		assert is_empty = '1' report "after reset the fifo should be empty" severity error;
		assert is_full = '0' report "after reset the fifo should not be full" severity error;

		for i in 1 to CAPACITY loop
			add_element(std_logic_vector(to_unsigned(i, DATA_WIDTH)));
			assert is_empty = '0' report "the fifo not empty if element added" severity error;
		end loop;

		assert is_full = '1' report "after adding CAPACITY elements the FIFO is full" severity error;

		--simultaneous push pop when full
		wait until rising_edge(clk);
		do_pop <= '1';
		do_push <= '1';
		data_in <= B"1000";
		wait until rising_edge(clk);
		do_pop <= '0';
		do_push <= '0';
		data_in <= (others => '0');
		wait until data_ready = '1';
		assert data_out = B"0001" report "read does not match expected" severity error;
		wait for CLK_PERIOD/2;

		for i in 1 to CAPACITY loop
			if i = CAPACITY then
				read_element(B"1000");
			else
				read_element(std_logic_vector(to_unsigned(i+1, DATA_WIDTH)));
			end if;
			assert is_full = '0' report "the fifo not full if element removed" severity error;
		end loop;

		assert is_empty = '1' report "after reading CAPACITY elements the FIFO is empty" severity error;

		--simultaneous push pop when empty
		wait until rising_edge(clk);
		do_pop <= '1';
		do_push <= '1';
		data_in <= (others => '1');
		wait until rising_edge(clk);
		do_pop <= '0';
		do_push <= '0';
		data_in <= (others => '0');
		wait until data_ready = '1';
		assert data_out = B"1111" report "read does not match expected" severity error;
		wait for CLK_PERIOD/2;

		simulation_end <= true;
		wait;
	end process;


end architecture;



