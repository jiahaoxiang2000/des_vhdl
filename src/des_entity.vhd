-- filepath: /Users/xiangjiahao/embed/des_vhdl/src/des_entity.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.des_pkg.all;

entity des is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        data_in   : in  std_logic_vector(63 downto 0);
        key       : in  std_logic_vector(63 downto 0);
        encrypt   : in  std_logic;
        data_out  : out std_logic_vector(63 downto 0);
        valid_out : out std_logic
    );
end entity;

architecture rtl of des is
    signal ip_out : std_logic_vector(63 downto 0);
    signal round_outputs : block_array;
    signal round_keys : key_array;
    signal final_round : std_logic_vector(63 downto 0);
begin
    -- Initial permutation
    ip: initial_permutation
    port map (
        data_in  => data_in,
        data_out => ip_out
    );

    -- Key schedule
    ks: key_schedule
    port map (
        key        => key,
        encrypt    => encrypt,
        round_keys => round_keys
    );

    -- First round input
    round_outputs(0) <= ip_out;

    -- Generate 16 rounds
    rounds_gen: for i in 0 to 15 generate
        round_x: round
        port map (
            data_in  => round_outputs(i),
            key      => round_keys(i),
            data_out => round_outputs(i+1)
        );
    end generate;

    -- Final permutation
    fp: final_permutation
    port map (
        data_in  => round_outputs(16),
        data_out => final_round
    );

    -- Output register
    process(clk, rst)
    begin
        if rst = '1' then
            data_out <= (others => '0');
            valid_out <= '0';
        elsif rising_edge(clk) then
            data_out <= final_round;
            valid_out <= '1';
        end if;
    end process;

end architecture;