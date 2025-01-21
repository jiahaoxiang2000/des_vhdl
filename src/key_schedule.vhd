library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.des_pkg.all;

entity key_schedule is
    port (
        key     : in  std_logic_vector(63 downto 0);
        encrypt : in  std_logic;
        round_keys : out key_array
    );
end entity;

architecture rtl of key_schedule is
    signal pc1_key : std_logic_vector(55 downto 0);
begin
    -- PC1 permutation
    process(key)
    begin
        -- Simplified key schedule - just take 56 bits
        pc1_key <= key(55 downto 0);
    end process;

    -- Generate round keys
    process(pc1_key, encrypt)
    begin
        for i in 0 to 15 loop
            if encrypt = '1' then
                round_keys(i) <= pc1_key(47 downto 0);
            else
                round_keys(15-i) <= pc1_key(47 downto 0);
            end if;
        end loop;
    end process;
end architecture;