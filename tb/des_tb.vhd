-- filepath: /Users/xiangjiahao/embed/des_vhdl/tb/des_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.des_pkg.all;

entity des_tb is
end entity des_tb;

architecture testbench of des_tb is
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal data_in    : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal key        : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal encrypt    : std_logic;
    signal data_out   : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal valid_out  : std_logic;
    
    constant CLK_PERIOD : time := 10 ns;
begin
    -- DES instance
    DUT: entity work.des
    port map (
        clk       => clk,
        rst       => rst,
        data_in   => data_in,
        key       => key,
        encrypt   => encrypt,
        data_out  => data_out,
        valid_out => valid_out
    );

    -- Clock generation
    clk <= not clk after CLK_PERIOD/2;

    -- Test process
    test_proc: process
    begin
        -- Reset
        rst <= '1';
        wait for CLK_PERIOD*2;
        rst <= '0';
        
        -- Test vector (will be expanded)
        data_in <= x"0123456789ABCDEF";
        key     <= x"133457799BBCDFF1";
        encrypt <= '1';
        
        wait for CLK_PERIOD*20;
        
        -- Add more test cases here
        
        wait;
    end process;
end architecture testbench;