library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;  -- Add this line
use work.des_pkg.all;

entity round is
    port (
        data_in  : in  std_logic_vector(63 downto 0);
        key      : in  std_logic_vector(47 downto 0);
        data_out : out std_logic_vector(63 downto 0)
    );
end entity;

architecture rtl of round is
    signal left_half, right_half : std_logic_vector(31 downto 0);
    signal expanded_r : std_logic_vector(47 downto 0);
    signal xored : std_logic_vector(47 downto 0);
begin
    -- Split input into left and right halves
    left_half <= data_in(63 downto 32);
    right_half <= data_in(31 downto 0);

    -- Expansion
    exp: process(right_half)
    begin
        for i in 0 to 47 loop
            expanded_r(i) <= right_half(E_TABLE(i) - 1);
        end loop;
    end process;

    -- XOR with round key
    xored <= expanded_r xor key;

    -- S-box substitution
    sbox: process(xored)
        variable sbox_in : std_logic_vector(5 downto 0);
        variable row_bits : std_logic_vector(1 downto 0);
        variable row : integer range 0 to 3;
        variable col : integer range 0 to 15;
        variable sbox_out : std_logic_vector(31 downto 0);
        variable p_out : std_logic_vector(31 downto 0);
    begin
        -- S-box substitution
        for i in 0 to 7 loop
            sbox_in := xored(i*6+5 downto i*6);
            row_bits(1) := sbox_in(5);
            row_bits(0) := sbox_in(0);
            row := to_integer(unsigned(row_bits));
            col := to_integer(unsigned(sbox_in(4 downto 1)));
            sbox_out((7-i)*4+3 downto (7-i)*4) := S_BOXES(i)(row * 16 + col);
        end loop;

        -- P-box permutation
        for i in 0 to 31 loop
            p_out(i) := sbox_out(P_TABLE(i) - 1);
        end loop;

        -- Feistel network structure
        data_out(63 downto 32) <= right_half;  -- Left half gets previous right half
        data_out(31 downto 0) <= left_half xor p_out;  -- Right half gets L xor f(R,K)
    end process;

end architecture;