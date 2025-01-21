library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;
use work.des_pkg.all;

entity des_tb is
end entity des_tb;

architecture testbench of des_tb is
    -- Component signals
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal data_in    : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal key        : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal encrypt    : std_logic;
    signal data_out   : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal valid_out  : std_logic;
    
    -- Test control
    constant CLK_PERIOD : time := 10 ns;
    signal test_done : boolean := false;
    
    -- Test vectors
    type test_vector is record
        plaintext  : std_logic_vector(63 downto 0);
        key       : std_logic_vector(63 downto 0);
        ciphertext : std_logic_vector(63 downto 0);
    end record;
    
    type test_vector_array is array (natural range <>) of test_vector;
    constant test_vectors : test_vector_array := (
        -- Test vector 1 (Standard DES test vector)
        0 => (
            plaintext  => x"0000000000000000",
            key       => x"0000000000000000",
            ciphertext => x"8CA64DE9C1B123A7"
        ),
        -- Test vector 2
        1 => (
            plaintext  => x"0123456789ABCDEF",
            key       => x"133457799BBCDFF1",
            ciphertext => x"85E813540F0AB405"
        ),
        -- Test vector 3 (All bits set)
        2 => (
            plaintext  => x"FFFFFFFFFFFFFFFF",
            key       => x"FFFFFFFFFFFFFFFF",
            ciphertext => x"51866FD5B85ECB8A"
        )
    );

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
    clk <= not clk after CLK_PERIOD/2 when not test_done else '0';

    -- Test process
    test_proc: process
        procedure wait_cycles(n : integer) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
        end procedure;

        procedure print_result(
            test_num : integer;
            expected : std_logic_vector(63 downto 0);
            actual   : std_logic_vector(63 downto 0)
        ) is
            variable l : line;
        begin
            write(l, string'("Test #"));
            write(l, test_num);
            if expected = actual then
                write(l, string'(" PASSED"));
            else
                write(l, string'(" FAILED"));
                write(l, string'(" Expected: 0x"));
                hwrite(l, expected);
                write(l, string'(" Got: 0x"));
                hwrite(l, actual);
            end if;
            writeline(output, l);
        end procedure;

    begin
        -- Initial reset
        rst <= '1';
        encrypt <= '1';
        wait_cycles(2);
        rst <= '0';
        wait_cycles(1);

        -- Run encryption tests
        for i in test_vectors'range loop
            -- Set inputs
            data_in <= test_vectors(i).plaintext;
            key <= test_vectors(i).key;
            encrypt <= '1';
            
            -- Wait for result
            wait_cycles(20);
            
            -- Check result
            print_result(i, test_vectors(i).ciphertext, data_out);
            
            wait_cycles(2);

            -- Test decryption
            data_in <= data_out;
            encrypt <= '0';
            
            -- Wait for result
            wait_cycles(20);
            
            -- Check decryption result
            print_result(i+100, test_vectors(i).plaintext, data_out);
            
            wait_cycles(2);
        end loop;

        -- End simulation
        report "Simulation completed" severity note;
        test_done <= true;
        wait;
    end process;

end architecture testbench;