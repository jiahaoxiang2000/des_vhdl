-- filepath: /Users/xiangjiahao/embed/des_vhdl/src/des_entity.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.des_pkg.all;

entity des is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        data_in     : in  std_logic_vector(BLOCK_SIZE-1 downto 0);
        key        : in  std_logic_vector(BLOCK_SIZE-1 downto 0);
        encrypt    : in  std_logic;  -- '1' for encrypt, '0' for decrypt
        data_out   : out std_logic_vector(BLOCK_SIZE-1 downto 0);
        valid_out  : out std_logic
    );
end entity des;

architecture rtl of des is
begin
    -- Implementation will be added later
end architecture rtl;