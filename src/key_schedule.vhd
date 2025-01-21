library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.des_pkg.all;
use ieee.numeric_std.all;

entity key_schedule is
    port (
        key     : in  std_logic_vector(63 downto 0);
        encrypt : in  std_logic;
        round_keys : out key_array
    );
end entity;

architecture rtl of key_schedule is
    signal pc1_key : std_logic_vector(55 downto 0);
    signal c, d : std_logic_vector(27 downto 0);
begin
    -- PC1 permutation
    pc1: process(key)
    begin
        for i in 0 to 55 loop
            pc1_key(i) <= key(PC1_TABLE(i) - 1);
        end loop;
    end process;

    -- Split into C and D blocks
    c <= pc1_key(55 downto 28);
    d <= pc1_key(27 downto 0);

    -- Generate round keys
    round_key_gen: process(c, d, encrypt)
        variable c_temp, d_temp : std_logic_vector(27 downto 0);
        variable c_next, d_next : std_logic_vector(27 downto 0);
        variable combined : std_logic_vector(55 downto 0);
    begin
        c_temp := c;
        d_temp := d;
        
        for i in 0 to 15 loop
            -- Calculate next C and D blocks with rotation
            if KEY_ROTATIONS(i) = 1 then
                c_next := c_temp(26 downto 0) & c_temp(27);
                d_next := d_temp(26 downto 0) & d_temp(27);
            else -- rotation by 2
                c_next := c_temp(25 downto 0) & c_temp(27 downto 26);
                d_next := d_temp(25 downto 0) & d_temp(27 downto 26);
            end if;
            
            -- Combine C and D blocks
            combined := c_next & d_next;
            
            -- PC2 permutation with encrypt/decrypt handling
            for j in 0 to 47 loop
                if encrypt = '1' then
                    round_keys(i)(j) <= combined(PC2_TABLE(j) - 1);
                else
                    round_keys(15-i)(j) <= combined(PC2_TABLE(j) - 1);
                end if;
            end loop;

            -- Update for next round
            c_temp := c_next;
            d_temp := d_next;
        end loop;
    end process;
end architecture;