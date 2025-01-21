library IEEE;
use IEEE.STD_LOGIC_1164.all;
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

    -- S-box substitution would go here
    -- For now, just pass through
    data_out(63 downto 32) <= right_half;
    data_out(31 downto 0) <= left_half xor xored(31 downto 0);

end architecture;