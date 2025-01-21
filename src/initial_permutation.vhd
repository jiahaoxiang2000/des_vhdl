library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.des_pkg.all;

entity initial_permutation is
    port (
        data_in  : in  std_logic_vector(63 downto 0);
        data_out : out std_logic_vector(63 downto 0)
    );
end entity;

architecture rtl of initial_permutation is
begin
    process(data_in)
    begin
        for i in 0 to 63 loop
            data_out(i) <= data_in(IP_TABLE(i) - 1);
        end loop;
    end process;
end architecture;