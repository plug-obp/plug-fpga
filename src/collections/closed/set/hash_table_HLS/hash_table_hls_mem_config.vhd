-- ==============================================================
-- File generated on Fri Apr 19 02:24:23 CEST 2019
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
-- SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
-- IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hash_table_hls_mem_config is
    generic (
        DataWidth    : integer := 6;
        AddressWidth : integer := 12;
        AddressRange : integer := 4096
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        address0 : in  std_logic_vector(AddressWidth-1 downto 0);
        ce0      : in  std_logic;
        we0      : in  std_logic;
        d0       : in  std_logic_vector(DataWidth-1 downto 0);
        q0       : out std_logic_vector(DataWidth-1 downto 0)
    );
end entity;

architecture arch of hash_table_hls_mem_config is
    --------------------- Component ---------------------
    component hash_table_hls_mem_config_ram is
        port (
            clk   : in  std_logic;
            ce0   : in  std_logic;
            addr0 : in  std_logic_vector(AddressWidth-1 downto 0);
            we0   : in  std_logic;
            d0    : in  std_logic_vector(DataWidth-1 downto 0);
            q0    : out std_logic_vector(DataWidth-1 downto 0)
        );
    end component;
    --------------------- Local signal ------------------
    signal written : std_logic_vector(AddressRange-1 downto 0) := (others => '0');
    signal q0_ram  : std_logic_vector(DataWidth-1 downto 0);
    signal q0_rom  : std_logic_vector(DataWidth-1 downto 0);
    signal q0_sel  : std_logic;
    signal sel0_sr : std_logic_vector(0 downto 0);
begin
    --------------------- Instantiation -----------------
    hash_table_hls_mem_config_ram_u : component hash_table_hls_mem_config_ram
    port map (
        clk   => clk,
        ce0   => ce0,
        addr0 => address0,
        we0   => we0,
        d0    => d0,
        q0    => q0_ram
    );
    --------------------- Assignment --------------------
    q0     <= q0_ram when q0_sel = '1' else q0_rom;
    q0_sel <= sel0_sr(0);
    q0_rom <= "000000";

    process (clk, reset) begin
        if reset = '1' then
            written <= (others => '0');
        elsif clk'event and clk = '1' then
            if ce0 = '1' and we0 = '1' then
                written(to_integer(unsigned(address0))) <= '1';
            end if;
        end if;
    end process;

    process (clk) begin
        if clk'event and clk = '1' then
            if ce0 = '1' then
                sel0_sr(0) <= written(to_integer(unsigned(address0)));
            end if;
        end if;
    end process;

end architecture;
